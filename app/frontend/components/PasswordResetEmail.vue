<template>
  <div>
    <b-row align-h="center" class="mt-5 mb-2">
      <p style="font-size: 24px">Reset My Password</p>
    </b-row>
    <b-row align-h="center">
      <b-col lg="4" sm="8">
        <small class="font-italic text-info">Submit your email in order to receive an email with password reset instructions</small>
      </b-col>
    </b-row>
    <b-row align-h="center">
      <b-col lg="4" sm="8">
        <b-alert v-model="alertError" variant="danger">{{ alertMessage }}</b-alert>
      </b-col>
    </b-row>
    <b-row align-h="center" class="mt-3">
      <b-col lg="4" sm="8">
        <ValidationObserver v-slot="{ handleSubmit }">
          <ValidationProvider mode="lazy" rules="required|email" name="Email" v-slot="{ errors }">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>Email</span><span class="asterisk">*</span>
              </template>
              <b-input
                v-model="email"
                type="email"
                autofocus
                :state="errors[0] ? false : null"
                @keyup.enter="handleSubmit(sendEmail)"
              />
            </b-form-group>
          </ValidationProvider>
          <b-form-group>
            <Button variant="blue" @click="handleSubmit(sendEmail)">Initiate password reset</Button>
          </b-form-group>
        </ValidationObserver>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { ValidationObserver, ValidationProvider } from 'vee-validate';
import Button from './shared/Button';

export default {
  name: 'PasswordResetEmail',
  components: { ValidationObserver, ValidationProvider, Button },
  data() {
    return {
      email: null,
      processing: false,
      alertError: false,
      alertMessage: ''
    }
  },
  methods: {
    sendEmail() {
      if (this.processing) return;
      this.processing = true;
      this.$http.post('/passwords', {
          password: {
            email: this.email
          }
        })
        .then(response => {
          console.log(response)
          this.$router.push({ name: 'Home', params: { password_reset: true }});
        })
        .catch(error => {
          console.log(error)
          if (error.response.data.error) {
            console.log(error.response.data.error)
            this.alertError = true;
            this.alertMessage = error.response.data.error;
          }
        })
        .finally(() => this.processing = false);
    }
  }
}
</script>
