<template>
  <b-card footer-bg-variant="light" class="product-card-style">
    <b-row align-h="center" align-v="center" style="height: 100px">
      <img v-if="product.image_url" :src="product.image_url" style="max-height: 100px; max-width: 100px" />
      <font-awesome-icon v-else :icon="['far', 'image']" size="3x" fixed-width class="text-muted" />
    </b-row>
    <b-card-body class="font-lato">
      <b-row>
        <span style="font-size: 15px"><b>{{ product.name_en }}</b></span>
      </b-row>
      <b-row>
        <span style="font-size: 14px">{{ product.name_zh }}</span>
      </b-row>
      <b-row class="mt-2" style="font-size: 12px">
        <span>{{ product.box_quantity }}</span>
      </b-row>
      <b-row v-if="product.storage_temp !== 'Room'">
        <span class="text-danger">{{ product.storage_temp }}</span>
      </b-row>
    </b-card-body>
    <template #footer>
      <b-row align-h="center">
        <b-btn size="sm" variant="warning">Add to Cart</b-btn>
      </b-row>
    </template>
  </b-card>
</template>

<script>
export default {
  name: 'ProductCard',
  props: { product: Object }
}
</script>

<style scoped>
.product-card-style {
  max-width: 180px;
  min-width: 180px;
  margin-bottom: 20px;
  border-radius: 10px;
}
.card-body {
  padding: 1rem;
}
</style>
