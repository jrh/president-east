<template>
  <v-card height="250" width="200" hover>
    <v-layout row justify-end class="header pr-2">
      <span>Item #{{ product.item_no }}</span>
    </v-layout>
    <v-img
      src="https://cdn.vuetifyjs.com/images/cards/desert.jpg"
      height="100"
    ></v-img>
    <v-card-text style="height: 90px;">
      <v-layout row>
        <span><b>{{ product.name_zh }}</b></span>
      </v-layout>
      <v-layout row>
        <span><b>{{ product.name_en }}</b></span>
      </v-layout>
      <v-layout row>
        <span>{{ product.box_quantity }}</span>
      </v-layout>
    </v-card-text>
    <v-divider></v-divider>
    <v-card-actions>
      <v-layout row justify-center> 
        <v-btn flat small color="orange">Order</v-btn>
      </v-layout>
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
span { font-size: 13px; }
.header span {
  font-size: 11px;
}
</style>

