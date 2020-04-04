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
        <b-badge v-if="data.value == 'admin' || data.value == 'super_admin'">Admin</b-badge>
        <b-badge v-else variant="info">Customer</b-badge>
      </template>

      <template v-slot:cell(actions)="data">
        <Button v-if="data.item.role != 'super_admin'" size="sm" @click="openRoleModal(data.item)">
          <font-awesome-icon :icon="['far', 'edit']" fixed-width />
          <span class="pl-1">Edit role</span>
        </Button>
      </template>
    </b-table>

    <!-- Role Modal -->
    <b-modal v-model="roleModalShow" title="Edit role" centered>
      <template #modal-title>Edit role of {{ selectedUser.first_name + ' ' + selectedUser.last_name }}</template>
      <b-row align-h="center" class="px-3">
        <b-form style="width: 300px">
          <b-form-group label="Role:">
            <b-form-radio-group v-model="roleForm.role">
              <b-form-radio value="customer">Customer</b-form-radio>
              <b-form-radio value="admin">Admin</b-form-radio>
            </b-form-radio-group>
          </b-form-group>
        </b-form>
      </b-row>
      <template #modal-footer>
        <b-row align-h="center">
          <Button variant="green" @click="updateUser">Save</Button>
        </b-row>
      </template>
    </b-modal>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import { normalize, schema } from 'normalizr';
import Button from './shared/Button';

export default {
  name: 'AdminUserIndex',
  components: { Button },
  data() {
    return {
      userData: {},
      userList: [],
      roleModalShow: false,
      roleForm: {
        role: null
      },
      selectedUser: null,
      fields: [
        { key: 'role', label: '', thClass: 'text-center font-lato-th', tdClass: 'text-center' },
        { key: 'first_name', label: 'First Name', thClass: 'font-lato-th' },
        { key: 'last_name', label: 'Last Name', thClass: 'font-lato-th' },
        { key: 'company', label: 'Company', thClass: 'font-lato-th' },
        { key: 'email', label: 'Email', thClass: 'font-lato-th' },
        { key: 'actions', label: 'Actions', thClass: 'text-center font-lato-th', tdClass: 'text-center' }
      ],
      processing: false,
    }
  },
  computed: {
    ...mapGetters(['isAdmin']),
    users() {
      return this.userList.map(id => this.userData[id]).sort((a,b) => a.first_name - b.first_name);
    }
  },
  mounted() {
    this.fetchUsers();
  },
  methods: {
    fetchUsers() {
      this.$http.get('/admin/users')
        .then(response => {
          console.log(response.data)
          const userData = normalize(
            { users: response.data },
            { users: [ new schema.Entity('users') ] }
          );
          if (userData.entities.hasOwnProperty('users')) {
            this.userData = userData.entities.users;
          }
          this.userList = userData.result.users;
        })
        .catch(error => {
          console.log(error)
        })
    },
    openRoleModal(user) {
      this.selectedUser = user;
      this.roleForm.role = user.role;
      this.roleModalShow = true;
    },
    updateUser() {
      if (this.processing) return;
      this.processing = true;
      this.$http.put(`/admin/users/${this.selectedUser.id}`, {
          user: this.roleForm
        })
        .then(response => {
          console.log(response);
          this.$set(this.userData, response.data.id, response.data);
        })
        .catch(error => {
          this.alertShow = true;
          this.alertVariant = 'danger';
          if (error.response.data.errors) {
            this.alertMessage = error.response.data.errors[0];
          } else {
            this.alertMessage = 'Not able to update user'
          }
        })
        .finally(() => {
          this.processing = false;
          this.roleModalShow = false;
          this.roleForm.role = null;
        });
    }
  }
}
</script>
