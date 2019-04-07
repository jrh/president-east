<template>
  <v-app>
    <v-navigation-drawer app right stateless v-model="drawer"></v-navigation-drawer>
    <v-toolbar app color="white" height="120">
      <router-link to="/" tag="v-toolbar-title">
        <router-link to="/">
          <v-img
            contain
            height="60"
            min-width="120"
            max-width="250"
            :src="require('./images/logo.png')"
          ></v-img>
        </router-link>
        <router-link to="/">
          <v-toolbar-title>President East Co.</v-toolbar-title>
        </router-link>
      </router-link>
      <v-spacer></v-spacer>
      <v-toolbar-items class="hidden-sm-and-down" style="height: 50px;">
        <v-btn flat round to="/about">About Us</v-btn>
        <v-btn flat round to="/products">Products</v-btn>
        <v-btn flat round to="/contact">Contact</v-btn>
        <v-btn flat round to="/admin_products">Admin</v-btn>
        <v-btn v-if="!isLoggedIn" flat round to="/sign_up">Sign Up</v-btn>
        <v-btn v-if="isLoggedIn" flat round @click="$store.dispatch('logout')">Logout</v-btn>
        <v-btn v-else flat round to="/login">Login</v-btn>
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
  },
  computed: {
    isLoggedIn() {
      return this.$store.getters.isLoggedIn;
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
a.router-link-active {
  text-decoration: none;
  color: #000;
}
</style>
