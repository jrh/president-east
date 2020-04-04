<template>
  <div v-if="isAdmin">
    <b-row align-h="center" class="p-2 mt-5 mb-2">
      <span style="font-size: 20px">User Accounts</span>
    </b-row>

    <b-table
      :fields="fields"
      :items="users"
      head-variant="dark"
      bordered
      style="font-size: 14px"
    >
      <!-- Table data -->
      <template v-slot:cell(role)="data">
        <span v-if="data.value == 'admin' || data.value == 'super_admin'">
          <b-badge>Admin</b-badge>
        </span>
      </template>

      <template v-slot:cell(actions)="data">
        <font-awesome-icon :icon="['far', 'edit']" fixed-width />
      </template>
    </b-table>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

export default {
  name: 'AdminUserIndex',
  data() {
    return {
      users: [],
      fields: [
        { key: 'role', label: '', thClass: 'text-center font-lato-th', tdClass: 'text-center' },
        { key: 'first_name', label: 'First Name', thClass: 'font-lato-th' },
        { key: 'last_name', label: 'Last Name', thClass: 'font-lato-th' },
        { key: 'company', label: 'Company', thClass: 'font-lato-th' },
        { key: 'email', label: 'Email', thClass: 'font-lato-th' },
        { key: 'name', label: 'Actions', thClass: 'text-center font-lato-th', tdClass: 'text-center' }
      ],
    }
  },
  computed: {
    ...mapGetters(['isAdmin'])
  },
  mounted() {
    this.fetchUsers();
  },
  methods: {
    fetchUsers() {
      this.$http.get('/admin/users')
        .then(response => {
          console.log(response.data)
          this.users = response.data;
        })
    }
  }
}
</script>
