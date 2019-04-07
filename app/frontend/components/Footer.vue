<template>
  <v-footer app height="auto" color="gray">
    <v-layout row justify-center wrap>
      <v-flex black--text pt-3 text-xs-center xs12>
        &copy; {{ new Date().getFullYear() }} — <strong>PEC</strong>
      </v-flex>
      <v-flex black--text py-3 text-xs-center xs12>
        <span>3 Galasso Place, Maspeth, NY, 11378</span>
        <span class="px-2 font-weight-bold">|</span>
        <span>Tel: (718) 821-5699</span>
        <span class="px-2 font-weight-bold">|</span>
        <span>Fax: (718) 821-6698</span>
      </v-flex>
    </v-layout>
  </v-footer>
</template>

<script>
export default {
  name: 'Footer'
}
</script>
