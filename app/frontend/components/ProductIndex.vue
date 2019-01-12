<template>
  <div>
    <v-layout row justify-center>
      <p>Product Inventory</p>
    </v-layout>
    <v-layout row>
      <v-toolbar dense id="search-bar">
        <v-text-field
          hide-details
          prepend-icon="search"
          single-line
          @keyup.enter="onEnter"
        ></v-text-field>
      </v-toolbar>
    </v-layout>

    <v-container fluid grid-list-sm class="mt-5">
      <v-layout row wrap>
        <v-flex v-for="product in searchResults" :key="product.id">
          <ProductIndexCard :product="product" class="mb-5" />         
        </v-flex>
      </v-layout>
    </v-container>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import ProductIndexCard from './ProductIndexCard.vue';

export default {
  name: 'ProductIndex',
  components: { ProductIndexCard },
  created() {
    this.searchProducts('*');
  },
  computed: {
    ...mapGetters(['products', 'searchResults'])
  },
  methods: {
    ...mapActions(['searchProducts']),
    onEnter(event) {
      let term;
      if (event.target.value == '') {
        term = '*';
      } else {
        term = event.target.value;
      }
      this.searchProducts(term);
    }
  }
}
</script>

<style scoped>
#search-bar {
  width: 300px;
}
p {
  font-size: 24px;
}
</style>

