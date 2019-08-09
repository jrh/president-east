<template>
  <router-link
    v-if="to"
    :to="to"
    class="vue-button"
    :class="[variantClass, sizeClass]"
    :variant="variant"
    @click="$emit('click')"
  >
    <slot></slot>
  </router-link>
  <a
    v-else-if="href"
    :href="href"
    class="vue-button"
    :class="[variantClass, sizeClass]"
    :variant="variant"
    @click="$emit('click')"
  >
    <slot></slot>
  </a>
  <button
    v-else
    class="vue-button"
    :class="[variantClass, sizeClass]"
    :variant="variant"
    @click="$emit('click')"
  >
    <slot></slot>
  </button>
</template>

<script>
export default {
  name: 'Button',
  props: {
    size: {
      type: String,
      required: false
    },
    variant: {
      type: String,
      required: false
    },
    to: {
      type: String,
      required: false
    },
    href: {
      type: String,
      required: false
    }
  },
  computed: {
    sizeClass() {
      if (this.size) {
        return this.size;
      }
    },
    variantClass() {
      if (this.variant) {
        return this.variant;
      }
    }
  }
}
</script>

<style scoped>
.vue-button {
  position: relative;
  display: inline-flex;
  justify-content: center;
  align-items: center;
  padding: 6px 12px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  border: 1px solid rgba(27,31,35,0.2);
  border-radius: 0.3em;
  vertical-align: middle;
  line-height: 20px;
  white-space: nowrap;
  user-select: none;
  background-repeat: repeat-x;
  color: #24292e;
  background-color: #eff3f6;
  background-image: linear-gradient(-180deg, #fafbfc 0%, #eff3f6 90%);
  background-position: -1px -1px;
  background-size: 110%, 110%;
  text-align: center;
  user-select: none;
}

.vue-button:hover {
  color: #24292e;
  background-color: #e6ebf1;
  background-image: linear-gradient(-180deg, #f0f3f6 0%, #e6ebf1 90%);
  background-position: -.5em;
  border-color: rgba(27,31,35,0.35);
  text-decoration: none;
  background-repeat: repeat-x;
}

.vue-button:focus {
  box-shadow: 0 0 0 0.2em rgba(3,102,214,0.3);
}

.vue-button:active {
  background-color: #e9ecef;
  background-image: none;
  border-color: rgba(27,31,35,0.35);
  box-shadow: inset 0 0.15em 0.3em rgba(27,31,35,0.15);
}

.vue-button:disabled {
  opacity: .65;
  cursor: not-allowed;
}

.disabled {
  opacity: .65;
  pointer-events: none;
}

.btn-group>.vue-button:not(:first-child) {
  border-top-left-radius: 0;
  border-bottom-left-radius: 0;
  margin-left: -1px;
}
.btn-group>.vue-button:not(:last-child) {
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
}

/*// size small*/
.vue-button.sm {
  padding: 3px 10px;
  font-size: 11px;
  line-height: 20px;
}

/*// Pressed button*/
.vue-button-pressed {
  box-shadow: inset 0 0.15em 0.3em rgba(27,31,35,0.15);
  background-color: #ced9e4;
  background-image: linear-gradient(-180deg, #dfe6ec 0%, #ced9e4 90%);
  pointer-events: none;
  cursor: default;
  opacity: 0.8;
}

/*Green*/
.vue-button.green {
  color: #fff;
  background-color: #28a745;
  background-image: linear-gradient(-180deg, #34d058 0%, #28a745 90%);
}

.vue-button.green:hover {
  color: #fff;
  background-color: #269f42;
  background-image: linear-gradient(-180deg, #2fcb53 0%, #269f42 90%);
  background-position: -5em;
  border-color: rgba(27,31,35,0.5);
}

.vue-button.green:focus {
  box-shadow: 0 0 0 0.2em rgba(52,208,88,0.4);
}

.vue-button.green:active {
  background-color: #279f43;
  background-image: none;
  border-color: rgba(27,31,35,0.5);
  box-shadow: inset 0 0.15em 0.3em rgba(27,31,35,0.15);
}

/*// blue*/
.vue-button.blue {
  color: #fff;
  background-color: #1d58b7;
  background-image: linear-gradient(-180deg, #4286f4 0%, #1d58b7 90%);
}

.vue-button.blue:hover {
  color: #fff;
  background-color: #164ca3;
  background-image: linear-gradient(-180deg, #3875d8 0%, #164ca3 90%);
  background-position: -5em;
  border-color: rgba(27,31,35,0.5);
}

.vue-button.blue:focus {
  box-shadow: 0 0 0 0.2em rgba(52,208,88,0.4);
}

.vue-button.blue:active {
  background-color: #1d58b7;
  background-image: none;
  border-color: rgba(27,31,35,0.5);
  box-shadow: inset 0 0.15em 0.3em rgba(27,31,35,0.15);
}

/*// red*/
.vue-button.red {
  color: #fff;
  background-color: #cc414c;
  background-image: linear-gradient(-180deg, #ef5b66 0%, #cc414c 90%);
}
.vue-button.red:hover {
  color: #fff;
  background-color: #c63f4a;
  background-image: linear-gradient(-180deg, #e54b58 0%, #c63f4a 90%);
  background-position: -5em;
  border-color: rgba(27,31,35,0.5);
}

.vue-button.red:focus {
  box-shadow: 0 0 0 0.2em rgba(52,208,88,0.4);
}

.vue-button.red:active {
  background-color: #b5303b;
  background-image: none;
  border-color: rgba(27,31,35,0.5);
  box-shadow: inset 0 0.15em 0.3em rgba(27,31,35,0.15);
}
</style>