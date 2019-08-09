<template>
  <div>
    <b-row align-h="center" class="mt-5">
      <p>Register an Account</p>
    </b-row>
    <b-row align-h="center" class='mt-5'>
      <b-col lg="4" sm="8">
        <b-form>
          <b-form-group label="First Name *" :invalid-feedback="veeErrors.first('firstName')">
            <b-input
              v-model="firstName"
              name="firstName"
              v-validate="{ required: true }"
              data-vv-as="first name"
              :state="validateState('firstName')"
            />
          </b-form-group>

          <b-form-group label="Last Name *" :invalid-feedback="veeErrors.first('lastName')">
            <b-input
              v-model="lastName"
              name="lastName"
              v-validate="{ required: true }"
              data-vv-as="last name"
              :state="validateState('lastName')"
            />
          </b-form-group>

          <b-form-group label="Company">
            <b-input
              v-model="company"
            />
          </b-form-group>

          <b-form-group label="Email *" :invalid-feedback="veeErrors.first('email')">
            <b-input
              v-model="email"
              type="email"
              name="email"
              v-validate="{ required: true, email: true }"
              :state="validateState('email')"
            />
          </b-form-group>

          <b-form-group label="Password *" :invalid-feedback="veeErrors.first('password')">
            <b-input
              v-model="password"
              type="password"
              name="password"
              v-validate="{ required: true }"
              :state="validateState('password')"
            />
          </b-form-group>

          <b-form-group label="Password Confirmation *" :invalid-feedback="veeErrors.first('passwordConfirmation')">
            <b-input
              v-model="passwordConfirmation"
              type="password"
              name="passwordConfirmation"
              v-validate="{ required: true }"
              data-vv-as="password confirmation"
              :state="validateState('passwordConfirmation')"
            />
          </b-form-group>

          <b-btn color="primary" :disabled="veeErrors.any() || !formValid" @click="submit">Submit</b-btn>
        </b-form>
      </b-col>
    </b-row>
  </div>
</template>

<script>
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
      return Object.keys(this.veeFields).every(field => {
        return this.veeFields[field] && this.veeFields[field].valid;
      });
    },
  },
  methods: {
    submit() {
      this.$http.post('/users', {
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
      if (this.veeFields[ref] && (this.veeFields[ref].dirty || this.veeFields[ref].validated)) {
        return this.veeFields[ref].valid;
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
