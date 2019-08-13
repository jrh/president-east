<template>
  <div>
    <b-row align-h="between" class="p-2 mt-5 mb-2">
      <div></div>
      <span style="font-size: 20px">Manage Products</span>
      <Button variant="green" @click="openNewModal">Add Product</Button>
    </b-row>
    <b-table
      :fields="fields"
      :items="products"
      head-variant="light"
      bordered
      style="font-size: 14px"
    >
      <!-- Table data -->
      <template #actions="data">
        <font-awesome-icon :icon="['far', 'edit']" fixed-width />
      </template>
    </b-table>

    <!--  Modal -->
    <b-modal v-model="modalShow" centered static no-close-on-backdrop no-close-on-esc>
      <template #modal-title>
        <h5>{{ formTitle }}</h5>
      </template>
      <b-form-row>
        <b-col>
          <b-form-group label="Item No." label-size="sm">
            <b-input v-model="form.item_no" type="number" size="sm" autofocus />
          </b-form-group>
        </b-col>
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
      </b-form-row>
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
      <b-form-row>
        <b-col>
          <b-form-group label="Brand" label-size="sm">
            <b-select
              v-model="form.brand_en"
              :options="brandOptions"
              size="sm">
            </b-select>
          </b-form-group>
        </b-col>
      </b-form-row>
      <b-form-row>
        <b-col>
          <b-form-group label="Box Quantity" label-size="sm">
            <b-input v-model="form.box_quantity" size="sm" />
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group label="Storage Temp" label-size="sm">
            <b-select
              v-model="form.storage_temp"
              :options="storageOptions"
              size="sm">
            </b-select>
          </b-form-group>
        </b-col>
      </b-form-row>
      <template #modal-footer>
        <Button @click="close">Cancel</Button>
        <Button variant="green" :disabled="uploadingImage || !form.item_no || !form.name_en" class="float-right" @click="save">Save</Button>
      </template>
    </b-modal>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import Uppy from '@uppy/core';
import FileInput from '@uppy/file-input';
import AwsS3 from '@uppy/aws-s3';
import Button from './shared/Button';

export default {
  name: 'AdminProductIndex',
  components: { Button },
  data() {
    return {
      fields: [
        { key: 'item_no', label: 'Item No.', thClass: 'font-lato-th' },
        { key: 'name_en', label: 'Name (en)', thClass: 'font-lato-th' },
        { key: 'name_zh', label: 'Name (ch)', thClass: 'font-lato-th' },
        { key: 'brand_en', label: 'Brand', thClass: 'text-center font-lato-th', tdClass: 'text-center' },
        { key: 'box_quantity', label: 'Box Quantity', thClass: 'text-center font-lato-th', tdClass: 'text-center' },
        { key: 'storage_temp', label: 'Storage Temp', thClass: 'text-center font-lato-th', tdClass: 'text-center' },
        { key: 'actions', sortable: false, label: 'Actions', thClass: 'text-center font-lato-th', tdClass: 'text-center' }
      ],
      mode: 'new',
      modalShow: false,
      imageUrl: '',
      form: {
        id: null,
        item_no: '',
        name_en: '',
        name_zh: '',
        brand_en: '',
        box_quantity: '',
        storage_temp: 'Room',
        image: null
      },
      brandOptions: [
        'Tung-I',
        'Hsin Tung Yang',
        'Want Want',
        'Chi-Sheng',
        'Kimlan',
        'Little Cook Noodle',
        "King's Cook"
      ],
      storageOptions: ['Room', 'Cooler', 'Frozen'],
      uploadingImage: false,
      loading: false,
      processing: false
    }
  },
  created() {
    this.fetchProducts();
  },
  mounted() {
    const uppy = new Uppy({
      debug: true,
      autoProceed: true
    })
    .use(FileInput, {
      target: '#uppy-target',
      pretty: true,
      replaceTargetContent: false,
      locale: {
        strings: {
          chooseFiles: 'Choose image file'
        }
      }
    })
    .use(AwsS3, {
      getUploadParameters: function (file) {
        var filename = encodeURIComponent(file.name)
        var type     = encodeURIComponent(file.type)

        return fetch('/presign?filename=' + filename + '&type=' + type, { // Shrine's presign endpoint
          credentials: 'same-origin', // send cookies
        }).then(function (response) { return response.json() })
      }
    })

    uppy.on('upload', (data) => {
      this.uploadingImage = true;
    })

    uppy.on('upload-success', (file, response) => {
      // construct uploaded file data in the format that Shrine expects
      let uploadedFileData = JSON.stringify({
        id: file.meta['key'].match(/^cache\/(.+)/)[1], // object key without prefix
        storage: 'cache',
        metadata: {
          size:      file.size,
          filename:  file.name,
          mime_type: file.type,
        }
      })
      console.log(file)
      console.log(response)
      // set hidden field value to the uploaded file data so that it's submitted with the form as the attachment
      this.form.image = uploadedFileData;

      // show image preview
      this.$refs.imagePreview.src = URL.createObjectURL(file.data);

      // use cached version of AWS image URL for form submital
      this.imageUrl = response.uploadURL;

      this.uploadingImage = false;
    })
  },
  computed: {
    ...mapGetters(['products']),
    formTitle() {
      return this.mode === 'new' ? 'New Product' : 'Edit Product'
    }
  },
  watch: {
    modalShow (val) {
      val || this.close()
    }
  },
  methods: {
    ...mapActions(['fetchProducts', 'updateProduct']),
    editItem(product) {
      this.mode = 'edit';
      this.editedItem = Object.assign({}, product);
      this.modalShow = true;
    },
    openNewModal() {
      this.mode = 'new';
      this.imageUrl = '';
      this.id = null,
      this.item_no = '';
      this.name_en = '';
      this.name_zh = '';
      this.brand_en = '';
      this.box_quantity = '';
      this.storage_temp = 'Room';
      this.image = null;
      this.modalShow = true;
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
      this.modalShow = false
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.$refs.imagePreview.src = '';
      }, 300)
    },
    createProduct() {
      if (this.processing) return;
      this.processing = true;
      this.$http.post('/products', {
          product: this.form  // unpermitted parameters image_data image_url
        })
        .then(response => {
          console.log(response);
          let createdProduct = response.data;
          createdProduct['image_url'] = this.imageUrl;

          this.$store.commit('addProduct', createdProduct);
          this.imageUrl = '';
          // clear form
        })
        .catch(error => console.log(error))
        .finally(() => this.processing = false);
    },
    updateProduct(product) {
      this.$http.put(`/products/${product.id}`, {
        product: {
          item_no: product.item_no,
          name_en: product.name_en,
          name_zh: product.name_zh,
          brand_en: product.brand_en,
          box_quantity: product.box_quantity,
          storage_temp: product.storage_temp,
          image: product.image
        }
      })
      .then(response => {
        console.log(response);
        this.$store.commit('setProduct', response.data);
      })
      .catch(error => console.log(error))
    },
    deleteItem(product) {
      //const index = this.products.indexOf(item)
      //confirm('Are you sure you want to delete this item?') && this.products.splice(index, 1)
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
