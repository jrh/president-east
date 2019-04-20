<template>
  <div>
    <v-layout row justify-center>
      <h3>Admin Section</h3>
    </v-layout>
    <v-layout row justify-center class='mt-5'>
      <v-card>
      <!--   <v-data-table
          :headers="headers"
          :items="products"
          :rows-per-page-items="rowsPerPageItems">
          <template slot="items" slot-scope="props">
            <td>{{ props.item.item_no }}</td>
            <td>{{ props.item.name_en }}</td>
            <td>{{ props.item.name_zh }}</td>
            <td class="text-xs-center">{{ props.item.brand_en }}</td>
            <td class="text-xs-center">{{ props.item.box_quantity }}</td>
            <td class="text-xs-center">{{ props.item.storage_temp }}</td>
            <td class="text-xs-center">
              <v-icon v-if="props.item.image_data">photo</v-icon>
            </td>
            <td class="text-xs-center">
              <v-icon small @click="editItem(props.item)">edit</v-icon>
            </td>
          </template>
        </v-data-table> -->
      </v-card>
    </v-layout>
  </div>

</template>

<script>
export default {
  name: 'AdminUserIndex',
  created() {
    this.fetchUsers;
  },
  methods: {
    fetchUsers() {

    }
  }
}

</script>