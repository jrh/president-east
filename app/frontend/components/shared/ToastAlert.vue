<template>
  <b-alert :show="show" :variant="variant" class="toast-alert">
    <button class="close-button" @click="$emit('close')">
      <span>&times;</span>
    </button>
    <slot></slot>
  </b-alert>
</template>

<script>
export default {
  name: 'ToastAlert',
  props: {
    show: Boolean,
    variant: String
  }
}
</script>

<style scoped>
.toast-alert {
  position: fixed;
  right: 10px;
  bottom: 10px;
  width: 280px;
}
.close-button {
  position: absolute;
  top: 0;
  right: 0;
  padding: 0.5rem 1.25rem;
  color: inherit;
  background-color: transparent;
  border: 0;
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  float: right;
  font-weight: 700;
  font-size: 1.3rem;
  line-height: 1;
  text-shadow: 0 1px 0 #fff;
  opacity: 0.5;
}
</style>
