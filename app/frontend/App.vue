<template>
  <div>
    <AppHeader />
    <b-container fluid>
      <router-view></router-view>
    </b-container>
  </div>
</template>

<script>
import AppHeader from './components/AppHeader';

export default {
  name: 'App',
  components: { AppHeader },
  // data() {
  //   return {
  //     loginModalShow: false,
  //     email: '',
  //     password: '',
  //     authError: false,
  //     alertShow: false,
  //     alertVariant: null,
  //     alertMessage: '',
  //   }
  // },
  // computed: {
  //   isLoggedIn() {
  //     return this.$store.getters.isLoggedIn;
  //   },
  //   isAdmin() {
  //     return this.$store.getters.isAdmin;
  //   }
  // },
  watch: {
    '$route'() {
      this.handleBgColor();
    }
  },
  mounted() {
    this.handleBgColor();
  },
  methods: {
    handleBgColor() {
      if (this.$route.path == '/' || this.$route.path == '/products') {
        document.body.classList.add('body-bg-yellow');
        document.body.classList.remove('body-bg-white');
      } else {
        document.body.classList.add('body-bg-white');
        document.body.classList.remove('body-bg-yellow');
      }
    }
  }
}
</script>
