<template>
  <div>
    <v-layout row justify-center class='mt-5'>
      <v-card>
        <v-layout row class="pa-2">
          <v-card-title style="font-size: 20px;">User Accounts</v-card-title>
        </v-layout>
        <v-data-table
          :headers="headers"
          :items="users"
          hide-actions
        >
          <template v-slot:items="props">
            <td>
              <span v-if="props.item.admin" class="red--text caption">ADMIN</span>
            </td>
            <td>{{ props.item.first_name }}</td>
            <td>{{ props.item.last_name }}</td>
            <td>{{ props.item.company }}</td>
            <td>{{ props.item.email }}</td>
            <td class="text-xs-center">
              <!-- <v-icon small @click="editItem(props.item)">edit</v-icon> -->
            </td>
          </template>
        </v-data-table>
      </v-card>
    </v-layout>
  </div>

</template>

<script>
export default {
  name: 'AdminUserIndex',
  data() {
    return {
      users: [],
      headers: [
        { text: '', align: 'left', value: 'admin', sortable: false },
        { text: 'First Name', align: 'left', value: 'first_name' },
        { text: 'Last Name', align: 'left', value: 'last_name' },
        { text: 'Company', align: 'left', value: 'company' },
        { text: 'Email', align: 'left', value: 'email' },
        { text: 'Actions', align: 'center', value: 'name', sortable: false }
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