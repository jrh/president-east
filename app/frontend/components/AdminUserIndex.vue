<template>
  <div>
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
      <template #admin="data">
        <span v-if="data.value">
          <b-badge>Admin</b-badge>
        </span>
      </template>

      <template #actions="data">
        <font-awesome-icon :icon="['far', 'edit']" fixed-width />
      </template>
    </b-table>
  </div>
</template>

<script>
export default {
  name: 'AdminUserIndex',
  data() {
    return {
      users: [],
      fields: [
        { key: 'admin', label: '', tdClass: 'text-center', thClass: 'text-center' },
        { key: 'first_name', label: 'First Name' },
        { key: 'last_name', label: 'Last Name' },
        { key: 'company', label: 'Company' },
        { key: 'email', label: 'Email' },
        { key: 'name', label: 'Actions', tdClass: 'text-center', thClass: 'text-center' }
      ],
    }
  },
  mounted() {
    this.fetchUsers();
  },
  methods: {
    fetchUsers() {
      this.$http.get('/users')
        .then(response => {
          console.log(response.data)
          this.users = response.data;
        })
    }
  }
}
</script>
