<template>
  <div class="pb-5">
    <b-row align-v="center" class="text-info mt-5 mb-2">
      <b-col lg="8" offset-lg="3">
        <b-row align-h="center">
          <div v-if="loading" class="mt-5">
            <b-spinner type="border" small class="mt-5"></b-spinner>
            <span class="pl-2">Loading...</span>
          </div>
        </b-row>
      </b-col>
    </b-row>
    <b-row align-h="center">
      <b-col lg="2">
        <b-row class="mb-4">
          <p style="font-size: 14px">PRODUCT CATALOG:</p>
        </b-row>
        <b-row class="mb-2">
          <p class="font-lato sidebar-label">Search:</p>
        </b-row>
        <b-row class="px-1 mb-5">
          <b-form-group class="pl-2" style="width: 92%">
            <SearchBar placeholder="Enter product name" @search-triggered="search" />
          </b-form-group>
        </b-row>
        <b-row class="mb-2">
          <p class="font-lato sidebar-label">Filter by brand:</p>
        </b-row>
        <b-row class="px-1 mb-5">
          <b-form-group>
            <b-checkbox-group v-model="brandFilter" :options="brandOptions" size="sm" stacked ></b-checkbox-group>
          </b-form-group>
        </b-row>
      </b-col>
      <b-col lg="1"></b-col>
      <b-col lg="8">
        <b-row align-h="end" class="pb-2" style="padding-right: 30px">
          <small class="text-black-50">Product count: {{ count }}</small>
        </b-row>
        <b-card-group deck>
          <ProductIndexCard v-for="product in filteredProducts" :key="product.id" :product="product" :brandData="brandData" />
        </b-card-group>
        <Observer @intersect="intersected" />
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { normalize, schema } from 'normalizr';
import ProductIndexCard from './ProductIndexCard';
import Observer from './shared/Observer';
import SearchBar from './shared/SearchBar';

export default {
  name: 'ProductIndex',
  components: { ProductIndexCard, Observer, SearchBar },
  data() {
    return {
      productData: {},
      productList: [],
      brandData: {},
      brandList: [],
      brandFilter: [],
      loading: false,
      processing: false,
      // pagination
      page: 1,
      count: null,
      last: null

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
        if (this.brandFilter.length > 0) {
          return this.products.filter(p => {
            return this.brandFilter.includes(p.brand_id);
          })
        } else {
          return this.products;
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

          this.count = response.data.pagy.count;
          this.last = response.data.pagy.last;
        })
        .catch(error => {
          console.log(error)
        })
        .finally(() => this.loading = false);
    },
    search(term) {
      if (this.processing) return;
      this.processing = true;
      this.$http.get('/products/search', {
          params: { q: term }
        })
        .then(response => {
          console.log(response)

          const productData = normalize(
            { products: response.data.products },
            { products: [ new schema.Entity('products') ] }
          );
          if (productData.entities.hasOwnProperty('products')) {
            this.productData = productData.entities.products;
          }
          this.productList = productData.result.products;

          this.count = response.data.pagy.count;
          this.last = response.data.pagy.last;
        })
        .catch(error => {
          console.log(error)
        })
        .finally(() => this.processing = false);
    },
    intersected() {
      console.log('intersection')
      this.page++;
      console.log(this.page)
      if (this.page <= this.last) {
        this.$http.get('/products', {
          params: {
            page: this.page
          }
        })
        .then(response => {
          console.log(response)
          const productData = normalize(
            { products: response.data.products },
            { products: [ new schema.Entity('products') ] }
          );
          if (productData.entities.hasOwnProperty('products')) {
            this.productData = Object.assign(this.productData, productData.entities.products);
          }
          this.productList = [...this.productList, ...productData.result.products];
        })
        .catch(error => {
          console.log(error)
        });
      }
    },
    // resetSearch() {
    //   this.searchTerm = '';
    // }
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
  font-size: 14px;
  background-color: #f2f2f2;
  width: 100%;
  border-radius: 5px;
}
</style>
