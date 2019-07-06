<template>
  <b-card style="height: 320px; width: 220px">
    <b-row align-h="center" style="font-size: 11px">
      <span>#{{ product.item_no }}</span>
    </b-row>
    <b-row align-h="center" align-v="center" style="height: 120px">
      <img v-if="product.image_url" :src="product.image_url" style="max-height: 120px; max-width: 150px" />
      <v-icon v-else>photo</v-icon>
    </b-row>
    <b-card-body style="height: 80px">
      <b-row>
        <span class="name"><b>{{ product.name_zh }}</b></span>
      </b-row>
      <b-row>
        <span class="name"><b>{{ product.name_en }}</b></span>
      </b-row>
      <b-row>
        <span>{{ product.box_quantity }}</span>
      </b-row>
    </b-card-body>
    <hr>
    <b-row align-h="center">
      <b-btn size="sm" variant="warning">Order</b-btn>
    </b-row>
  </b-card>
</template>

<script>
export default {
  name: 'ProductIndexCard',
  props: { product: Object }
}
</script>

<style scoped>
span { font-size: 13px; }
.name {
  font-size: 15px;
}
/*TODO b-card hover*/
</style>

