<template>
  <div>
    <b-row align-h="between" class="pt-2 px-4 mt-5 mb-2">
      <div></div>
      <span style="font-size: 20px">Manage Brands</span>
      <Button variant="green" @click="addModalShow = true">Add Brand</Button>
    </b-row>
    <b-row align-h="center">
      <b-table
        :fields="brandFields"
        :items="brands"
        head-variant="light"
        bordered
        show-empty
        style="font-size: 14px; max-width: 800px"
      >
        <!-- Table data -->
        <template v-slot:cell(actions)="data">
          <font-awesome-icon :icon="['far', 'edit']" fixed-width />
        </template>
      </b-table>
    </b-row>

    <!-- Add Brand Modal -->
    <b-modal v-model="addModalShow" title="Add brand" centered no-close-on-backdrop no-close-on-esc>
      <ValidationObserver v-slot="{ invalid }">
        <b-row align-h="center">
          <ValidationProvider rules="required" name="Name (English)" v-slot="{ valid, errors }">
            <b-form-group label-size="sm" :invalid-feedback="errors[0]" style="width: 300px">
              <template #label>
                <span>Name (English)</span><span class="asterisk">*</span>
              </template>
              <b-input v-model="brandForm.name_en" autofocus size="sm" :state="errors[0] ? false : (valid ? true : null)" />
            </b-form-group>
          </ValidationProvider>
        </b-row>
        <b-row align-h="center">
          <b-form-group label="Name (Chinese)" label-size="sm" style="width: 300px">
            <b-input v-model="brandForm.name_zh" size="sm" :state="brandForm.name_zh ? true : null" />
          </b-form-group>
        </b-row>
        <b-row align-h="around" class="mt-3">
          <Button @click="addModalShow = false; clearForm()">Cancel</Button>
          <Button variant="green" :disabled="invalid" class="float-right" @click="createBrand">Save</Button>
        </b-row>
      </ValidationObserver>
      <template #modal-footer><span></span></template>
    </b-modal>

    <!-- Alert -->
    <ToastAlert :show="alertShow" :variant="alertVariant" @close="alertShow = false">
      {{ alertMessage }}
    </ToastAlert>
  </div>
</template>

<script>
import { normalize, schema } from 'normalizr';
import { ValidationObserver, ValidationProvider } from 'vee-validate';
// import Uppy from '@uppy/core';
// import FileInput from '@uppy/file-input';
// import AwsS3 from '@uppy/aws-s3';
import Button from './shared/Button';
import ToastAlert from './shared/ToastAlert';

export default {
  name: 'AdminBrandIndex',
  components: { Button, ToastAlert, ValidationObserver, ValidationProvider },
  data() {
    return {
      brandData: {},
      brandList: [],
      mode: 'new',
      addModalShow: false,
      imageUrl: '',
      brandForm: {
        name_en: '',
        name_zh: ''
      },
      brandFields: [
        { key: 'name_en', label: 'Name (en)', thClass: 'font-lato-th' },
        { key: 'name_zh', label: 'Name (ch)', thClass: 'font-lato-th' },
        { key: 'actions', sortable: false, label: 'Actions', thClass: 'text-center font-lato-th', tdClass: 'text-center' }
      ],
      uploadingImage: false,
      alertShow: false,
      alertVariant: null,
      alertMessage: '',
      loading: false,
      processing: false,
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
    brands() {
      return this.brandList.map(id => this.brandData[id]).sort((a,b) => a.name_en - b.name_en);
    }
  },
  methods: {
    fetchBrands() {
      this.loading = true;
      this.$http.get('/admin/brands')
        .then(response => {
          console.log(response.data)

          const brandData = normalize(
            { brands: response.data },
            { brands: [ new schema.Entity('brands') ] }
          );
          if (brandData.entities.hasOwnProperty('brands')) {
            this.brandData = brandData.entities.brands;
          }
          this.brandList = brandData.result.brands;
        })
        .catch(error => {
          console.log(error)
        })
        .finally(() => this.loading = false);
    },
    createBrand() {
      if (this.processing) return;
      this.processing = true;
      this.$http.post('/admin/brands', {
          brand: this.brandForm
        })
        .then(response => {
          console.log(response)
          this.brandList.push(response.data.id);
          this.$set(this.brandData, response.data.id, response.data);
          this.addModalShow = false;
          this.clearForm();
        })
        .catch(error => {
          console.log(error)
          this.alertShow = true;
          this.alertVariant = 'danger';
          if (error.response.data.errors) {
            this.alertMessage = error.response.data.errors[0];
          } else {
            this.alertMessage = 'Error: Something went wrong'
          }
        })
        .finally(() => this.processing = false);
    },
    clearForm() {
      this.brandForm.name_en = '';
      this.brandForm.name_zh = '';
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
