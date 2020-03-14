<template>
  <div>
    <b-row align-h="between" class="p-2 mt-5 mb-2">
      <div></div>
      <span style="font-size: 20px">Manage Brands</span>
      <Button variant="green" @click="openNewModal">Add Brand</Button>
    </b-row>
    <b-row align-h="center">
      <b-table
        :fields="brandFields"
        :items="brands"
        head-variant="light"
        bordered
        style="font-size: 14px; max-width: 800px"
      >
        <!-- Table data -->
        <template v-slot:cell(actions)="data">
          <font-awesome-icon :icon="['far', 'edit']" fixed-width />
        </template>
      </b-table>
    </b-row>

    <!-- Add Brand Modal -->
    <b-modal v-model="addModalShow" centered static no-close-on-backdrop no-close-on-esc>
      <template #modal-title>
        <h5>{{ formTitle }}</h5>
      </template>
      <!-- <b-form-row>
        <b-col>
          <b-row align-h="center" class="pb-3">
            <img v-if="form.image_url" :src="form.image_url" ref="imagePreview" style="height: 60px" />
            <img v-else ref="imagePreview" style="height: 60px" />
            <b-spinner v-if="uploadingImage" small type="grow"></b-spinner>
          </b-row>
          <b-row align-h="center">
            <div id="uppy-target"></div>
          </b-row>
          <input type="hidden" v-model="form.image" />
        </b-col>
      </b-form-row> -->
      <b-form-row>
        <b-col>
          <b-form-group label="Name (Chinese)" label-size="sm">
            <b-input v-model="form.name_zh" size="sm" />
          </b-form-group>
        </b-col>
      </b-form-row>
      <b-form-row>
        <b-col>
          <b-form-group label="Name (English)" label-size="sm">
            <b-input v-model="form.name_en" size="sm" />
          </b-form-group>
        </b-col>
      </b-form-row>
      <template #modal-footer>
        <Button @click="close">Cancel</Button>
        <Button variant="green" :disabled="!form.name_en" class="float-right" @click="save">Save</Button>
      </template>
    </b-modal>
  </div>
</template>

<script>
import { normalize, schema } from 'normalizr';
// import Uppy from '@uppy/core';
// import FileInput from '@uppy/file-input';
// import AwsS3 from '@uppy/aws-s3';
import Button from './shared/Button';

export default {
  name: 'AdminBrandIndex',
  components: { Button },
  data() {
    return {
      brandData: {},
      brandList: [],
      mode: 'new',
      addModalShow: false,
      imageUrl: '',
      form: {
        name_en: '',
        name_zh: ''
      },
      // brandOptions: [
      //   'Tung-I',
      //   'Hsin Tung Yang',
      //   'Want Want',
      //   'Chi-Sheng',
      //   'Kimlan',
      //   'Little Cook Noodle',
      //   "King's Cook"
      // ],
      brandFields: [
        { key: 'name_en', label: 'Name (en)', thClass: 'font-lato-th' },
        { key: 'name_zh', label: 'Name (ch)', thClass: 'font-lato-th' },
        { key: 'actions', sortable: false, label: 'Actions', thClass: 'text-center font-lato-th', tdClass: 'text-center' }
      ],
      uploadingImage: false,
      loading: false,
      processing: false
    }
  },
  mounted() {
    this.fetchBrands();

    // const uppy = new Uppy({
    //   debug: true,
    //   autoProceed: true
    // })
    // .use(FileInput, {
    //   target: '#uppy-target',
    //   pretty: true,
    //   replaceTargetContent: false,
    //   locale: {
    //     strings: {
    //       chooseFiles: 'Choose image file'
    //     }
    //   }
    // })
    // .use(AwsS3, {
    //   getUploadParameters: function (file) {
    //     var filename = encodeURIComponent(file.name)
    //     var type     = encodeURIComponent(file.type)

    //     return fetch('/presign?filename=' + filename + '&type=' + type, { // Shrine's presign endpoint
    //       credentials: 'same-origin', // send cookies
    //     }).then(function (response) { return response.json() })
    //   }
    // })

    // uppy.on('upload', (data) => {
    //   this.uploadingImage = true;
    // })

    // uppy.on('upload-success', (file, response) => {
    //   // construct uploaded file data in the format that Shrine expects
    //   let uploadedFileData = JSON.stringify({
    //     id: file.meta['key'].match(/^cache\/(.+)/)[1], // object key without prefix
    //     storage: 'cache',
    //     metadata: {
    //       size:      file.size,
    //       filename:  file.name,
    //       mime_type: file.type,
    //     }
    //   })
    //   console.log(file)
    //   console.log(response)
    //   // set hidden field value to the uploaded file data so that it's submitted with the form as the attachment
    //   this.form.image = uploadedFileData;

    //   // show image preview
    //   this.$refs.imagePreview.src = URL.createObjectURL(file.data);

    //   // use cached version of AWS image URL for form submital
    //   this.imageUrl = response.uploadURL;

    //   this.uploadingImage = false;
    // })
  },
  computed: {
    formTitle() {
      return this.mode === 'new' ? 'New Brand' : 'Edit Brand'
    },
    brands() {
      let array = this.brandList.map(id => this.brandData[id]);
      return array.sort((a,b) => a.name_en - b.name_en);
    }
  },
  methods: {
    fetchBrands() {
      this.loading = true;
      this.$http.get('/brands')
        .then(response => {
          console.log(response.data)

          const brandData = normalize(
            { brands: response.data },
            { brands: [ new schema.Entity('brands') ] }
          );
          if (brandData.entities.hasOwnProperty('brands')) { // in case of empty data
            this.brandData = brandData.entities.brands;
          }
          this.brandList = brandData.result.brands;
        })
        .catch(error => {
          console.log(error)
        })
        .finally(() => this.loading = false);
    },
    editItem(product) {
      this.mode = 'edit';
      this.editedItem = Object.assign({}, product);
      this.addModalShow = true;
    },
    openNewModal() {
      this.mode = 'new';
      // this.imageUrl = '';
      this.name_en = '';
      this.name_zh = '';
      // this.image = null;
      this.addModalShow = true;
    },
    save() {
      if (this.mode === 'edit') {
        // Object.assign(this.products[this.editedIndex], this.editedItem)
        this.updateProduct(product);
      } else {
        this.createProduct()
      }
      this.close()
    },
    close() {
      this.mode = 'new'
      this.addModalShow = false
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.$refs.imagePreview.src = '';
      }, 300)
    }
  }
}
</script>

<style scoped>
.radio-group-label {
  font-size: 12px;
  text-align: center;
}
.v-input--radio-group {
  margin-top: 0;
}
#file-input {
  border: 1px dashed #aaa;
}
</style>
