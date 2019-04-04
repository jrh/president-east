<template>
  <div>
    <v-layout row justify-center>
      <p>Product Catalog</p>
    </v-layout>
    <v-layout row>
      <v-toolbar dense id="search-bar">
        <v-text-field
          hide-details
          prepend-icon="search"
          single-line
          placeholder="Search by name or item no."
          @input="onInput"
        ></v-text-field>
      </v-toolbar>
    </v-layout>

    <v-container fluid grid-list-sm class="mt-5">
      <v-layout row wrap>
        <v-flex v-for="product in products" :key="product.id">
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
  computed: {
    ...mapGetters(['products'])
  },
  created() {
    this.$store.dispatch('fetchProducts');
  },
  methods: {
    onInput(term){
      let searchTerm = term == '' ? '*' : term;
    }
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

