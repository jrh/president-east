<template>
  <div>
    <v-layout row justify-center>
      <h3>Admin Product Index</h3>
    </v-layout>
    <v-layout row justify-end>
      <v-dialog v-model="dialog" max-width="500px">
        <v-btn slot="activator" color="success">Add Product</v-btn>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>
  
            <v-card-text>
              <v-container grid-list-md>
                <v-layout row>
                  <v-flex xs12 sm6 md4>
                    <v-text-field v-model="editedItem.item_no" label="Item No." number></v-text-field>
                  </v-flex>
                </v-layout>
                <v-layout wrap>
                  <v-flex xs12 sm8 md8>
                    <v-text-field v-model="editedItem.name_en" label="Name (En)"></v-text-field>
                  </v-flex>
                  <v-flex xs12 sm4 md4>
                    <v-text-field v-model="editedItem.name_zh" label="Name (Ch)"></v-text-field>
                  </v-flex>
                  <v-flex xs12 sm8 md8>
                    <v-text-field v-model="editedItem.brand_en" label="Brand (En)"></v-text-field>
                  </v-flex>
                    <v-flex xs12 sm4 md4>
                    <v-text-field v-model="editedItem.brand_zh" label="Brand (Ch)"></v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6 md6>
                    <v-text-field v-model="editedItem.box_quantity" label="Box Quantity"></v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6 md6 class="pl-3">
                    <v-radio-group v-model="editedItem.storage_temp" number class="mt-0">
                      <span slot="label" class="radio-group-label">Storage Temp</span>
                      <v-radio label="Room" value="room"></v-radio>
                      <v-radio label="Cooler" value="cooler"></v-radio>
                      <v-radio label="Freezer" value="freezer"></v-radio>
                    </v-radio-group>
                  </v-flex>
                </v-layout>
                <v-layout row>
                  <div id="uppy-target"></div>
                </v-layout>
                <v-layout row>
                  <v-input value="editedItem.cached_image_data" id="file-input"></v-input>
                </v-layout>
              </v-container>
            </v-card-text>
  
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="darken-1" flat @click="close">Cancel</v-btn>
              <v-btn color="green darken-1" flat @click="save(editedItem)">Save</v-btn>
            </v-card-actions>
          </v-card>
      </v-dialog>
    </v-layout>
    <v-layout row justify-center class='mt-5'>
      <v-data-table :headers="headers" :items="products">
        <template slot="items" slot-scope="props">
          <td>{{ props.item.item_no }}</td>
          <td>{{ props.item.name_en }}</td>
          <td>{{ props.item.name_zh }}</td>
          <td class="text-xs-center">{{ props.item.brand_en }}</td>
          <td class="text-xs-center">{{ props.item.brand_zh }}</td>
          <td class="text-xs-center">{{ props.item.box_quantity }}</td>
          <td class="text-xs-center">{{ props.item.storage_temp | capitalize }}</td>
          <td class="text-xs-center">
            <v-icon small @click="editItem(props.item)">edit</v-icon>
          </td>
        </template>
      </v-data-table>
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

    uppy.on('upload-success', (file, resp, uploadURL) => {
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
      document.getElementById('file-input').value = uploadedFileData;
    })
  },
  data() {
    return {
      dialog: false,
      headers: [
        { text: 'Item No.', align: 'left', value: 'item_no' },
        { text: 'Name (en)', align: 'left', value: 'name_en' },
        { text: 'Name (ch)', align: 'left', value: 'name_zh' },
        { text: 'Brand (en)', align: 'center', value: 'brand_en' },
        { text: 'Brand (ch)', align: 'center', value: 'brand_zh' },
        { text: 'Box Quantity', align: 'center', value: 'box_quantity' },
        { text: 'Storage Temp', align: 'center', value: 'storage_temp' },
        { text: 'Actions', align: 'center', value: 'name', sortable: false }
      ],
      mode: 'new',
      editedItem: {
        id: null,
        item_no: '',
        name_en: '',
        name_zh: '',
        brand_en: '',
        brand_zh: '',
        box_quantity: '',
        storage_temp: 'room',
        image_data: null
      }
    }
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

