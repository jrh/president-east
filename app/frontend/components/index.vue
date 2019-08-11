<template>
  <div>
    <b-row align-h="center" class="font-lato mt-4" style="background-color: #FFFCF5">
      <b-col lg="4" class="text-center pt-5">
        <div class="red-text">
          <p>恭祝讀者</p>
          <p>金蘭芬香</p>
          <p>旺旺招財</p>
          <p>萬事新東陽</p>
        </div>
      </b-col>
      <b-col lg="4" class="text-center pt-3 pt-sm-0">
        <b-row align-h="center" class="pb-4">
          <span class="mt-5 px-5" style="font-size: 15px; max-width: 500px">Founded in 1992, our company distributes food products from Taiwan and other Asian countries</span>
        </b-row>
        <img :src="require('../images/storeshelf.jpg')" style="height: 280px" />
        <b-row align-h="center" class="mt-4">
          <b-button
            to="/products"
            variant="outline-danger"
            size="lg"
            pill
            block
            class="shadow font-weight-bold"
            style="width: 300px"
          >
            CATALOG
          </b-button>
        </b-row>
      </b-col>
      <b-col lg="4" class="text-center pt-5">
        <img :src="require('../images/dog.jpg')" style="height: 250px" />
      </b-col>
    </b-row>
    <Footer />
  </div>
</template>

<script>
import Footer from './Footer';

export default {
  name: 'index',
  components: { Footer }
}
</script>

<style scoped>
.red-text {
  font-size: 40px;
  font-weight: bold;
  color: #d90001;
}
</style>