<template>
  <div>
    <v-layout row justify-center>
      <p>Product Catalog</p>
    </v-layout>
    <v-layout row>
      <v-flex lg6>
        <v-toolbar dense id="search-bar">
          <v-text-field
            v-model="term"
            hide-details
            prepend-icon="search"
            single-line
            clearable
            placeholder="Search by name or item no."
          ></v-text-field>
        </v-toolbar>
      </v-flex>
      <v-flex lg6 class="text-sm-right">
        <v-select
          v-model="brand"
          :items="brandOptions"
          label="Filter by brand"
          class="ml-auto"
          style="width: 320px;"
        >
        </v-select>
      </v-flex>
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
      term: '',
      brand: null,
      brandOptions: [
        { text: 'All Brands', value: null },
        'Tung-I',
        'Hsin Tung Yang',
        // 'Chi-Sheng',
        // 'Kimlan',
        // 'Little Cook Noodle',
        // "King's Cook"
      ],
    }
  },
  computed: {
    ...mapGetters(['products']),
    filteredProducts() {
      if (this.products.length > 0) {
        let products;
        if (this.brand) {
          products = this.products.filter(p => {
            return p.brand_en === this.brand;
          })
        } else {
          products = this.products;
        }

        if (this.term) {
          let term = this.term.toLowerCase();
          return products.filter(product => {
            return product.name_en.trim().toLowerCase().includes(term) || JSON.stringify(product.item_no).includes(term);
          })
        } else {
          return products;
        }
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
  width: 350px;
  background-color: #ffffff;
}
p {
  font-size: 24px;
}
</style>

