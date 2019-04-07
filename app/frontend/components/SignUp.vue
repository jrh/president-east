<template>
  <div>
    <v-layout row justify-center class='mt-5'>
      <v-flex lg6>
        <h5>Sign Up</h5>

        <v-form>
          <v-text-field
            v-model="email"
            label="Email"
          >
          </v-text-field>
          <v-text-field
            v-model="password"
            type="password"
            label="Password"
          >
          </v-text-field>
          <v-text-field
            v-model="passwordConfirmation"
            type="password"
            label="Password Confirmation"
          >
          </v-text-field>
          <v-btn @click="submit">
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
      email: '',
      password: '',
      passwordConfirmation: ''
    }
  },
  methods: {
    submit() {
      axios
        .post('/api/users', {
          user: {
            email: this.email,
            password: this.password,
            password_confirmation: this.passwordConfirmation
          }
        })
        .then(response => {
          console.log(response)
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