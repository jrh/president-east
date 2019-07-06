<template>
  <div>
    <b-row align-h="center" class="mt-5" style="background-color: #FFFCF5;">
      <b-col lg="4" class="text-center pt-5">
        <div>
          <p>恭祝讀者</p>
          <p>金蘭芬香</p>
          <p>旺旺招財</p>
          <p>萬事新東陽</p>
        </div>
      </b-col>
      <b-col lg="4" class="text-center">
        <img
          style="height: 400px"
          :src="require('../images/storeshelf.jpg')"
        ></img>
      </b-col>
      <b-col lg="4" class="text-center pt-5">
        <img
          style="height: 250px"
          :src="require('../images/dog.jpg')"
        >
        </img>
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
p {
  font-size: 40px;
  font-weight: bold;
  color: #d90001;
}
</style>