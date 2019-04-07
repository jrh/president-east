<template>
  <div>
    <v-layout row justify-center class='mt-5'>
      <v-flex lg6>
        <h5>Login</h5>

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
          <v-btn @click="submit">
            Login
          </v-btn>
        </v-form>

      </v-flex>
    </v-layout>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'SignIn',
  data() {
    return {
      email: '',
      password: ''
    }
  },
  methods: {
    submit() {
      axios
        .post('/api/login', {
          email: this.email,
          password: this.password
        })
        .then(response => {
          console.log(response)
          // TODO: alert that user was logged in
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
