<template>
  <div>
    <b-row align-h="center">
      <b-col lg="4" md="6" cols="11">
        <b-row class="mt-5">
          <p style="font-size: 24px">My Profile</p>
        </b-row>
        <b-row class="mt-5">
          <h4 class="lead">{{ user.first_name + ' ' + user.last_name }}</h4>
        </b-row>
        <b-row class="mt-3 text-muted" style="font-size: 14px">
          <div>
            <p>
              <font-awesome-icon :icon="['far', 'envelope']" size="lg" fixed-width />
              <span class="pl-2">{{ user.email }}</span>
            </p>
            <p v-if="user.company">
              <font-awesome-icon :icon="['fas', 'user-friends']" size="lg" fixed-width />
              <span class="pl-2">{{ user.company }}</span>
            </p>
          </div>
        </b-row>
        <b-row class="mt-5">
          <Button size="sm" @click="editModalShow">
            <font-awesome-icon :icon="['far', 'edit']" fixed-width />
            <span class="pl-2">Edit profile</span>
          </Button>
          <Button size="sm" disabled class="ml-4">
            <font-awesome-icon :icon="['far', 'key']" fixed-width />
            <span class="pl-2">Change password</span>
          </Button>
        </b-row>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import Button from './shared/Button';

export default {
  name: 'UserProfile',
  components: { Button },
  data() {
    return {
      userId: Number(this.$route.params.id),
      user: {},
      editModalShow: false,
      userForm: {
        first_name: null,
        last_name: null,
        company: null,
        email: null
      },
      alertShow: false,
      alertVariant: null,
      alertMessage: '',
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
    }
  }
}
</script>
