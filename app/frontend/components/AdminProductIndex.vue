<template>
  <div>
    <v-layout row justify-center>
      <h3>Admin Section</h3>
    </v-layout>
<!--     <v-layout row justify-center>
      <v-flex xs12 lg10 class="text-xs-right">
        <v-btn>User Accounts</v-btn>
      </v-flex>
    </v-layout> -->
    <v-layout row justify-center class='mt-5'>
      <v-card>
        <v-layout row class="pa-2">
          <v-card-title style="font-size: 20px;">Products</v-card-title>
          <v-spacer></v-spacer>
          <!-- Modal -->
          <v-dialog v-model="dialog" max-width="500px">
            <v-btn slot="activator" color="success">Add Product</v-btn>
            <v-card>
              <v-card-title>
                <span class="headline">{{ formTitle }}</span>
              </v-card-title>

              <v-card-text>
                <v-container grid-list-md>
                  <v-layout row>
                    <v-flex xs12 sm6 md6>
                      <v-text-field v-model="editedItem.item_no" label="Item No." number></v-text-field>
                    </v-flex>
                    <v-flex xs12 sm6 md6>
                      <v-layout row justify-center class="pb-3">
                        <img v-if="editedItem.image_url" height="60" ref="imagePreview" :src="editedItem.image_url" />
                        <img v-else height="60" ref="imagePreview" />
                        <v-progress-circular v-if="uploadingImage" indeterminate></v-progress-circular>
                      </v-layout>
                      <v-layout row justify-center>
                        <div id="uppy-target"></div>
                      </v-layout>
                      <input type="hidden" v-model="editedItem.image" />
                    </v-flex>
                  </v-layout>
                  <v-layout wrap>
                    <v-flex xs12 sm8>
                      <v-text-field v-model="editedItem.name_zh" label="Name (Chinese)"></v-text-field>
                    </v-flex>
                    <v-flex xs12 sm8>
                      <v-text-field v-model="editedItem.name_en" label="Name (English)"></v-text-field>
                    </v-flex>
                    <v-flex xs12 sm8>
                      <v-select
                        v-model="editedItem.brand_en"
                        :items="brandOptions"
                        label="Brand">
                      </v-select>
                    </v-flex>
                    <v-flex xs12 sm6>
                      <v-text-field v-model="editedItem.box_quantity" label="Box Quantity"></v-text-field>
                    </v-flex>
                    <v-flex xs12 sm6>
                      <v-select
                        v-model="editedItem.storage_temp"
                        :items="storageOptions"
                        item-text="label"
                        item-value="value"
                        label="Storage Temp">
                      </v-select>
                    </v-flex>
                  </v-layout>
                </v-container>
              </v-card-text>

              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="darken-1" flat @click="close">Cancel</v-btn>
                <v-btn color="success" :disabled="uploadingImage" @click="save(editedItem)">Save</v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-layout>
        <v-data-table
          :headers="headers"
          :items="products"
          :rows-per-page-items="rowsPerPageItems">
          <template slot="items" slot-scope="props">
            <td>{{ props.item.item_no }}</td>
            <td>{{ props.item.name_en }}</td>
            <td>{{ props.item.name_zh }}</td>
            <td class="text-xs-center">{{ props.item.brand_en }}</td>
            <td class="text-xs-center">{{ props.item.box_quantity }}</td>
            <td class="text-xs-center">{{ props.item.storage_temp }}</td>
            <td class="text-xs-center">
              <v-icon v-if="props.item.image_data">photo</v-icon>
            </td>
            <td class="text-xs-center">
              <v-icon small @click="editItem(props.item)">edit</v-icon>
            </td>
          </template>
        </v-data-table>
      </v-card>
    </v-layout>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import Uppy from '@uppy/core';
import FileInput from '@uppy/file-input';
import AwsS3 from '@uppy/aws-s3';

export default {
  name: 'AdminProductIndex',
  data() {
    return {
      dialog: false,
      headers: [
        { text: 'Item No.', align: 'left', value: 'item_no' },
        { text: 'Name (en)', align: 'left', value: 'name_en' },
        { text: 'Name (ch)', align: 'left', value: 'name_zh' },
        { text: 'Brand', align: 'center', value: 'brand_en' },
        { text: 'Box Quantity', align: 'center', value: 'box_quantity' },
        { text: 'Storage Temp', align: 'center', value: 'storage_temp' },
        { text: 'Photo Attached?', align: 'center' },
        { text: 'Actions', align: 'center', value: 'name', sortable: false }
      ],
      mode: 'new',
      editedItem: {
        id: null,
        item_no: '',
        name_en: '',
        name_zh: '',
        brand_en: '',
        box_quantity: '',
        storage_temp: 'Room',
        image: null,
        image_data: null,
        image_url: ''
      },
      defaultItem: {
        id: null,
        item_no: '',
        name_en: '',
        name_zh: '',
        brand_en: '',
        box_quantity: '',
        storage_temp: 'Room',
        image: null,
        image_data: null,
        image_url: ''
      },
      brandOptions: [
        'Tung-I',
        'Hsin Tung Yang',
        'Chi-Sheng',
        'Kimlan',
        'Little Cook Noodle',
        "King's Cook"
      ],
      storageOptions: [ 'Room', 'Cooler', 'Frozen' ],
      rowsPerPageItems: [25],
      uploadingImage: false
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

      // set hidden field value to the uploaded file data so that it's submitted with the form as the attachment
      this.editedItem.image = uploadedFileData;

      // show image preview
      this.$refs.imagePreview.src = URL.createObjectURL(file.data)

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
    dialog (val) {
      val || this.close()
    }
  },
  methods: {
    ...mapActions(['fetchProducts', 'createProduct', 'updateProduct']),
    editItem(product) {
      this.mode = 'edit'
      this.editedItem = Object.assign({}, product)
      this.dialog = true
    },
    deleteItem(product) {
      //const index = this.products.indexOf(item)
      //confirm('Are you sure you want to delete this item?') && this.products.splice(index, 1)
    },
    close() {
      this.mode = 'new'
      this.dialog = false
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
      }, 300)
    },
    save(product) {
      if (this.mode === 'edit') {
        // Object.assign(this.products[this.editedIndex], this.editedItem)
        this.updateProduct(product);
      } else {
        this.createProduct(product)
      }
      this.close()
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

