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
        <Button class="float-right">
          <font-awesome-icon :icon="['far', 'edit']" fixed-width />
          <span class="pl-2">Change Status</span>
        </Button>
      </b-alert>
    </b-container>
    <b-container class="mt-5">
      <b-row align-h="between" align-v="end" class="pb-1">
        <span class="text-info" style="font-size: 12px">What the customer sees in product catalog:</span>
        <div style="font-size: 18px">
          <span class="pr-3">Status: </span>
          <span :class="{'text-success': product.status == 'active', 'text-danger': product.status == 'inactive'}">
            {{ product.status | titleize }}
          </span>
        </div>
      </b-row>
    </b-container>
    <b-container class="p-5" style="border: 1px dotted #0f0f0f">
      <b-row align-h="center">
        <b-col lg="6" class="text-center">
          <img v-if="thumbnailAvailable" ref="imagePreview" style="max-height: 350px; max-width: 400px">
          <div v-else-if="product.image_url" class="d-flex justify-content-center align-items-center mx-auto">
            <img :src="product.image_url" style="max-height: 350px; max-width: 400px" />
          </div>
          <div v-else class="d-flex justify-content-center align-items-center mx-auto" style="background-color: #f2f2f2; height: 300px; width: 300px; border-radius: 3px">
            <font-awesome-icon :icon="['fas', 'image']" size="7x" fixed-width style="color: #fff" />
          </div>
        </b-col>
        <b-col lg="6" class="pt-5 pt-lg-0">
          <b-row align-h="end">
            <span class="pr-3" style="font-size: 12px">#{{ product.item_no }}</span>
          </b-row>
          <b-row>
            <h4 class="font-lato">{{ product.name_en }}</h4>
          </b-row>
          <b-row>
            <h4 class="font-lato">{{ product.name_zh }}</h4>
          </b-row>
          <b-row class="mt-3">
            <b-table-simple small borderless style="font-size: 13px">
              <b-tbody>
                <b-tr>
                  <b-td style="width: 100px">Brand:</b-td>
                  <b-td v-if="brandData[product.brand_id]">{{ brandData[product.brand_id].name_en }}</b-td>
                </b-tr>
                <b-tr>
                  <b-td>Storage temp:</b-td>
                  <b-td>{{ product.storage_temp }}</b-td>
                </b-tr>
                <b-tr>
                  <b-td>Box quantity:</b-td>
                  <b-td>{{ product.box_quantity }}</b-td>
                </b-tr>
              </b-tbody>
            </b-table-simple>
          </b-row>
          <b-row v-if="product.status == 'active'" class="mt-2">
            <b-btn :disabled="isAdmin" size="lg" variant="warning">Add to Cart</b-btn>
          </b-row>
        </b-col>
      </b-row>
    </b-container>

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
import { mapGetters } from 'vuex';
import { normalize, schema } from 'normalizr';
import { ValidationObserver, ValidationProvider } from 'vee-validate';
import Uppy from '@uppy/core';
import Dashboard from '@uppy/dashboard';
import AwsS3 from '@uppy/aws-s3';
import Button from './shared/Button';
import ToastAlert from './shared/ToastAlert';

export default {
  name: 'ProductShow',
  components: { Button, ToastAlert, ValidationObserver, ValidationProvider },
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
        storage_temp: null,
      },
      thumbnailAvailable: false,
      photoForm: {
        image: null
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
      this.thumbnailAvailable = true;
    })

    uppy.on('thumbnail:generated', (file, preview) => {
      this.$refs.imagePreview.src = preview;
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
    updatePhoto() {
      this.$http.put(`/admin/products/${this.product.id}`, {
        product: {
          image: this.photoForm.image
        }
      })
      .then(response => {
        console.log(response);
        this.product = response.data;
        this.photoForm.image = null;
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
        this.editModalShow = false;
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
      .finally(() => this.processing = false);
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
