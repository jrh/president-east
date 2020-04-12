<template>
  <div class="pb-5">
    <b-row align-h="center" class="mt-5 mb-2">
      <p style="font-size: 24px">Register an Account</p>
    </b-row>
    <b-row align-h="center" class="my-5">
      <b-col lg="4" sm="8">
        <b-alert v-model="errorShow" variant="danger" style="font-size: 13px">
          <font-awesome-icon :icon="['far', 'exclamation-circle']" fixed-width />
          <span class="pl-2">{{ errorMessage }}</span>
        </b-alert>
        <ValidationObserver v-slot="{ handleSubmit }">
          <ValidationProvider mode="lazy" rules="required" name="First Name" v-slot="{ errors }">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>First Name</span><span class="asterisk">*</span>
              </template>
              <b-input v-model="form.first_name" autofocus :state="errors[0] ? false : null" />
            </b-form-group>
          </ValidationProvider>

          <ValidationProvider mode="lazy" rules="required" name="Last Name" v-slot="{ errors }">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>Last Name</span><span class="asterisk">*</span>
              </template>
              <b-input v-model="form.last_name" :state="errors[0] ? false : null" />
            </b-form-group>
          </ValidationProvider>

          <b-form-group label="Company">
            <b-input v-model="form.company" />
          </b-form-group>

          <ValidationProvider mode="lazy" rules="required|email" name="Email" v-slot="{ errors }">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>Email</span><span class="asterisk">*</span>
              </template>
              <b-input v-model="form.email" type="email" :state="errors[0] ? false : null" />
            </b-form-group>
          </ValidationProvider>

          <ValidationProvider mode="lazy" rules="required|min:6" name="Password" v-slot="{ errors }" vid="password">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>Password</span><span class="asterisk">*</span><small class="text-muted pl-3">(minimum 6 characters)</small>
              </template>
              <b-input v-model="form.password" type="password" :state="errors[0] ? false : null" />
            </b-form-group>
          </ValidationProvider>

          <ValidationProvider mode="lazy" rules="required|confirmed:password" name="Password Confirmation" v-slot="{ errors }">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>Password Confirmation</span><span class="asterisk">*</span>
              </template>
              <b-input v-model="form.password_confirmation" type="password" :state="errors[0] ? false : null" @keyup.enter="handleSubmit(submit)" />
            </b-form-group>
          </ValidationProvider>

          <Button variant="blue" @click="handleSubmit(submit)">Submit</Button>
        </ValidationObserver>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { ValidationObserver, ValidationProvider, extend } from 'vee-validate';
import { min, confirmed } from 'vee-validate/dist/rules';
extend('min', {
  validate(value, args) {
    return value.length >= args.length;
  },
  params: ['length'],
  message: 'This field must contain at least 6 characters'
});
extend('confirmed', {
  ...confirmed,
  message: 'This field must match the password field'
});
import Button from './shared/Button';

export default {
  name: 'SignUp',
  components: { ValidationObserver, ValidationProvider, Button },
  data() {
    return {
      form: {
        first_name: null,
        last_name: null,
        company: null,
        email: null,
        password: null,
        password_confirmation: null
      },
      errorShow: false,
      errorMessage: '',
      processing: false
    }
  },
  methods: {
    submit() {
      if (this.processing) return;
      this.processing = true;
      this.$http.post('/registrations', {
          registration: this.form
        })
        .then(response => {
          console.log(response)
          this.$store.commit('loginUser');
          this.$store.commit('setCurrentUser', response.data);
          this.$router.push('/');
          this.$store.dispatch('displayFlash', { variant: 'success', message: 'Account registered with success.  You are now logged in' });
        })
        .catch(error => {
          console.log(error)
          if (error.response.data.errors) {
            this.errorMessage = error.response.data.errors.join(', ')
            this.errorShow = true;
          }
        })
        .finally(() => this.processing = false);
    }
  }
}
</script>
