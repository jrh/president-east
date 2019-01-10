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
        ></v-text-field>
      </v-toolbar>
    </v-layout>

    <v-layout row justify-space-around class="mt-5">
      <div v-for="product in products">
        <ProductIndexCard :product="product" />         
      </div>
    </v-layout>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import ProductIndexCard from './ProductIndexCard.vue';

export default {
  name: 'ProductIndex',
  components: { ProductIndexCard },
  created() {
    this.fetchProducts();
  },
  computed: {
    ...mapGetters(['products'])
  },
  methods: {
    ...mapActions(['fetchProducts'])
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

