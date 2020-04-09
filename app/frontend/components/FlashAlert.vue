<template>
  <b-row align-h="center">
    <b-col lg="6" md="8" cols="11">
      <b-alert
        v-model="$store.state.flash.show"
        :variant="$store.state.flash.variant"
        dismissible
        @dismissed="$store.dispatch('clearFlash')"
      >
        {{ $store.state.flash.message }}
      </b-alert>
    </b-col>
  </b-row>
</template>

<script>
export default {
  name: 'FlashAlert'
}
</script>
