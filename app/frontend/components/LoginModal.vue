<template>
  <b-modal v-model="loginModalShow" title="Login" centered hide-footer>
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
</template>

<script>
import Button from './shared/Button';
import ToastAlert from './shared/ToastAlert';

export default {
  name: 'LoginModal',
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
