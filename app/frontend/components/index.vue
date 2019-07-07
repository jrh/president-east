<template>
  <div>
    <b-row align-h="center" class="mt-5" style="background-color: #FFFCF5">
      <b-col lg="4" class="text-center pt-5">
        <div class="red-text">
          <p>恭祝讀者</p>
          <p>金蘭芬香</p>
          <p>旺旺招財</p>
          <p>萬事新東陽</p>
        </div>
      </b-col>
      <b-col lg="4" class="text-center pt-5 pt-sm-0">
        <img :src="require('../images/storeshelf.jpg')" style="height: 350px" />
        <p class="mt-5" style="font-size: 15px">Founded in 1992, our company distributes food products from Taiwan and other Asian countries</p>
      </b-col>
      <b-col lg="4" class="text-center pt-5">
        <img :src="require('../images/dog.jpg')" style="height: 250px" />
      </b-col>
    </b-row>
  </div>
</template>

<script>
export default {
  name: 'index'
}
</script>

<style scoped>
.red-text {
  font-size: 40px;
  font-weight: bold;
  color: #d90001;
}
</style>