<template>
  <div>
    <b-row align-h="center">
      <b-col lg="4" md="6" sm="8" cols="11">
        <b-row class="mt-5">
          <p style="font-size: 24px">My Profile</p>
        </b-row>
        <b-row>
          <b-alert v-model="errorShow" variant="danger" style="font-size: 13px">
            <font-awesome-icon :icon="['far', 'exclamation-circle']" fixed-width />
            <span class="pl-2">{{ errorMessage }}</span>
          </b-alert>
        </b-row>
        <b-row class="mt-5">
          <h4 class="lead">{{ user.first_name + ' ' + user.last_name }}</h4>
        </b-row>
        <b-row class="mt-3 text-muted" style="font-size: 14px">
          <div class="pl-2">
            <p>
              <font-awesome-icon :icon="['far', 'envelope']" size="lg" fixed-width />
              <span class="pl-1">{{ user.email }}</span>
            </p>
            <p v-if="user.company">
              <font-awesome-icon :icon="['fas', 'user-friends']" size="lg" fixed-width />
              <span class="pl-2">{{ user.company }}</span>
            </p>
          </div>
        </b-row>
        <b-row class="mt-5">
          <Button size="sm" @click="openEditModal">
            <font-awesome-icon :icon="['far', 'edit']" fixed-width />
            <span class="pl-2">Edit profile</span>
          </Button>
          <Button size="sm" class="ml-4" @click="passwordModalShow = true">
            <font-awesome-icon :icon="['far', 'key']" fixed-width />
            <span class="pl-2">Change password</span>
          </Button>
        </b-row>
      </b-col>
    </b-row>

    <!-- Profile modal -->
    <b-modal v-model="editModalShow" title="Edit profile" centered>
      <ValidationObserver v-slot="{ invalid }">
        <b-row>
          <b-col>
            <ValidationProvider rules="required" name="First name" v-slot="{ errors }">
              <b-form-group label-size="sm" :invalid-feedback="errors[0]">
                <template #label>
                  <span>First name</span><span class="asterisk">*</span>
                </template>
                <b-input v-model="userForm.first_name" size="sm" :state="errors[0] ? false : null" />
              </b-form-group>
            </ValidationProvider>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <ValidationProvider rules="required" name="Last name" v-slot="{ errors }">
              <b-form-group label-size="sm" :invalid-feedback="errors[0]">
                <template #label>
                  <span>Last name</span><span class="asterisk">*</span>
                </template>
                <b-input v-model="userForm.last_name" size="sm" :state="errors[0] ? false : null" />
              </b-form-group>
            </ValidationProvider>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <ValidationProvider rules="required|email" name="Email" v-slot="{ errors }">
              <b-form-group :invalid-feedback="errors[0]">
                <template #label>
                  <span>Email</span><span class="asterisk">*</span>
                </template>
                <b-input v-model="userForm.email" type="email" size="sm" :state="errors[0] ? false : null" />
              </b-form-group>
            </ValidationProvider>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <b-form-group label="Company" label-size="sm">
              <b-input v-model="userForm.company" size="sm" />
            </b-form-group>
          </b-col>
        </b-row>
        <b-row align-h="around" class="mt-3">
          <Button @click="editModalShow = false">Cancel</Button>
          <Button variant="green" :disabled="invalid" class="float-right" @click="updateUser">Save</Button>
        </b-row>
      </ValidationObserver>
      <template #modal-footer><span></span></template>
    </b-modal>

    <!-- Password modal -->
    <b-modal v-model="passwordModalShow" title="Edit profile" centered @hide="clearPasswordForm">
      <ValidationObserver v-slot="{ handleSubmit }">
        <b-row>
          <b-col>
            <ValidationProvider mode="lazy" rules="required" name="Current Password" v-slot="{ errors }">
              <b-form-group label-size="sm" :invalid-feedback="errors[0]">
                <template #label>
                  <span>Current Password</span><span class="asterisk">*</span>
                </template>
                <b-input v-model="currentPassword" type="password" size="sm" autofocus :state="errors[0] ? false : null" />
              </b-form-group>
            </ValidationProvider>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <ValidationProvider mode="lazy" rules="required|min:6" name="New Password" v-slot="{ errors }" vid="password">
              <b-form-group label-size="sm" :invalid-feedback="errors[0]">
                <template #label>
                  <span>New Password</span><span class="asterisk">*</span><small class="text-muted pl-3">(minimum 6 characters)</small>
                </template>
                <b-input v-model="passwordForm.password" type="password" size="sm" :state="errors[0] ? false : null" />
              </b-form-group>
            </ValidationProvider>
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <ValidationProvider mode="lazy" rules="required|confirmed:password" name="New Password Confirmation" v-slot="{ errors }">
              <b-form-group label-size="sm" :invalid-feedback="errors[0]">
                <template #label>
                  <span>New Password Confirmation</span><span class="asterisk">*</span>
                </template>
                <b-input v-model="passwordForm.password_confirmation" type="password" size="sm" :state="errors[0] ? false : null" @keyup.enter="handleSubmit(updatePassword)" />
              </b-form-group>
            </ValidationProvider>
          </b-col>
        </b-row>
        <b-row align-h="around" class="mt-3">
          <Button @click="passwordModalShow = false">Cancel</Button>
          <Button variant="green" class="float-right" @click="handleSubmit(updatePassword)">Save</Button>
        </b-row>
      </ValidationObserver>
      <template #modal-footer><span></span></template>
    </b-modal>

    <!-- Alert -->
    <ToastAlert :show="alertShow" :variant="alertVariant" @close="alertShow = false">
      {{ alertMessage }}
    </ToastAlert>
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
import ToastAlert from './shared/ToastAlert';

