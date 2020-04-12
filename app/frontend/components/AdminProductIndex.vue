<template>
  <div>
    <b-row align-h="between" class="pt-2 px-4 mt-5 mb-2">
      <div></div>
      <span style="font-size: 20px">Manage Products</span>
      <Button variant="green" @click="newModalShow = true">Add Product</Button>
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
      <template v-slot:head(photo)>
        <font-awesome-icon :icon="['far', 'image']" fixed-width />
      </template>
      <!-- Table data -->
      <template v-slot:cell(photo)="data">
        <font-awesome-icon v-if="!data.item.image_url" :icon="['fas', 'exclamation-circle']" fixed-width size="lg" title="Missing photo" class="text-danger" />
      </template>
      <template v-slot:cell(status)="data">
        <span :class="{'text-success': data.value == 'active', 'text-warning': data.value == 'out_of_stock', 'text-danger': data.value == 'inactive'}">
          {{ data.value | titleize }}
        </span>
      </template>
      <template v-slot:cell(brand_id)="data">
        {{ brandData[data.value].name_en }}
      </template>
      <template v-slot:cell(actions)="data">
        <Button size="sm" class="py-0" @click="openStatusModal(data.item)">
          <font-awesome-icon :icon="['far', 'edit']" fixed-width />
          <span class="pl-1">Status</span>
        </Button>
      </template>
    </b-table>

    <!-- New modal -->
    <b-modal v-model="newModalShow" title="Add new product" centered static no-close-on-backdrop no-close-on-esc>
      <b-form-row>
        <b-col>
          <b-form-group label-size="sm">
            <template #label>
              <span>Item No.</span><span class="asterisk">*</span>
            </template>
            <b-input v-model="productForm.item_no" type="number" size="sm" autofocus />
          </b-form-group>
        </b-col>
        <b-col>
          <b-row align-h="center" class="pb-3">
            <img v-if="productForm.image_url" :src="productForm.image_url" ref="imagePreview" style="height: 60px" />
            <img v-else ref="imagePreview" style="height: 60px" />
            <b-spinner v-if="uploadingImage" small type="grow"></b-spinner>
          </b-row>
          <b-row align-h="center">
            <div id="uppy-target"></div>
          </b-row>
          <input type="hidden" v-model="productForm.image" />
        </b-col>
      </b-form-row>
      <b-form-row>
        <b-col>
          <b-form-group label-size="sm">
            <template #label>
              <span>Name (English)</span><span class="asterisk">*</span>
            </template>
            <b-input v-model="productForm.name_en" size="sm" />
          </b-form-group>
        </b-col>
      </b-form-row>
      <b-form-row>
        <b-col>
          <b-form-group label="Name (Chinese)" label-size="sm">
            <b-input v-model="productForm.name_zh" size="sm" />
          </b-form-group>
        </b-col>
      </b-form-row>
      <b-form-row>
        <b-col>
          <b-form-group label="Brand" label-size="sm">
            <b-select v-model="productForm.brand_id" :options="brandOptions" size="sm">
              <template #first>
                <b-select-option :value="null" disabled>- Choose a brand -</b-select-option>
              </template>
            </b-select>
          </b-form-group>
        </b-col>
      </b-form-row>
      <b-form-row>
        <b-col>
          <b-form-group label="Box Quantity" label-size="sm">
            <b-input v-model="productForm.box_quantity" size="sm" />
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group label="Storage Temp" label-size="sm">
            <b-select
              v-model="productForm.storage_temp"
              :options="storageOptions"
              size="sm">
            </b-select>
          </b-form-group>
        </b-col>
      </b-form-row>
      <template #modal-footer>
        <Button @click="close">Cancel</Button>
        <Button variant="green" :disabled="uploadingImage || !productForm.item_no || !productForm.name_en" class="float-right" @click="createProduct">Create</Button>
      </template>
    </b-modal>

    <!-- Status modal -->
    <b-modal v-model="statusModalShow" centered>
      <template #modal-title>
        <span v-if="selectedProduct">Edit status of {{ selectedProduct.name_en }}</span>
      </template>
      <b-row align-h="center" class="px-3">
        <b-form style="width: 300px">
          <b-form-group label="Status:">
            <b-radio-group v-model="statusForm.status" stacked>
              <b-radio value="active">Active</b-radio>
              <b-radio value="out_of_stock">Out of stock</b-radio>
              <b-radio value="inactive">Inactive</b-radio>
            </b-radio-group>
          </b-form-group>
        </b-form>
      </b-row>
      <b-row align="center" class="px-3">
        <small class="text-info font-italic">Note: Inactive products will not appear in the public product catalog</small>
      </b-row>
      <template #modal-footer>
        <b-row align-h="center">
          <Button variant="green" @click="updateProduct">Save</Button>
        </b-row>
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
        { key: 'photo', label: '', thClass: 'text-center', tdClass: 'text-center clickable' },
        { key: 'item_no', label: 'Item No.', thClass: 'font-lato-th', tdClass: 'clickable' },
        { key: 'name_en', label: 'Name (en)', thClass: 'font-lato-th', tdClass: 'clickable' },
        { key: 'name_zh', label: 'Name (ch)', thClass: 'font-lato-th', tdClass: 'clickable' },
        { key: 'brand_id', label: 'Brand', thClass: 'text-center font-lato-th', tdClass: 'text-center clickable' },
        { key: 'storage_temp', label: 'Storage Temp', thClass: 'text-center font-lato-th', tdClass: 'text-center clickable' },
        { key: 'status', label: 'Status', thClass: 'text-center font-lato-th', tdClass: 'text-center clickable' },
        { key: 'actions', sortable: false, label: 'Actions', thClass: 'text-center font-lato-th', tdClass: 'text-center clickable' }
      ],
      newModalShow: false,
      imageUrl: '',
      productForm: {
        id: null,
        item_no: null,
        name_en: null,
        name_zh: null,
        brand_id: null,
        box_quantity: null,
        storage_temp: 'Room',
        image: null
      },
      statusModalShow: false,
      statusForm: {
        status: null
      },
      selectedProduct: null,
      storageOptions: ['Room', 'Cooler', 'Frozen'],
      uploadingImage: false,
      loading: false,
      processing: false
    }
  },
  computed: {
    ...mapGetters(['isAdmin']),
    products() {
      return this.productList.map(id => this.productData[id]).sort((a,b) => a.item_no - b.item_no);
    },
    brands() {
      return this.brandList.map(id => this.brandData[id]);
    },
    brandOptions() {
      return this.brands.map(brand => ({ text: brand.name_en, value: brand.id }))
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
      companionUrl: '/'
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
      this.productForm.image = uploadedFileData;

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
    close() {
      this.newModalShow = false;
      this.clearProductForm();
      setTimeout(() => {
        this.$refs.imagePreview.src = '';
      }, 300)
    },
    createProduct() {
      if (this.processing) return;
      this.processing = true;
      this.$http.post('/admin/products', {
          product: this.productForm
        })
        .then(response => {
          console.log(response);
          let createdProduct = response.data;
          createdProduct['image_url'] = this.imageUrl;
          this.$set(this.productData, response.data.id, response.data);
          this.productList.push(response.data.id);
          this.newModalShow = false;
          this.clearProductForm();

          this.imageUrl = '';
        })
        .catch(error => console.log(error))
        .finally(() => this.processing = false);
    },
    openStatusModal(item) {
      this.selectedProduct = item;
      this.statusForm.status = item.status;
      this.statusModalShow = true;
    },
    updateProduct() {
      if (this.processing) return;
      this.processing = true;
      this.$http.put(`/admin/products/${this.selectedProduct.id}`, {
        product: this.statusForm
      })
      .then(response => {
        console.log(response);
        this.$set(this.productData, response.data.id, response.data);
        this.statusModalShow = false;
        this.statusForm.status = null;
        this.selectedProduct = null;
      })
      .catch(error => console.log(error))
      .finally(() => this.processing = false);
    },
    goToProduct(item) {
      this.$router.push(`/products/${item.id}`);
    },
    clearProductForm() {
      this.productForm.id = null
      this.productForm.item_no = null
      this.productForm.name_en = null
      this.productForm.name_zh = null
      this.productForm.brand_id = null
      this.productForm.box_quantity = null
      this.productForm.storage_temp = 'Room'
      this.productForm.image = null
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
