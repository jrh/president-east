<template>
  <div>
    <v-layout row justify-center>
      <p>Register an Account</p>
    </v-layout>
    <v-layout row justify-center class='mt-5'>
      <v-flex lg6>
        <v-form>
          <v-text-field
            v-model="firstName"
            label="First Name *"
            name="firstName"
            :error-messages="errors.collect('firstName')"
            v-validate="{ required: true }"
            data-vv-as="first name"
          >
          </v-text-field>

          <v-text-field
            v-model="lastName"
            label="Last Name *"
            name="lastName"
            :error-messages="errors.collect('lastName')"
            v-validate="{ required: true }"
            data-vv-as="last name"
          >
          </v-text-field>

          <v-text-field
            v-model="company"
            label="Company"
          >
          </v-text-field>

          <v-text-field
            v-model="email"
            type="email"
            label="Email *"
            name="email"
            :error-messages="errors.collect('email')"
            v-validate="{ required: true, email: true }"
          >
          </v-text-field>
          <v-text-field
            v-model="password"
            type="password"
            label="Password *"
            name="password"
            :error-messages="errors.collect('password')"
            v-validate="{ required: true }"
          >
          </v-text-field>
          <v-text-field
            v-model="passwordConfirmation"
            type="password"
            label="Password Confirmation *"
            name="passwordConfirmation"
            :error-messages="errors.collect('passwordConfirmation')"
            v-validate="{ required: true }"
            data-vv-as="password confirmation"
          >
          </v-text-field>
          <v-btn right color="primary" :disabled="errors.any() || !formValid" @click="submit">
            Submit
          </v-btn>
        </v-form>

      </v-flex>
    </v-layout>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'SignUp',
  data() {
    return {
      firstName: '',
      lastName: '',
      company: '',
      email: '',
      password: '',
      passwordConfirmation: ''
    }
  },
  computed: {
    formValid() {
      return Object.keys(this.fields).every(field => {
        return this.fields[field] && this.fields[field].valid;
      });
    },
  },
  methods: {
    submit() {
      axios
        .post('/api/users', {
          user: {
            first_name: this.firstName,
            last_name: this.lastName,
            company: this.company,
            email: this.email,
            password: this.password,
            password_confirmation: this.passwordConfirmation
          }
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
    },
    validateState(ref) {
      if (this.fields[ref] && (this.fields[ref].dirty || this.fields[ref].validated)) {
        return this.fields[ref].valid;
      }
      return null;
    },
  }
}
</script>

<style scoped>
p {
  font-size: 24px;
}
</style>
