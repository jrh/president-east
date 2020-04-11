<template>
  <b-card footer-bg-variant="light" class="product-card-style">
    <b-row align-h="center" align-v="center" style="height: 100px">
      <div class="thumbnail">
        <img v-if="product.image_url" :src="product.image_url" class="thumbnail-image" />
        <font-awesome-icon v-else :icon="['far', 'image']" size="3x" fixed-width style="color: #e6e6e6" />
      </div>
    </b-row>
    <b-card-body class="font-lato d-flex flex-column" style="height: 185px">
      <b-container fluid>
        <b-row class="mb-1">
          <span style="font-size: 14px; color: #008000">{{ product.name_en }}</span>
        </b-row>
        <b-row class="text-secondary mb-2">
          <span style="font-size: 13px">{{ product.name_zh }}</span>
        </b-row>
        <b-row class="text-secondary mb-1">
          <span style="font-size: 12px">{{ brandData[product.brand_id].name_en }}</span>
        </b-row>
        <b-row class="text-secondary mb-1" style="font-size: 12px">
          <span>{{ product.box_quantity }}</span>
        </b-row>
        <b-row v-if="product.storage_temp !== 'Room'" class="text-secondary">
          <span class="text-danger">{{ product.storage_temp }}</span>
        </b-row>
      </b-container>
      <b-btn size="sm" variant="outline-warning" class="mt-auto">Add to Cart</b-btn>
    </b-card-body>
  </b-card>
</template>

<script>
export default {
  name: 'ProductIndexCard',
  props: {
    product: Object,
    brandData: Object
  }
}
</script>

<style scoped>
.product-card-style {
  max-width: 180px;
  min-width: 180px;
  margin-bottom: 20px;
  border-radius: 10px;
}
.thumbnail {
  height: 100%;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}
.thumbnail-image {
   max-height: 100px;
   max-width: 100px;
}
.card-body {
  padding: 0.5rem;
  cursor: pointer;
}
</style>
