<template>
  <div class="pb-5">
    <b-row align-h="between" align-v="end" class="pt-2 px-4 mt-5 mb-2">
      <div>
        <small v-if="!loading && count" class="text-muted">Product count: {{ count }}</small>
      </div>
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
      @row-clicked="showProductDetail"
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
    <Observer @intersect="intersected" />

    <!-- New modal -->
    <b-modal
      v-model="newModalShow"
      title="Add new product"
      centered
      static
      no-close-on-backdrop
      no-close-on-esc
      @hide="clearValidationError"
    >
      <b-alert v-model="validationErrorShow" variant="danger" style="font-size: 13px">
        <font-awesome-icon :icon="['far', 'exclamation-circle']" fixed-width />
        <span class="pl-2">{{ validationErrorMessage }}</span>
      </b-alert>
      <b-form-row>
        <b-col>
          <b-form-group label-size="sm">
            <template #label>
              <span>Item No.</span><span class="asterisk">*</span>
            </template>
            <b-input v-model="productForm.item_no" type="number" size="sm" autofocus />
          </b-form-group>
        </b-col>
        <b-col></b-col>
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
          <b-form-group label-size="sm">
            <template #label>
              <span>Brand</span><span class="asterisk">*</span>
            </template>
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
        <Button variant="green" :disabled="!productForm.item_no || !productForm.name_en || !productForm.brand_id" class="float-right" @click="createProduct">Create</Button>
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
          <Button variant="green" @click="updateStatus">Save</Button>
        </b-row>
      </template>
    </b-modal>

    <!--Product detail modal -->
    <b-modal
      v-model="productDetailModalShow"
      size="lg"
      static
      centered
      hide-footer
      style="z-index: 1000"
      @hide="previewAttached = false"
    >
      <b-container>
        <b-alert show variant="warning">
          <span class="mr-5" style="font-size: 14px">Control Panel:</span>
          <Button size="sm" class="mr-3" id="uppy-select-files">
            <font-awesome-icon :icon="['far', 'image']" fixed-width />
            <span class="pl-2">Upload Photo</span>
          </Button>
          <Button size="sm" @click="openEditModal">
            <font-awesome-icon :icon="['far', 'edit']" fixed-width />
            <span class="pl-2">Edit Product Info</span>
          </Button>
          <!-- <Button size="sm" class="float-right" @click="openStatusModal">
            <font-awesome-icon :icon="['far', 'edit']" fixed-width />
            <span class="pl-2">Change Status</span>
          </Button> -->
        </b-alert>
      </b-container>
       <b-container class="mt-5">
        <b-row align-h="between" align-v="end" class="pb-1">
          <span class="text-info" style="font-size: 12px">What the customer sees in product catalog:</span>
          <div class="pr-1" style="font-size: 18px">
            <span class="pr-2">Status: </span>
            <span v-if="selectedProduct" :class="{'text-success': selectedProduct.status == 'active', 'text-warning': selectedProduct.status == 'out_of_stock', 'text-danger': selectedProduct.status == 'inactive'}">
              {{ selectedProduct.status | titleize }}
            </span>
          </div>
        </b-row>
      </b-container>
      <ProductDetail v-if="selectedProduct" :product="selectedProduct" :brandData="brandData" :previewAttached="previewAttached" class="p-3" style="border: 1px dotted #0f0f0f" />
    </b-modal>

    <!-- Edit modal -->
    <b-modal v-model="editModalShow" title="Edit product details" centered>
      <ValidationObserver v-slot="{ invalid }">
        <b-row>
          <b-col>
            <ValidationProvider rules="required" name="Item No." v-slot="{ errors }">
              <b-form-group label-size="sm">
                <template #label>
                  <span>Item No.</span><span class="asterisk">*</span>
                </template>
                <b-input v-model="productForm.item_no" type="number" size="sm" :state="errors[0] ? false : null" />
              </b-form-group>
            </ValidationProvider>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <ValidationProvider rules="required" name="Name (English)" v-slot="{ errors }">
              <b-form-group label-size="sm" :invalid-feedback="errors[0]">
                <template #label>
                  <span>Name (English)</span><span class="asterisk">*</span>
                </template>
                <b-input v-model="productForm.name_en" size="sm" autofocus :state="errors[0] ? false : null" />
              </b-form-group>
            </ValidationProvider>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <b-form-group label="Name (Chinese)" label-size="sm">
              <b-input v-model="productForm.name_zh" size="sm" />
            </b-form-group>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <b-form-group label="Brand" label-size="sm">
              <b-select
                v-model="productForm.brand_id"
                :options="brandOptions"
                size="sm">
              </b-select>
            </b-form-group>
          </b-col>
        </b-row>
        <b-row>
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
        </b-row>
        <b-row align-h="around" class="mt-3">
          <Button @click="editModalShow = false; clearProductForm()">Cancel</Button>
          <Button variant="green" :disabled="invalid" class="float-right" @click="updateProduct">Save</Button>
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
import Uppy from '@uppy/core';
import Dashboard from '@uppy/dashboard';
import AwsS3 from '@uppy/aws-s3';
import ProductDetail from './ProductDetail';
import Button from './shared/Button';
import Observer from './shared/Observer';
import ToastAlert from './shared/ToastAlert';

