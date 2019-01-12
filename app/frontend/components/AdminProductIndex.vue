<template>
  <div>
    <v-layout row justify-center>
      <h3>Admin Product Index</h3>
    </v-layout>
    <v-layout row justify-end>
      <v-dialog v-model="dialog" max-width="500px">
        <v-btn slot="activator">Add Product</v-btn>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>
  
            <v-card-text>
              <v-container grid-list-md>
                <v-layout wrap>
                  <v-flex xs12 sm6 md4>
                    <v-text-field v-model="editedItem.name_en" label="Name (En)"></v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6 md4>
                    <v-text-field v-model="editedItem.name_zh" label="Name (Ch)"></v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6 md4>
                    <v-text-field v-model="editedItem.brand_en" label="Brand (En)"></v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6 md4>
                    <v-text-field v-model="editedItem.box_quantity" label="Box Quantity"></v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6 md4>
                    <v-radio-group v-model="editedItem.storage_temp" number>
                      <v-radio label="Room" value="room"></v-radio>
                      <v-radio label="Cooler" value="cooler"></v-radio>
                      <v-radio label="Freezer" value="freezer"></v-radio>
                    </v-radio-group>
                  </v-flex>
                </v-layout>
              </v-container>
            </v-card-text>
  
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" flat @click="close">Cancel</v-btn>
              <v-btn color="blue darken-1" flat @click="save(editedItem)">Save</v-btn>
            </v-card-actions>
          </v-card>
      </v-dialog>
    </v-layout>
    <v-layout row justify-center class='mt-5'>
      <v-data-table :headers="headers" :items="products">
        <template slot="items" slot-scope="props">
          <td>{{ props.item.name_en }}</td>
          <td>{{ props.item.name_zh }}</td>
          <td>{{ props.item.brand_en }}</td>
          <td>{{ props.item.box_quantity }}</td>
          <td>{{ props.item.storage_temp | capitalize }}</td>
          <td>
            <v-icon small @click="editItem(props.item)">edit</v-icon>
          </td>
        </template>
      </v-data-table>
    </v-layout>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';

export default {
  name: 'AdminProductIndex',
  created() {
    this.fetchProducts();
  },
  data() {
    return {
      dialog: false,
      headers: [
        { text: 'Name (en)', align: 'left', value: 'name_en' },
        { text: 'Name (ch)', align: 'left', value: 'name_zh' },
        { text: 'Brand', value: 'brand_en' },
        { text: 'Package Sizing', value: 'box_quantity' },
        { text: 'Storage Temp', value: 'storage_temp' },
        { text: 'Actions', value: 'name', sortable: false }
      ],
      editedIndex: -1,
      editedItem: {
        id: null,
        name_en: '',
        name_zh: '',
        brand_en: '',
        box_quantity: '',
        storage_temp: null
      },
      defaultItem: {
        id: null,
        name_en: '',
        name_zh: '',
        brand_en: '',
        box_quantity: '',
        storage_temp: null
      }
    }
  },
  computed: {
    ...mapGetters(['products']),
    formTitle() {
      return this.editedIndex === -1 ? 'New Product' : 'Edit Product'
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
      this.editedIndex = 2
      this.editedItem = Object.assign({}, product)
      this.dialog = true
    },
    deleteItem (item) {
      //const index = this.products.indexOf(item)
      //confirm('Are you sure you want to delete this item?') && this.products.splice(index, 1)
    },

    close () {
      this.dialog = false
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
        this.editedIndex = -1
      }, 300)
    },

    save(product) {
      if (this.editedIndex > -1) {
        // Object.assign(this.products[this.editedIndex], this.editedItem)
        this.updateProduct(product);
      } else {
        this.products.push(this.editedItem)
      }
      this.close()
    }
  }
}
</script>

<style scoped>

</style>

