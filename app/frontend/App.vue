<template>
  <div>
    <b-navbar toggleable="lg" type="light" variant="white">
      <b-navbar-brand to="/">
        <div class="text-center">
        <img :src="require('./images/logo.png')" style="height: 60px; min-width: 120px;, max-width: 250px" />
        <p class="mb-0">President East Co.</p>
        </div>
      </b-navbar-brand>

   <!--    <b-navbar-toggle target="nav-collapse"></b-navbar-toggle> -->

      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav class="ml-5">
       <!--    <b-nav-item to="/about">About Us</b-nav-item> -->
          <b-nav-item to="/products">Product Catalog</b-nav-item>
        </b-navbar-nav>

         <b-navbar-nav class="ml-auto">
          <b-nav-item-dropdown v-if="isLoggedIn && isAdmin" text="Admin" right>
            <b-dropdown-item to="/admin/products">Products</b-dropdown-item>
            <b-dropdown-item to="/admin/users">User Accounts</b-dropdown-item>
          </b-nav-item-dropdown>
          <b-nav-item v-if="!isLoggedIn" to="/sign_up">Sign Up</b-nav-item>
          <b-nav-item v-if="isLoggedIn" @click="$store.dispatch('logout')">Logout</b-nav-item>

          <b-nav-item v-else @click="loginModalShow = true">Login</b-nav-item>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>

    <b-container fluid>
      <router-view></router-view>
    </b-container>

    <Footer />

    <!-- Login Modal -->
    <b-modal v-model="loginModalShow">
      <b-form>
        <b-form-group label="Email">
          <b-input v-model="email" />
        </b-form-group>
        <b-form-group label="Password">
          <b-input v-model="password" type="password" @keydown.enter="submitLogin" />
        </b-form-group>
      </b-form>
      <b-btn variant="primary" @click="submitLogin">Login</b-btn>
    </b-modal>
  </div>
</template>

<script>
import Footer from './components/Footer.vue';

export default {
  name: 'App',
  components: { Footer },
  data() {
    return {
      drawer: false,
      loginModalShow: false,
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
  watch: {
    '$route'() {
      this.handleBgColor();
    }
  },
  mounted() {
    this.handleBgColor();
  },
  methods: {
    submitLogin() {
      this.$http.post('/login', {
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
        .finally(() => this.loginModalShow = false)
    },
    handleBgColor() {
      if (this.$route.path == "/") {
        document.body.classList.add('body-bg-yellow');
        document.body.classList.remove('body-bg-white');
      } else {
        document.body.classList.add('body-bg-white');
        document.body.classList.remove('body-bg-yellow');
      }
    }
  }
}
</script>

<style scoped>
.navbar-brand {
  font-family: 'Roboto Slab', serif;
  font-weight: 700;
  font-size: 26px;
}
a.router-link-active {
  text-decoration: none;
  color: #000;
}
</style>
