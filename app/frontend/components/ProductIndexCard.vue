<template>
  <v-card height="270" width="200" hover>
    <v-img
      src="https://cdn.vuetifyjs.com/images/cards/desert.jpg"
      height="100"
    ></v-img>
    <v-card-text>
      <v-layout row>
        <span>Item #{{ product.item_no }}</span>
      </v-layout>
      <v-layout row>
        <span>{{ product.name_zh }}</span>
      </v-layout>
      <v-layout row>
        <span>{{ product.name_en }}</span>
      </v-layout>
      <v-layout row>
        <span>{{ product.box_quantity }}</span>
      </v-layout>
    </v-card-text>
    <v-card-actions>
      <v-btn flat color="orange">Order</v-btn>
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
  font-size: 18px;
}
</style>

