<template>
  <v-card height="250" width="200" hover>
    <v-layout row justify-center class="header pt-1">
      <span>#{{ product.item_no }}</span>
    </v-layout>
    <v-img v-if="product.image_url" :src="product.image_url" height="100" contain></v-img>
    <v-layout v-else style="height: 100px;" justify-center align-center>
      <v-icon x-large>photo</v-icon>
    </v-layout>
    <v-card-text style="height: 90px;">
      <v-layout row>
        <span class="name"><b>{{ product.name_zh }}</b></span>
      </v-layout>
      <v-layout row>
        <span class="name"><b>{{ product.name_en }}</b></span>
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
.name {
  font-size: 15px;
}
</style>

