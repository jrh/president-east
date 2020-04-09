<template>
  <b-modal v-model="loginModalShow" title="Login" centered hide-footer @hide="clearForm">
    <b-row align-h="center">
      <b-col cols="10">
        <b-alert v-model="authError" variant="danger" style="font-size: 13px">
          <font-awesome-icon :icon="['far', 'exclamation-circle']" fixed-width />
          <span class="pl-2">{{ $store.state.auth.authMessage }}</span>
        </b-alert>
      </b-col>
    </b-row>
    <b-row align-h="center" class="px-3">
      <ValidationObserver v-slot="{ handleSubmit }" style="width: 300px">
        <ValidationProvider mode="lazy" rules="required|email" name="Email" v-slot="{ errors }">
          <b-form-group label="Email" :invalid-feedback="errors[0]">
            <b-input v-model="form.email" autofocus :state="errors[0] ? false : null" />
          </b-form-group>
        </ValidationProvider>
        <ValidationProvider mode="lazy" rules="required" name="Password" v-slot="{ errors }" vid="password">
          <b-form-group label="Password" :invalid-feedback="errors[0]">
            <b-input v-model="form.password" type="password" :state="errors[0] ? false : null" @keydown.enter="submitLogin" />
          </b-form-group>
        </ValidationProvider>
        <b-form-group class="text-center">
          <Button variant="blue" style="width: 100px" @click="handleSubmit(submitLogin)">Login</Button>
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
      form: {
        email: '',
        password: ''
      },
      processing: false
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
    authError: {
      get() {
        return this.$store.state.auth.authError;
      },
      set(boolean) {
        this.$store.commit('toggleAuthError', boolean);
      }
    }
  },
  methods: {
    submitLogin() {
      if (this.processing) return;
      this.processing = true;
      this.$http.post('/login', {
          session: this.form
        })
        .then(response => {
          console.log(response)
          this.$store.commit('loginUser');
          this.$store.commit('setCurrentUser', response.data);
          this.$store.commit('toggleLoginModalShow', false);
        })
        .catch(error => {
          console.log(error)
          if (error.response.data.auth_message) {
            this.$store.commit('toggleAuthError', true);
            this.$store.commit('setAuthMessage', error.response.data.auth_message);
          }
        })
        .finally(() => this.processing = false);
    },
    goToPasswordReset() {
      this.loginModalShow = false;
      this.$router.push('/passwords/new');
    },
    clearForm() {
      this.form.email = '';
      this.form.password = '';
      this.$store.commit('toggleAuthError', false);
      this.$store.commit('setAuthMessage', '');
    }
  }
}
</script>
