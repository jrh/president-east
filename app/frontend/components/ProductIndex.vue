<template>
  <div>
    <v-layout row justify-center>
      <p>Product Catalog</p>
    </v-layout>
    <v-layout row>
      <v-toolbar dense id="search-bar">
        <v-text-field
          v-model="term"
          hide-details
          prepend-icon="search"
          single-line
          placeholder="Search by name or item no."
        ></v-text-field>
      </v-toolbar>
    </v-layout>
    <v-layout row justify-center>
      <v-flex lg8>
        <v-container fluid grid-list-sm class="mt-5">
          <v-layout row wrap>
            <v-flex v-for="product in filteredProducts" :key="product.id">
              <ProductIndexCard :product="product" class="mb-5" />
            </v-flex>
          </v-layout>
        </v-container>
      </v-flex>
    </v-layout>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import ProductIndexCard from './ProductIndexCard.vue';

export default {
  name: 'ProductIndex',
  components: { ProductIndexCard },
  data() {
    return {
      term: ''
    }
  },
  computed: {
    ...mapGetters(['products']),
    filteredProducts() {
      let term = this.term.toLowerCase();
      if (term && this.products.length > 0) {
        return this.products.filter(product => {
          return product.name_en.trim().toLowerCase().includes(term) || JSON.stringify(product.item_no).includes(term);
        })
      } else {
        return this.products;
      }
    }
  },
  created() {
    this.$store.dispatch('fetchProducts');
  }
}
</script>

<style scoped>
#search-bar {
  width: 300px;
  background-color: #ffffff;
}
p {
  font-size: 24px;
}
</style>

