<template>
  <div>
    <b-row align-h="between" class="pt-2 px-4 mt-5 mb-2">
      <div></div>
      <span style="font-size: 20px">Manage Products</span>
      <Button variant="green" @click="openNewModal">Add Product</Button>
    </b-row>
    <b-table
      :fields="fields"
      :items="products"
      head-variant="light"
      bordered
      hover
      style="font-size: 14px"
      @row-clicked="goToProduct"
    >
      <!-- Table data -->
      <template v-slot:cell(photo)="data">
        <font-awesome-icon v-if="!data.item.image_url" :icon="['fas', 'exclamation-circle']" fixed-width size="lg" title="Missing photo" class="text-danger" />
      </template>
      <template v-slot:cell(status)="data">
        <span :class="{'text-success': data.value == 'active', 'text-danger': data.value == 'inactive'}">{{ data.value | titleize }}</span>
      </template>
      <template v-slot:cell(brand_id)="data">
        {{ brandData[data.value].name_en }}
      </template>
      <template v-slot:cell(actions)="data">
        <Button size="sm" class="py-0">
          <font-awesome-icon :icon="['far', 'edit']" fixed-width />
          <span class="pl-1">Status</span>
        </Button>
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
          <b-form-group label="Name (English)" label-size="sm">
            <b-input v-model="form.name_en" size="sm" />
          </b-form-group>
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
          <b-form-group label="Brand" label-size="sm">
            <b-select
              v-model="form.brand_id"
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
import { mapGetters } from 'vuex';
import { normalize, schema } from 'normalizr';
import { ValidationObserver, ValidationProvider } from 'vee-validate';
import Uppy from '@uppy/core';
import FileInput from '@uppy/file-input';
import AwsS3 from '@uppy/aws-s3';
import Button from './shared/Button';

export default {
  name: 'AdminProductIndex',
  components: { Button, ValidationObserver, ValidationProvider },
  data() {
    return {
      productData: {},
      productList: [],
      brandData: {},
      brandList: [],
      fields: [
        { key: 'photo', label: '', tdClass: 'text-center clickable' },
        { key: 'item_no', label: 'Item No.', thClass: 'font-lato-th', tdClass: 'clickable' },
        { key: 'name_en', label: 'Name (en)', thClass: 'font-lato-th', tdClass: 'clickable' },
        { key: 'name_zh', label: 'Name (ch)', thClass: 'font-lato-th', tdClass: 'clickable' },
        { key: 'status', label: 'Status', thClass: 'text-center font-lato-th', tdClass: 'text-center clickable' },
        { key: 'brand_id', label: 'Brand', thClass: 'text-center font-lato-th', tdClass: 'text-center clickable' },
        { key: 'storage_temp', label: 'Storage Temp', thClass: 'text-center font-lato-th', tdClass: 'text-center clickable' },
        { key: 'actions', sortable: false, label: 'Actions', thClass: 'text-center font-lato-th', tdClass: 'text-center clickable' }
      ],
      mode: 'new',
      modalShow: false,
      imageUrl: '',
      form: {
        id: null,
        item_no: '',
        name_en: '',
        name_zh: '',
        brand_id: '',
        box_quantity: '',
        storage_temp: 'Room',
        image: null
      },
      storageOptions: ['Room', 'Cooler', 'Frozen'],
      uploadingImage: false,
      loading: false,
      processing: false
    }
  },
  computed: {
    ...mapGetters(['isAdmin']),
    products() {
      return this.productList.map(id => this.productData[id]);
    },
    brands() {
      return this.brandList.map(id => this.brandData[id]);
    },
    formTitle() {
      return this.mode === 'new' ? 'New Product' : 'Edit Product'
    },
    brandOptions() {
      return this.brands.map(brand => ({ text: brand.name_en, value: brand.id }))
    }
  },
  watch: {
    modalShow (val) {
      val || this.close()
    }
  },
  mounted() {
    this.fetchProducts();

    const uppy = Uppy({
      debug: true,
      autoProceed: true,
      restrictions: {
        maxFileSize: 10000000,
        maxNumberOfFiles: 1,
        minNumberOfFiles: 1,
        allowedFileTypes: ['image/*', '.jpg', '.jpeg', '.JPG', '.JPEG', '.png', '.PNG']
      },
    })
    .use(FileInput, {
      target: '#uppy-target',
      pretty: true,
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
  methods: {
    fetchProducts() {
      this.loading = true;
      this.$http.get('/admin/products')
        .then(response => {
          console.log(response.data)

          const productData = normalize(
            { products: response.data.products },
            { products: [ new schema.Entity('products') ] }
          );
          if (productData.entities.hasOwnProperty('products')) {
            this.productData = productData.entities.products;
          }
          this.productList = productData.result.products;

          const brandData = normalize(
            { brands: response.data.brands },
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
      this.$http.post('/admin/products', {
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
      this.$http.put(`/admin/products/${product.id}`, {
        product: {
          item_no: product.item_no,
          name_en: product.name_en,
          name_zh: product.name_zh,
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
    goToProduct(item) {
      this.$router.push(`/products/${item.id}`);
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
