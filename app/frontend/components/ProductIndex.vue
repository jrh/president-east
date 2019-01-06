<template>
  <div>
    <v-toolbar dense id="search-bar">
      <v-text-field
        hide-details
        prepend-icon="search"
        single-line
      ></v-text-field>
    </v-toolbar>
    <h5>Product Inventory</h5>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  name: 'ProductIndex',
  data() {
    return {
      loading: false
    }
  },
  created() {
    this.fetchProducts();
  },
  methods: {

  }
}
</script>

<style scoped>
#search-bar {
  width: 300px;
}
</style>

