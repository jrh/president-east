<template>
  <div>
    <b-navbar toggleable="lg" type="light" variant="white">
      <b-navbar-brand to="/">
        <div class="text-center">
        <img :src="require('../images/logo.png')" style="height: 60px; min-width: 120px;, max-width: 250px" />
        <p class="mb-0">President East Co.</p>
        </div>
      </b-navbar-brand>

      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav class="ml-5">
          <b-nav-item to="/products">Product Catalog</b-nav-item>
          <b-nav-item-dropdown v-if="isLoggedIn && isAdmin" text="Admin Menu">
            <b-dropdown-item to="/admin/products">Manage Products</b-dropdown-item>
            <b-dropdown-item to="/admin/brands">Manage Brands</b-dropdown-item>
            <b-dropdown-item to="/admin/users">User Accounts</b-dropdown-item>
          </b-nav-item-dropdown>
        </b-navbar-nav>

        <b-navbar-nav class="ml-auto">
          <b-nav-item-dropdown v-if="isLoggedIn" right no-caret>
            <template #button-content>
              <b-avatar></b-avatar>
            </template>
            <b-dropdown-item :to="`/users/${$store.state.auth.currentUser.id}/profile`">My Profile</b-dropdown-item>
            <b-dropdown-divider />
            <b-dropdown-item @click="$store.dispatch('logout')">
              <span class="text-danger">Logout</span>
            </b-dropdown-item>
          </b-nav-item-dropdown>
          <b-nav-item v-if="!isLoggedIn" to="/sign_up">Sign Up</b-nav-item>
          <b-nav-item v-if="!isLoggedIn" @click="$store.commit('toggleLoginModalShow', true)">Login</b-nav-item>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>

    <!-- Login Modal -->
    <b-modal v-model="loginModalShow" title="Login" centered hide-footer id="login-modal">
      <b-alert v-model="authError" variant="danger">Incorrect email or password</b-alert>
      <b-row align-h="center" class="px-3">
        <b-form style="width: 300px">
          <b-form-group label="Email">
            <b-input v-model="email" autofocus />
          </b-form-group>
          <b-form-group label="Password">
            <b-input v-model="password" type="password" @keydown.enter="submitLogin" />
          </b-form-group>
        </b-form>
      </b-row>
      <b-row align-h="center">
        <Button variant="blue" :disabled="!email || !password" style="width: 100px" @click="submitLogin">Login</Button>
      </b-row>
      <b-row align-h="center" class="mt-5">
        <b-link style="font-size: 14px" @click="goToPasswordReset">Forgot your password?</b-link>
      </b-row>
    </b-modal>
  </div>
</template>

<script>
import Button from './shared/Button';
import ToastAlert from './shared/ToastAlert';

export default {
  name: 'AppHeader',
  components: { Button, ToastAlert },
  data() {
    return {
      email: '',
      password: '',
      authError: false,
      alertShow: false,
      alertVariant: null,
      alertMessage: '',
    }
  },
  computed: {
    loginModalShow: {
      get() {
        return this.$store.state.auth.loginModalShow;
      },
      set(boolean) {
        this.$store.commit('toggleLoginModalShow', boolean);
      }
    },
    isLoggedIn() {
      return this.$store.state.auth.isLoggedIn;
    },
    isAdmin() {
      return this.$store.getters.isAdmin;
    }
  },
  methods: {
    submitLogin() {
      this.$http.post('/login', {
          email: this.email,
          password: this.password
        })
        .then(response => {
          console.log(response)
          this.$store.commit('loginUser');
          this.$store.commit('setCurrentUser', response.data);
          this.$store.commit('toggleLoginModalShow', false);
          this.email = '',
          this.password = ''
          this.authError = false;
          this.alertShow = true;
          this.alertMessage = 'You have been logged in successfully';
          this.alertVariant = 'success';
        })
        .catch(error => {
          console.log('Error')
          console.log(error)
          // if (error.response.data.errors) {
          //   console.log(error.response.data.errors)
          // }
          this.authError = true;
        });
    },
    goToPasswordReset() {
      this.loginModalShow = false;
      this.$router.push('/passwords/new');
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
.nav-item {
  padding: 0 1em;
}
</style>
