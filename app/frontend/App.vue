<template>
  <v-app>
    <v-navigation-drawer app right stateless v-model="drawer"></v-navigation-drawer>
    <v-toolbar app color="white" height="100">
      <v-img
        contain
        height="60"
        min-width="120"
        max-width="250"
        :src="require('./images/logo.png')"
      ></v-img>
      <v-toolbar-title>President East Co.</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items class="hidden-sm-and-down" style="height: 50px;">
        <v-btn flat round to="/about">About Us</v-btn>
        <v-btn flat round to="/products">Products</v-btn>
        <v-btn flat round to="/contact">Contact</v-btn>
        <v-btn flat round to="/admin_products">Admin</v-btn>
      </v-toolbar-items>
      <!-- <v-toolbar-side-icon @click="drawer = !drawer" class="hidden-md-and-up"></v-toolbar-side-icon> -->
    </v-toolbar>
    <v-content>
      <v-container fluid>
        <router-view></router-view>
      </v-container>
    </v-content>
    <Footer />
  </v-app>
</template>

<script>
import Footer from './components/Footer.vue';

export default {
  name: 'App',
  components: { Footer },
  data() {
    return {
      drawer: false
    }
  }
}
</script>

<style scoped>
.v-toolbar__title {
  font-family: 'Roboto Slab', serif;
  font-weight: 700;
  font-size: 26px;
}
</style>
