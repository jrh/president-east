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
            <b-checkbox-group v-model="brandFilter" :options="brandOptions" name="brandFilter" size="sm" stacked @input="filter"></b-checkbox-group>
          </b-form-group>
        </b-row>
      </b-col>
      <b-col lg="1"></b-col>
      <b-col lg="8">
        <b-row v-if="!loading" class="pb-2" style="padding-left: 30px">
          <small class="text-black-50">Product count: {{ count }}</small>
        </b-row>
        <b-card-group deck>
          <ProductIndexCard
            v-for="product in products"
            :key="product.id"
            :product="product"
            :brandData="brandData"
            @product-clicked="showProductDetail"
          />
        </b-card-group>
        <b-row v-if="products.length == 0 && !loading" align-h="center">
          <p class="text-danger" style="font-size: 14px">No results were found.  Please try a different search term</p>
        </b-row>
        <Observer @intersect="intersected" />
      </b-col>
    </b-row>

    <!--Product detail modal -->
    <b-modal v-model="productDetailModalShow" size="lg" centered hide-footer>
      <ProductDetail :product="selectedProduct" :brandData="brandData" class="p-3" />
    </b-modal>
  </div>
</template>

<script>
import { normalize, schema } from 'normalizr';
import ProductDetail from './ProductDetail';
import ProductIndexCard from './ProductIndexCard';
import Observer from './shared/Observer';
import SearchBar from './shared/SearchBar';

export default {
  name: 'ProductIndex',
  components: { ProductDetail, ProductIndexCard, Observer, SearchBar },
  data() {
    return {
      productData: {},
      productList: [],
      selectedProduct: {},
      productDetailModalShow: false,
      brandData: {},
      brandList: [],
      brandFilter: [],
      searchTerm: '',
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
      return this.productList.map(id => this.productData[id]);
    },
    brands() {
      return this.brandList.map(id => this.brandData[id]).sort((a,b) => a.name_en - b.name_en);
    },
    brandOptions() {
      return this.brands.map(brand => ({ text: brand.name_en, value: brand.id }))
    }
  },
  mounted() {
    this.loading = true;
    this.fetchProducts();
  },
  methods: {
    fetchProducts() {
      console.log(`Product fetch: page ${this.page}`)
      if (this.processing) return;
      this.processing = true;
      this.$http.get('/products', {
          params: {
            loading: this.loading,
            q: this.searchTerm,
            brand_filter: this.brandFilter,
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
    search(term) {
      this.page = 1;
      this.searchTerm = term;
      this.fetchProducts();
    },
    filter(term) {
      this.page = 1;
      this.fetchProducts();
    },
    intersected() {
      if (this.page + 1 <= this.last) {
        console.log('fetching next page')
        this.page++;
        this.addingPage = true;
        this.fetchProducts();
      }
    },
    showProductDetail(product_id) {
      if (this.processing) return;
      this.processing = true;
      this.$http.get(`/products/${product_id}`)
        .then(response => {
          console.log(response)
          this.selectedProduct = response.data.product;
          this.productDetailModalShow = true;
        })
        .catch(error => {
          console.log(error)
        })
        .finally(() => this.processing = false);
    }
  }
}
</script>

<style scoped>
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
