<template>
  <div>
    <b-row align-h="center" class="mt-5 mb-2">
    </b-row>
    <b-row align-h="center">
      <b-col lg="2">
        <b-row class="mb-2">
          <p class="font-lato sidebar-label">Search:</p>
        </b-row>
        <b-row class="mb-5">
          <b-form-group style="width: 100%">
            <b-input-group size="sm">
              <b-input v-model="searchTerm" placeholder="Type product name" />
              <b-input-group-append>
                <b-button variant="outline-secondary" size="sm" @click="search">
                  <font-awesome-icon :icon="['fas', 'search']" fixed-width />
                </b-button>
                <!-- <b-button size="sm" @click="resetSearch">Reset</b-button> -->
              </b-input-group-append>
            </b-input-group>
          </b-form-group>
        </b-row>
        <b-row class="mb-2">
          <p class="font-lato sidebar-label">Filter by brand:</p>
        </b-row>
        <b-row class="mb-5">
          <b-form-group>
            <b-checkbox-group v-model="brandFilter" :options="brandOptions" size="sm" stacked ></b-checkbox-group>
          </b-form-group>
        </b-row>
      </b-col>
      <b-col lg="1"></b-col>
      <b-col lg="8">
        <b-card-group deck>
        <!-- <ProductIndexCard v-for="product in filteredProducts" :key="product.id" :product="product" /> -->
        <ProductCard v-for="product in filteredProducts" :key="product.id" :product="product" :brandData="brandData" />
      </b-card-group>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { normalize, schema } from 'normalizr';
import ProductIndexCard from './ProductIndexCard';
import ProductCard from './ProductCard';

export default {
  name: 'ProductIndex',
  components: { ProductIndexCard, ProductCard },
  data() {
    return {
      searchTerm: '',
      productData: {},
      productList: [],
      brandData: {},
      brandList: [],
      brandFilter: []
    }
  },
  computed: {
    products() {
      return this.productList.map(id => this.productData[id]);
    },
    brands() {
      return this.brandList.map(id => this.brandData[id]).sort((a,b) => a.name_en - b.name_en);
    },
    filteredProducts() {
      if (this.products.length > 0) {
        let products;
        if (this.brandFilter.length > 0) {
          products = this.products.filter(p => {
            return this.brandFilter.includes(p.brand_id);
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
.sidebar-label {
  padding-left: 10px;
  padding-top: 5px;
  padding-bottom: 5px;
  font-size: 15px;
  background-color: #f2f2f2;
  width: 100%;
  border-radius: 5px;
}
</style>
