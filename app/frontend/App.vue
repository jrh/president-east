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
        <v-btn flat to="/about">About Us</v-btn>
        <v-btn flat to="/products">Products</v-btn>
        <v-menu v-if="isLoggedIn && isAdmin" open-on-hover offset-y>
          <template v-slot:activator="{ on }">
            <v-btn flat v-on="on">Admin</v-btn>
          </template>
          <v-list>
            <v-list-tile to="/admin_products">
              <v-list-tile-title>Products</v-list-tile-title>
            </v-list-tile>
            <v-list-tile to="">
              <v-list-tile-title>User Accounts</v-list-tile-title>
            </v-list-tile>
          </v-list>
        </v-menu>
        <v-btn v-if="!isLoggedIn" flat to="/sign_up">Sign Up</v-btn>
        <v-btn v-if="isLoggedIn" flat @click="$store.dispatch('logout')">Logout</v-btn>
        <!-- Login Dialog -->
        <v-dialog
          v-else
          v-model="loginDialogShow"
          width="500"
        >
          <template v-slot:activator="{ on }">
            <v-btn flat round v-on="on">Login</v-btn>
          </template>
          <v-card>
            <v-card-title primary-title class="headline grey lighten-2">
              Login
            </v-card-title>
            <v-card-text>
              <v-form>
                <v-text-field
                  v-model="email"
                  label="Email"
                >
                </v-text-field>
                <v-text-field
                  v-model="password"
                  type="password"
                  label="Password"
                  @keydown.enter="submitLogin"
                >
                </v-text-field>
                <v-btn color="primary" @click="submitLogin">
                  Login
                </v-btn>
              </v-form>
            </v-card-text>
          </v-card>
        </v-dialog>
      </v-toolbar-items>
      <!-- <v-toolbar-side-icon @click="drawer = !drawer" class="hidden-md-and-up"></v-toolbar-side-icon> -->
    </v-toolbar>
    <v-content style="padding-bottom: 100px;">
      <v-container fluid>
        <router-view></router-view>

        <v-snackbar
          v-model="snackbarShow"
          bottom
          :color="snackbarVariant"
        >
          {{ snackbarMessage }}
        </v-snackbar>
      </v-container>
    </v-content>
    <Footer />
  </v-app>
</template>

<script>
import axios from 'axios';
import Footer from './components/Footer.vue';

export default {
  name: 'App',
  components: { Footer },
  data() {
    return {
      drawer: false,
      loginDialogShow: false,
      snackbarShow: false,
      snackbarMessage: '',
      snackbarVariant: '',
      email: '',
      password: ''
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.getters.isLoggedIn;
    },
    isAdmin() {
      return this.$store.getters.isAdmin;
    }
  },
  methods: {
    submitLogin() {
      axios
        .post('/api/login', {
          email: this.email,
          password: this.password
        })
        .then(response => {
          console.log(response)
          this.$store.commit('setToken', response.data.auth_token);
          this.$store.commit('setCurrentUser', response.data.current_user);
          this.email = '',
          this.password = ''
          this.snackbarShow = true;
          this.snackbarMessage = 'You have been logged in successfully';
          this.snackbarVariant = 'success';
        })
        .catch(error => {
          console.log(error)
          if (error.response.data.errors) {
            console.log(error.response.data.errors)
          }
          this.snackbarShow = true;
          this.snackbarMessage = 'Incorrect email or password';
          this.snackbarVariant = 'error';
        })
        .finally(() => this.loginDialogShow = false)
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
