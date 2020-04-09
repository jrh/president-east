<template>
  <b-modal v-model="loginModalShow" title="Login" centered hide-footer>
    <b-alert v-model="authError" variant="danger">Incorrect email or password</b-alert>
    <b-row align-h="center" class="px-3">
      <ValidationObserver v-slot="{ handleSubmit }" style="width: 300px">
        <ValidationProvider mode="lazy" rules="required|email" name="Email" v-slot="{ errors }">
          <b-form-group label="Email" :invalid-feedback="errors[0]">
            <b-input v-model="email" autofocus :state="errors[0] ? false : null" />
          </b-form-group>
        </ValidationProvider>
        <ValidationProvider mode="lazy" rules="required" name="Password" v-slot="{ errors }" vid="password">
          <b-form-group label="Password" :invalid-feedback="errors[0]">
            <b-input v-model="password" type="password" :state="errors[0] ? false : null" @keydown.enter="submitLogin" />
          </b-form-group>
        </ValidationProvider>
        <b-form-group class="text-center">
          <Button variant="blue" :disabled="!email || !password" style="width: 100px" @click="handleSubmit(submitLogin)">Login</Button>
        </b-form-group>
      </ValidationObserver>
    </b-row>
    <b-row align-h="center" class="mt-5">
      <b-link style="font-size: 14px" @click="goToPasswordReset">Forgot your password?</b-link>
    </b-row>
  </b-modal>
</template>

<script>
import { ValidationObserver, ValidationProvider } from 'vee-validate';
import Button from './shared/Button';

export default {
  name: 'LoginModal',
  components: { ValidationObserver, ValidationProvider, Button },
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