export default {
  name: 'AdminProductIndex',
  components: { ProductDetail, Button, Observer, ToastAlert, ValidationObserver, ValidationProvider },
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
      productForm: {
        item_no: null,
        name_en: null,
        name_zh: null,
        brand_id: null,
        box_quantity: null,
        storage_temp: 'Room'
      },
      editModalShow: false,
      selectedProduct: {},
      productDetailModalShow: false,
      statusModalShow: false,
      statusForm: {
        status: null
      },
      selectedProduct: null,
      previewAttached: false,
      photoForm: {
        image: null
      },
      storageOptions: ['Room', 'Cooler', 'Frozen'],
      alertShow: false,
      alertVariant: null,
      alertMessage: '',
      validationErrorShow: false,
      validationErrorMessage: '',
      loading: false,
      processing: false,
      addingPage: false,
      // pagination
      page: 1,
      count: null,
      last: null
    }
  },
  computed: {
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
    this.loading = true;
    this.fetchProducts();

    const uppy = Uppy({
      debug: true,
      autoProceed: true,
      allowMultipleUploads: false,
      restrictions: {
        maxFileSize: 10000000,
        maxNumberOfFiles: 1,
        minNumberOfFiles: 1,
        allowedFileTypes: ['image/*', '.jpg', '.jpeg', '.JPG', '.JPEG', '.png', '.PNG']
      },
    })
    .use(Dashboard, {
      target: 'body',
      trigger: '#uppy-select-files',
      thumbnailWidth: 400,
      closeAfterFinish: true,
      proudlyDisplayPoweredByUppy: false,
      locale: {
        strings: {
          dropPaste: 'Drop photo file here, or %{browse}'
        }
      }
    })
    .use(AwsS3, {
      companionUrl: '/'
    })

    uppy.on('upload', (data) => {
      this.previewAttached = true;
    })

    uppy.on('thumbnail:generated', (file, preview) => {
      let elem = document.createElement("img");
      elem.src = preview;
      elem.style.maxHeight = '300px';
      elem.style.maxWidth = '300px';
      let anchor = document.getElementById("previewAnchor");
      // anchor.firstChild.remove();
      anchor.appendChild(elem);
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
      this.photoForm.image = uploadedFileData;
      this.updatePhoto();
    })

    uppy.on('complete', (result) => {
      uppy.reset();
      console.log('successful files:', result.successful)
      console.log('failed files:', result.failed)
    })
  },
  methods: {
    fetchProducts() {
      console.log(`Product fetch: page ${this.page}`);
      if (this.processing) return;
      this.processing = true;
      this.$http.get('/admin/products', {
          params: {
            loading: this.loading,
            page: this.page
          }
        })
        .then(response => {
          console.log(response.data)

          const productData = normalize(
            { products: response.data.products },
            { products: [ new schema.Entity('products') ] }
          );

          if (this.addingPage) {
            // add to existing data
            if (productData.entities.hasOwnProperty('products')) {
              this.productData = Object.assign(this.productData, productData.entities.products);
            }
            this.productList = [...this.productList, ...productData.result.products];
          } else {
            // seed fresh data
            if (productData.entities.hasOwnProperty('products')) {
              this.productData = productData.entities.products;
            }
            this.productList = productData.result.products;
          }

          // If initial page load, load brands
          if (this.loading) {
            const brandData = normalize(
              { brands: response.data.brands },
              { brands: [ new schema.Entity('brands') ] }
            );
            if (brandData.entities.hasOwnProperty('brands')) {
              this.brandData = brandData.entities.brands;
            }
            this.brandList = brandData.result.brands;
          }

          this.count = response.data.pagy.count;
          this.last = response.data.pagy.last;
        })
        .catch(error => {
          console.log(error)
        })
        .finally(() => {
          this.loading = false;
          this.processing = false;
          this.addingPage = false;
        });
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
          this.$set(this.productData, response.data.id, response.data);
          this.productList.push(response.data.id);
          this.newModalShow = false;
          this.clearProductForm();
        })
        .catch(error => {
          console.log(error)
          if (error.response.data.errors) {
            this.validationErrorMessage = error.response.data.errors.join(', ')
            this.validationErrorShow = true;
          } else {
            this.alertVariant = 'danger';
            this.alertMessage = 'Error: Something went wrong';
            this.alertShow = true;
          }
        })
        .finally(() => this.processing = false);
    },
    openStatusModal(item) {
      this.selectedProduct = item;
      this.statusForm.status = item.status;
      this.statusModalShow = true;
    },
    openEditModal() {
      this.productForm.item_no = this.selectedProduct.item_no;
      this.productForm.name_en = this.selectedProduct.name_en;
      this.productForm.name_zh = this.selectedProduct.name_zh;
      this.productForm.brand_id = this.selectedProduct.brand_id;
      this.productForm.box_quantity = this.selectedProduct.box_quantity;
      this.productForm.storage_temp = this.selectedProduct.storage_temp;
      this.editModalShow = true;
    },
    updateStatus() {
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
    showProductDetail(item) {
      if (this.processing) return;
      this.processing = true;
      this.$http.get(`/products/${item.id}`)
        .then(response => {
          console.log(response)
          this.selectedProduct = response.data.product;
          this.productDetailModalShow = true;
        })
        .catch(error => {
          console.log(error)
        })
        .finally(() => this.processing = false);
    },
    updateProduct(product) {
      if (this.processing) return;
      this.processing = true;
      this.$http.put(`/admin/products/${this.selectedProduct.id}`, {
        product: this.productForm
      })
      .then(response => {
        console.log(response);
        this.selectedProduct = response.data;
        this.$set(this.productData, response.data.id, response.data);
        this.clearProductForm();
      })
      .catch(error => {
        console.log(error)
        this.alertVariant = 'danger';
        if (error.response.data.errors) {
          this.alertMessage = error.response.data.errors[0];
        } else {
          this.alertMessage = 'Error: Something went wrong'
        }
        this.alertShow = true;
      })
      .finally(() => {
        this.processing = false;
        this.editModalShow = false;
      });
    },
    clearProductForm() {
      this.productForm.item_no = null;
      this.productForm.name_en = null;
      this.productForm.name_zh = null;
      this.productForm.brand_id = null;
      this.productForm.box_quantity = null;
      this.productForm.storage_temp = 'Room';
    },
    clearValidationError() {
      this.validationErrorShow = false;
      this.validationErrorMessage = false;
    },
    updatePhoto() {
      this.$http.put(`/admin/products/${this.selectedProduct.id}`, {
        product: this.photoForm
      })
      .then(response => {
        console.log(response);
        this.selectedProduct = response.data;
        this.$set(this.productData, response.data.id, Object.assign(response.data, { image_url: "placeholder" }));
        this.photoForm.image = null;
      })
      .catch(error => console.log(error));
    },
    intersected() {
      if (this.page + 1 <= this.last) {
        console.log('Adding next page')
        this.page++;
        this.addingPage = true;
        this.fetchProducts();
      }
    },
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
</style>
