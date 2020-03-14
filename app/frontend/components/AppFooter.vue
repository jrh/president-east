<template>
  <div id="app-footer" class="fixed-bottom">
    <b-row style="font-size: 13px" class="pt-3">
      <b-col class="p-3 text-center">
        <span>3 Galasso Place, Maspeth, NY, 11378</span>
        <span class="px-2 font-weight-bold">|</span>
        <span>Tel: (718) 821-5699</span>
        <span class="px-2 font-weight-bold">|</span>
        <span>Fax: (718) 821-6698</span>
      </b-col>
    </b-row>
    <b-row align-h="center" class="pb-3">
      <span>&copy; {{ new Date().getFullYear() }} — <strong>PEC</strong></span>
    </b-row>
  </div>
</template>

<script>
export default {
  name: 'AppFooter'
}
</script>

<style scoped>
#app-footer {
/*  background-color: #f5f5f5;*/
  background-color: #fff;
  border-top: 1px solid #eee;
  color: rgba(0,0,0,.87);
}
</style>
