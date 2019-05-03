<template>
  <div>
    <v-layout justify-center row style="background-color: #FFFCF5">
      <v-flex lg3 class="pt-5">
        <p>恭祝讀者</p>
        <p>金蘭芬香</p>
        <p>旺旺招財</p>
        <p>萬事新東陽</p>
      </v-flex>

      <v-flex lg3>
        <v-img
          contain
          height="400"
          :src="require('../images/storeshelf.jpg')"
        ></v-img>
      </v-flex>
      <v-flex lg3 class="pt-5">
        <v-img
          contain
          height="250"
          :src="require('../images/dog.jpg')"
        >
        </v-img>
      </v-flex>
    </v-layout>
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