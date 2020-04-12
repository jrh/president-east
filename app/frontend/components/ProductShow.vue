<template>
  <div>
    <b-container class="mt-5">
      <b-alert show variant="warning">
        <span class="mr-5">Admin Control Panel:</span>
        <Button class="mr-3" id="uppy-select-files">
          <font-awesome-icon :icon="['far', 'image']" fixed-width />
          <span class="pl-2">Upload Photo</span>
        </Button>
        <Button @click="openEditModal">
          <font-awesome-icon :icon="['far', 'edit']" fixed-width />
          <span class="pl-2">Edit Product Info</span>
        </Button>
        <Button class="float-right" @click="openStatusModal">
          <font-awesome-icon :icon="['far', 'edit']" fixed-width />
          <span class="pl-2">Change Status</span>
        </Button>
        <!-- For Dev purposes -->
        <Button :to="`/products/${productId + 1}`">
          Next ->
        </Button>
      </b-alert>
    </b-container>
    <b-container class="mt-5">
      <b-row align-h="between" align-v="end" class="pb-1">
        <span class="text-info" style="font-size: 12px">What the customer sees in product catalog:</span>
        <div class="pr-1" style="font-size: 18px">
          <span class="pr-2">Status: </span>
          <span :class="{'text-success': product.status == 'active', 'text-warning': product.status == 'out_of_stock', 'text-danger': product.status == 'inactive'}">
            {{ product.status | titleize }}
          </span>
        </div>
      </b-row>
    </b-container>
    <ProductDetail :product="product" :brandData="brandData" class="p-5" style="border: 1px dotted #0f0f0f" />

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

    <!-- Status modal -->
    <b-modal v-model="statusModalShow" centered>
      <template #modal-title>
        <span>Edit status of {{ product.name_en }}</span>
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

    <!-- Alert -->
    <ToastAlert :show="alertShow" :variant="alertVariant" @close="alertShow = false">
      {{ alertMessage }}
    </ToastAlert>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import { normalize, schema } from 'normalizr';
import { ValidationObserver, ValidationProvider } from 'vee-validate';
import Uppy from '@uppy/core';
import Dashboard from '@uppy/dashboard';
import AwsS3 from '@uppy/aws-s3';
import ProductDetail from './ProductDetail';
import Button from './shared/Button';
import ToastAlert from './shared/ToastAlert';

export default {
  name: 'ProductShow',
  components: { ProductDetail, Button, ToastAlert, ValidationObserver, ValidationProvider },
  data() {
    return {
      productId: Number(this.$route.params.id),
      product: {},
      brandData: {},
      brandList: [],
      editModalShow: false,
      productForm: {
        item_no: null,
        name_en: null,
        name_zh: null,
        brand_id: null,
        box_quantity: null,
        storage_temp: null
      },
      previewAvailable: false,
      photoForm: {
        image: null
      },
      statusModalShow: false,
      statusForm: {
        status: null
      },
      storageOptions: ['Room', 'Cooler', 'Frozen'],
      alertShow: false,
      alertVariant: null,
      alertMessage: ''
    }
  },
  computed: {
    ...mapGetters(['isAdmin']),
    brands() {
      return this.brandList.map(id => this.brandData[id]);
    },
    brandOptions() {
      return this.brands.map(brand => ({ text: brand.name_en, value: brand.id }))
    }
  },
  beforeRouteUpdate(to, from, next) {
    console.log(to)
    if (this.productId != Number(to.params.id)) {
      this.productId =  Number(to.params.id)
      this.fetchProduct();
    }
    next();
  },
  mounted() {
    this.fetchProduct();

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
      this.previewAvailable = true;
    })

    uppy.on('thumbnail:generated', (file, preview) => {
      let elem = document.createElement("img");
      elem.src = preview;
      elem.style.maxHeight = '300px';
      elem.style.maxWidth = '300px';
      let anchor = document.getElementById("previewAnchor");
      anchor.firstChild.remove();
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
    fetchProduct() {
      this.$http.get(`/products/${this.productId}`)
        .then(response => {
          console.log(response)
          this.product = response.data.product;
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
    },
    openEditModal() {
      this.editModalShow = true;
      this.productForm.item_no = this.product.item_no;
      this.productForm.name_en = this.product.name_en;
      this.productForm.name_zh = this.product.name_zh;
      this.productForm.brand_id = this.product.brand_id;
      this.productForm.box_quantity = this.product.box_quantity;
      this.productForm.storage_temp = this.product.storage_temp;
    },
    openStatusModal() {
      this.statusForm.status = this.product.status;
      this.statusModalShow = true;
    },
    updatePhoto() {
      this.$http.put(`/admin/products/${this.product.id}`, {
        product: this.photoForm
      })
      .then(response => {
        console.log(response);
        this.product = response.data;
        this.photoForm.image = null;
      })
      .catch(error => console.log(error))
    },
    updateStatus() {
      this.$http.put(`/admin/products/${this.product.id}`, {
        product: this.statusForm
      })
      .then(response => {
        console.log(response);
        this.product = response.data;
        this.statusModalShow = false;
      })
      .catch(error => console.log(error))
    },
    updateProduct(product) {
      if (this.processing) return;
      this.processing = true;
      this.$http.put(`/admin/products/${this.product.id}`, {
        product: this.productForm
      })
      .then(response => {
        console.log(response);
        this.product = response.data;
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
      this.productForm.storage_temp = null;
    }
  }
}
</script>
