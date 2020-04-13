<template>
  <div>
    <b-navbar toggleable="lg" type="light" variant="white" class="font-lato">
      <b-navbar-brand to="/">
        <div class="text-center">
        <img :src="require('../images/logo.png')" style="height: 60px; min-width: 120px;, max-width: 250px" />
        <p class="mb-0">President East Co.</p>
        </div>
      </b-navbar-brand>

      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav class="ml-5">
          <b-nav-item to="/products" class="bordered-nav-item">Product Catalog</b-nav-item>
        </b-navbar-nav>

        <b-navbar-nav class="ml-auto d-flex align-items-center">
          <b-nav-item-dropdown v-if="isLoggedIn && isAdmin" text="Admin Menu" class="mr-3 bordered-nav-item admin-nav-item">
            <b-dropdown-item to="/admin/products">Manage Products</b-dropdown-item>
            <b-dropdown-item to="/admin/brands">Manage Brands</b-dropdown-item>
            <b-dropdown-item to="/admin/users">User Accounts</b-dropdown-item>
          </b-nav-item-dropdown>
          <b-nav-item-dropdown v-if="isLoggedIn" right no-caret>
            <template #button-content>
              <b-avatar :text="`${currentUser.first_name.charAt(0)}${currentUser.last_name.charAt(0)}`"></b-avatar>
            </template>
            <b-dropdown-item :to="`/users/${currentUser.id}/profile`">My Profile</b-dropdown-item>
            <b-dropdown-divider />
            <b-dropdown-item @click="$store.dispatch('logout')">
              <span class="text-danger">Logout</span>
            </b-dropdown-item>
          </b-nav-item-dropdown>
          <b-nav-item v-if="!isLoggedIn" @click="$store.commit('toggleLoginModalShow', true)" class="bordered-nav-item">Login</b-nav-item>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
  </div>
</template>

<script>
export default {
  name: 'AppHeader',
  computed: {
    currentUser() {
      return this.$store.state.auth.currentUser;
    },
    isLoggedIn() {
      return this.$store.state.auth.isLoggedIn;
    },
    isAdmin() {
      return this.$store.getters.isAdmin;
    }
  }
}
</script>

<style scoped>
.navbar-brand {
  font-family: 'Roboto Slab', serif;
  font-weight: 700;
  font-size: 26px;
}
a.router-link-active {
  text-decoration: none;
  color: #000;
}
.bordered-nav-item {
  padding: 0 1em;
  border: 1px solid #d9d9d9;
  border-radius: 5px;
  height: 40px;
}
.admin-nav-item {
  border: 1px solid #ffb3b3 !important;
}
.nav-item:hover {
  background-color: #f2f2f2;
}
</style>
