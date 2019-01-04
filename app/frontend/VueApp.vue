<template>
  <v-container fluid>
    <Header />
    <Footer />
  </v-container>
</template>

<script>
import Header from './components/Header.vue';
import Footer from './components/Footer.vue';

export default {
  name: 'App',
  components: { Header, Footer }
}
</script>

<style scoped>

</style>
