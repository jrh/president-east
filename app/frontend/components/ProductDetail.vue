<template>
  <b-container>
    <b-row align-h="center">
      <b-col lg="6" class="text-center">
        <div v-if="previewAttached" id="previewAnchor"></div>
        <div v-else>
          <div v-if="product.image_url" class="d-flex justify-content-center align-items-center mx-auto">
            <img :src="product.image_url" style="max-height: 300px; max-width: 300px" />
          </div>
          <div v-else class="d-flex justify-content-center align-items-center mx-auto" style="background-color: #f2f2f2; height: 300px; width: 300px; border-radius: 3px">
            <font-awesome-icon :icon="['fas', 'image']" size="7x" fixed-width style="color: #fff" />
          </div>
        </div>
      </b-col>
      <b-col lg="6" class="pt-5 pt-lg-0">
        <b-row align-h="end">
          <span class="pr-3" style="font-size: 12px">#{{ product.item_no }}</span>
        </b-row>
        <b-row>
          <h4 class="font-lato">{{ product.name_en }}</h4>
        </b-row>
        <b-row>
          <h4 class="font-lato">{{ product.name_zh }}</h4>
        </b-row>
        <b-row class="mt-3">
          <b-table-simple small borderless style="font-size: 13px">
            <b-tbody>
              <b-tr>
                <b-td style="width: 100px">Brand:</b-td>
                <b-td v-if="brandData[product.brand_id]">{{ brandData[product.brand_id].name_en }}</b-td>
              </b-tr>
              <b-tr>
                <b-td>Storage temp:</b-td>
                <b-td>{{ product.storage_temp }}</b-td>
              </b-tr>
              <b-tr>
                <b-td>Box quantity:</b-td>
                <b-td>{{ product.box_quantity }}</b-td>
              </b-tr>
            </b-tbody>
          </b-table-simple>
        </b-row>
        <!-- <b-row v-if="product.status == 'active'" class="mt-2">
          <b-btn :disabled="isAdmin" size="lg" variant="warning">Add to Cart</b-btn>
        </b-row> -->
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
import { mapGetters } from 'vuex';

export default {
  name: 'ProductDetail',
  props: {
    product: Object,
    brandData: Object,
    previewAttached: Boolean
  },
  computed: {
    ...mapGetters(['isAdmin']),
  }
}
</script>
