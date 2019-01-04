<template>
  <v-footer
    fixed
    height="auto"
    color="primary lighten-1"
  >
    <v-layout
      justify-center
      row
      wrap
    >
      <!-- <v-btn
        v-for="link in links"
        :key="link"
        color="white"
        flat
        round
      >
        {{ link }}
      </v-btn> -->
      <v-flex
        primary
        lighten-2
        py-3
        text-xs-center
        black--text
        xs12
      >
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