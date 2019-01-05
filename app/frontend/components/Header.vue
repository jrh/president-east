<template>
  <v-toolbar fixed>
    <v-toolbar-title>President East Co.</v-toolbar-title>
    <v-spacer></v-spacer>
    <v-toolbar-items class="hidden-sm-and-down">
      <v-btn flat>About Us</v-btn>
      <v-btn flat to="/products">Products</v-btn>
      <v-btn flat>Contact</v-btn>
    </v-toolbar-items>
  </v-toolbar>
</template>

<script>
export default {
  name: 'Header'
}
</script>
