<template>
  <div>
    <b-row align-h="center" class="mt-5">
      <p>Register an Account</p>
    </b-row>
    <b-row align-h="center" class='my-5'>
      <b-col lg="4" sm="8">
        <ValidationObserver v-slot="{ invalid }">
          <ValidationProvider rules="required" name="First Name" v-slot="{ valid, errors }">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>First Name</span><span class="asterisk">*</span>
              </template>
              <b-input
                v-model="form.firstName"
                :state="errors[0] ? false : (valid ? true : null)"
              />
            </b-form-group>
          </ValidationProvider>

          <ValidationProvider rules="required" name="Last Name" v-slot="{ valid, errors }">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>Last Name</span><span class="asterisk">*</span>
              </template>
              <b-input
                v-model="form.lastName"
                :state="errors[0] ? false : (valid ? true : null)"
              />
            </b-form-group>
          </ValidationProvider>

          <b-form-group label="Company">
            <b-input
              v-model="form.company"
            />
          </b-form-group>

          <ValidationProvider rules="required|email" name="Email" v-slot="{ valid, errors }">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>Email</span><span class="asterisk">*</span>
              </template>
              <b-input
                v-model="form.email"
                type="email"
                :state="errors[0] ? false : (valid ? true : null)"
              />
            </b-form-group>
          </ValidationProvider>

          <ValidationProvider rules="required" name="Password" v-slot="{ valid, errors }" vid="password">
            <b-form-group :invalid-feedback="errors[0]">
              <template #label>
                <span>Password</span><span class="asterisk">*</span>
              </template>
              <b-input
                v-model="form.password"
                type="password"
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
              />
            </b-form-group>
          </ValidationProvider>

          <Button variant="blue" :disabled="invalid" @click="submit">Submit</Button>
        </ValidationObserver>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { ValidationObserver, ValidationProvider, extend } from 'vee-validate';
import { required, email, confirmed } from 'vee-validate/dist/rules';
extend('required', required);
extend('email', email);
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
        firstName: null,
        lastName: null,
        company: null,
        email: null,
        password: null,
        password_confirmation: null
      }
    }
  },
  computed: {

  },
  methods: {
    submit() {
      this.$http.post('/users', {
          user: this.form
        })
        .then(response => {
          console.log(response)
          this.$store.commit('setToken', response.data.auth_token);
          this.$store.commit('setCurrentUser', response.data.current_user);
          // TODO: alert that user was created
          // TODO: redirect to other page
        })
        .catch(error => {
          console.log(error)
          if (error.response.data.errors) {
            console.log(error.response.data.errors)
          }
        })
    }
  }
}
</script>

<style scoped>
p {
  font-size: 24px;
}
</style>
