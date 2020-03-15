<template>
  <div>
    <b-row align-h="center" class="mt-5 mb-2">
      <p style="font-size: 38px">Product Catalog</p>
    </b-row>
    <b-row align-h="center" class="px-3">
      <b-col sm="4">
        <b-row>
          <b-form-group style="width: 290px">
            <b-input-group size="sm">
              <b-input
                v-model="searchTerm"
                autofocus
                placeholder="Search by name or item no."
              />
              <b-input-group-append>
           <!--      <b-button variant="outline-secondary" size="sm" @click="search">
                  <font-awesome-icon :icon="['fas', 'search']" fixed-width />
                </b-button> -->
                <b-button size="sm" @click="resetSearch">Reset</b-button>
              </b-input-group-append>
            </b-input-group>
          </b-form-group>
        </b-row>
      </b-col>
      <b-col sm="4" class="text-right">
        <b-form-group>
          <b-select
            v-model="brandFilter"
            :options="brandOptions"
            size="sm"
            style="width: 320px"
          >
            <template #first>
              <b-select-option :value="null">All brands</b-select-option>
            </template>

          </b-select>
        </b-form-group>
      </b-col>
    </b-row>
    <b-row align-h="center">
      <b-col lg="8">
        <b-container fluid grid-list-sm class="mt-5">
          <b-row>
            <b-col v-for="product in filteredProducts" :key="product.id">
              <ProductIndexCard :product="product" class="mb-5" />
            </b-col>
          </b-row>
        </b-container>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { normalize, schema } from 'normalizr';
import ProductIndexCard from './ProductIndexCard.vue';

export default {
  name: 'ProductIndex',
  components: { ProductIndexCard },
  data() {
    return {
      searchTerm: '',
      productData: {},
      productList: [],
      brands: [],
      brandFilter: null
    }
  },
  computed: {
    products() {
      return this.productList.map(id => this.productData[id]);
    },
    filteredProducts() {
      if (this.products.length > 0) {
        let products;
        if (this.brandFilter) {
          products = this.products.filter(p => {
            return p.brand_id === this.brandFilter;
          })
        } else {
          products = this.products;
        }

        if (this.searchTerm) {
          let searchTerm = this.searchTerm.toLowerCase();
          return products.filter(product => {
            return product.name_en.trim().toLowerCase().includes(searchTerm) || JSON.stringify(product.item_no).includes(searchTerm);
          })
        } else {
          return products;
        }
      }
    },
    brandOptions() {
      return this.brands.map(brand => ({ text: brand.name_en, value: brand.id }))
    }
  },
  mounted() {
    this.fetchProducts();
  },
  methods: {
    fetchProducts() {
      this.loading = true;
      this.$http.get('/products')
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
          this.brands = response.data.brands;
        })
        .catch(error => {
          console.log(error)
        })
        .finally(() => this.loading = false);
    },
    search() {

    },
    resetSearch() {
      this.searchTerm = '';
    }
  }
}
</script>

<style scoped>
#search-bar {
  width: 350px;
  background-color: #ffffff;
}
</style>