export default {
  name: 'UserProfile',
  components: { ValidationObserver, ValidationProvider, Button, ToastAlert },
  data() {
    return {
      userId: Number(this.$route.params.id),
      user: {},
      editModalShow: false,
      userForm: {
        first_name: null,
        last_name: null,
        email: null,
        company: null
      },
      passwordModalShow: false,
      passwordForm: {
        password: null,
        password_confirmation: null
      },
      currentPassword: null,
      alertShow: false,
      alertVariant: null,
      alertMessage: '',
      errorShow: false,
      errorMessage: '',
      processing: false,
    }
  },
  mounted() {
    this.fetchUser();
  },
  methods: {
    fetchUser() {
      this.$http.get(`/users/${this.userId}`)
        .then(response => {
          console.log(response)
          this.user = response.data;
        })
        .catch(error => {
          console.log(error)
        })
    },
    openEditModal() {
      this.userForm.first_name = this.user.first_name;
      this.userForm.last_name = this.user.last_name;
      this.userForm.email = this.user.email;
      this.userForm.company = this.user.company;
      this.editModalShow = true;
    },
    updateUser() {
      if (this.processing) return;
      this.processing = true;
      this.clearError();
      this.$http.put(`/users/${this.userId}`, {
          user: this.userForm
        })
        .then(response => {
          console.log(response)
          this.user = response.data;
          this.alertVariant = 'success';
          this.alertMessage = 'Profile updated successfully';
          this.alertShow = true;
        })
        .catch(error => {
          console.log(error)
          if (error.response.data.errors) {
            this.errorMessage = error.response.data.errors.join(', ')
            this.errorShow = true;
          } else {
            this.alertVariant = 'danger';
            this.alertMessage = 'Error: Something went wrong';
            this.alertShow = true;
          }
        })
        .finally(() => {
          this.processing = false;
          this.editModalShow = false;
        });
    },
    updatePassword() {
      if (this.processing) return;
      this.processing = true;
      this.clearError();
      this.$http.patch(`/users/${this.userId}/change_password`, {
          current_password: this.currentPassword,
          user: this.passwordForm
        })
        .then(response => {
          console.log(response)
          this.user = response.data;
          this.alertVariant = 'success';
          this.alertMessage = 'Password changed successfully';
          this.alertShow = true;
        })
        .catch(error => {
          console.log(error)
          if (error.response.data.errors) {
            this.errorMessage = error.response.data.errors.join(', ')
            this.errorShow = true;
          } else {
            this.alertVariant = 'danger';
            this.alertMessage = 'Error: Something went wrong';
            this.alertShow = true;
          }
        })
        .finally(() => {
          this.processing = false;
          this.passwordModalShow = false;
        });
    },
    clearPasswordForm() {
      this.passwordForm.password = null;
      this.passwordForm.password_confirmation = null;
      this.currentPassword = null;
    },
    clearError() {
      this.errorShow = false;
      this.errorMessage = '';
    }
  }
}
</script>
