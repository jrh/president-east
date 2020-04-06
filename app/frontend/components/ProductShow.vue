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
    <b-container>
      <b-row align-h="end" class="px-3" style="font-size: 18px">
        <span class="pr-3">Status: </span>
        <span :class="{'text-success': product.status == 'active', 'text-danger': product.status == 'inactive'}">
          {{ product.status | titleize }}
        </span>
      </b-row>
    </b-container>
    <b-container class="mt-5">
      <small class="text-info">What the customer sees in product catalog:</small>
    </b-container>
    <b-container class="p-5" style="border: 1px dotted #0f0f0f">
      <b-row align-h="center">
        <b-col lg="6" class="text-center">
          <div v-if="product.image_url" class="d-flex justify-content-center align-items-center mx-auto">
            <img :src="product.image_url" ref="imagePreview" style="max-height: 350px; max-width: 400px" />
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
      <b-row>
      </b-row>
    </b-modal>

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

export default {
  name: 'ProductShow',
  components: { Button, ValidationObserver, ValidationProvider },
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
      photoForm: {
        image: null
      },
      ready: false
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
      metaFields: [],
      trigger: '#uppy-select-files',
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

    // uppy.on('upload', (data) => {
    //   this.uploadingImage = true;
    // })

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
      this.photoForm.image = uploadedFileData;

      this.updatePhoto();

      // show image preview
      // this.$refs.imagePreview.src = URL.createObjectURL(file.data);

      // use cached version of AWS image URL for form submital
      // this.imageUrl = response.uploadURL;

      // this.uploadingImage = false;
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
          this.ready = true;
        })
        .catch(error => {
          console.log(error)
        })
    },
    openEditModal() {
      this.editModalShow = true;
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
  //   updateProduct(product) {
  //     this.$http.put(`/admin/products/${product.id}`, {
  //       product: {
  //         item_no: product.item_no,
  //         name_en: product.name_en,
  //         name_zh: product.name_zh,
  //         box_quantity: product.box_quantity,
  //         storage_temp: product.storage_temp,
  //         image: product.image
  //       }
  //     })
  //     .then(response => {
  //       console.log(response);
  //       this.$store.commit('setProduct', response.data);
  //     })
  //     .catch(error => console.log(error))
  //   },
  }
}
</script>
