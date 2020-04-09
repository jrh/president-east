<template>
  <div>
    <b-row align-h="center" class="mt-5 mb-2">
      <p style="font-size: 24px">Set a New Password</p>
    </b-row>
    <b-row align-h="center">
      <b-col lg="4" sm="8">
        <small class="font-italic text-info">The new password and confimation password must match</small>
      </b-col>
    </b-row>
    <!-- <b-row>
      <b-col lg="4" sm="8">
        <b-alert v-model="alertError" variant="danger">{{ alertMessage }}</b-alert>
      </b-col>
    </b-row> -->
    <b-row align-h="center" class="mt-3">
      <b-col lg="4" sm="8">
        <ValidationObserver v-slot="{ invalid }">
          <ValidationProvider rules="required" name="Password" v-slot="{ valid, errors }" vid="password">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>Password</span><span class="asterisk">*</span>
              </template>
              <b-input
                v-model="form.password"
                type="password"
                autofocus
                :state="errors[0] ? false : (valid ? true : null)"
              />
            </b-form-group>
          </ValidationProvider>

          <ValidationProvider rules="required|confirmed:password" name="Password Confirmation" v-slot="{ valid, errors }">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>Password Confirmation</span><span class="asterisk">*</span>
              </template>
              <b-input
                v-model="form.password_confirmation"
                type="password"
                :state="errors[0] ? false : (valid ? true : null)"
                @keyup.enter="updatePassword"
              />
            </b-form-group>
          </ValidationProvider>
          <b-form-group>
            <Button variant="blue" :disabled="invalid" @click="updatePassword">Save password</Button>
          </b-form-group>
        </ValidationObserver>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { ValidationObserver, ValidationProvider, extend } from 'vee-validate';
import { confirmed } from 'vee-validate/dist/rules';
extend('confirmed', {
  ...confirmed,
  message: 'This field must match the password field'
});
import Button from './shared/Button';

export default {
  name: 'PasswordReset',
  components: { Button, ValidationObserver, ValidationProvider },
  data() {
    return {
      token: this.$route.params.token,
      form: {
        password: null,
        password_confirmation: null
      },
      processing: false
    }
  },
  methods: {
    updatePassword() {
      if (this.processing) return;
      this.processing = true;
      this.$http.patch(`/password/reset`, {
          token: this.token,
          user: this.form
        })
        .then(response => {
          console.log(response)
          this.$store.commit('loginUser');
          this.$store.commit('setCurrentUser', response.data);
          this.$router.push('/');
        })
        .catch(error => {
          console.log(error)
        })
        .finally(() => this.processing = false);
    }
  }
}
</script>
