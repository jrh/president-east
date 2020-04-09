<template>
  <div>
    <AppHeader />
    <b-container fluid class="pt-3">
      <FlashAlert />
      <router-view></router-view>
    </b-container>
    <LoginModal />
  </div>
</template>

<script>
import AppHeader from './components/AppHeader';
import FlashAlert from './components/FlashAlert';
import LoginModal from './components/LoginModal';

export default {
  name: 'App',
  components: { AppHeader, FlashAlert, LoginModal },
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
