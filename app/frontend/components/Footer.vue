<template>
  <v-footer app height="auto" color="light-green lighten-4">
    <v-layout row justify-center wrap>
      <v-flex black--text py-3 text-xs-center xs12>
        &copy; {{ new Date().getFullYear() }} — <strong>PEC</strong>
      </v-flex>
    </v-layout>
  </v-footer>
</template>

<script>
export default {
  name: 'Footer'
}
</script>
