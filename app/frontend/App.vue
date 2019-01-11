<template>
  <v-app>
    <v-navigation-drawer app right stateless v-model="drawer"></v-navigation-drawer>
    <v-toolbar app>
      <v-toolbar-title>豐玉公司</v-toolbar-title>
      <v-toolbar-title>President East Co.</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items class="hidden-sm-and-down">
        <v-btn flat to="/about">About Us</v-btn>
        <v-btn flat to="/products">Products</v-btn>
        <v-btn flat to="/contact">Contact</v-btn>
        <v-btn flat to="/admin_products">Admin</v-btn>
      </v-toolbar-items>
      <v-toolbar-side-icon @click="drawer = !drawer" class="hidden-md-and-up"></v-toolbar-side-icon>
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

</style>
