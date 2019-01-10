<template>
  <v-card height="250" width="250" hover>
    <v-img
      src="https://cdn.vuetifyjs.com/images/cards/desert.jpg"
      aspect-ratio="2.75"
    ></v-img>

    <v-card-title primary-title class="pb-0">
      <h5 class="mb-0">{{ product.name_en }}</h5>
    </v-card-title>
    <v-card-title class="pt-0">
      <h5>{{ product.name_zh }}</h5>
    </v-card-title>
    <v-card-actions>
      <v-btn flat color="orange">Edit</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  name: 'ProductIndexCard',
  props: { product: Object }
}
</script>

<style scoped>
h5 {
  font-size: 20px;
}
</style>

