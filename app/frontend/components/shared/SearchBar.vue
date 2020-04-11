<template>
  <div class="row pl-2">
    <b-input-group size="sm">
      <b-input
        v-model="term"
        :placeholder="placeholder"
        @keyup.enter="search"
      />
      <b-input-group-append>
        <b-button variant="outline-secondary" size="sm" @click="search">
          <font-awesome-icon :icon="['fas', 'search']" fixed-width />
        </b-button>
      </b-input-group-append>
    </b-input-group>
    <!-- <b-form-group class="ml-3">
      <b-button size="sm" @click="reset">Reset</b-button>
    </b-form-group> -->
  </div>
</template>

<script>
// Intended for simple text search, activated by button press/enter
export default {
  name: 'SearchBar',
  props: {
    placeholder: String
  },
  data() {
    return {
      term: ''
    }
  },
  methods: {
    search() {
      this.$emit('search-triggered', this.term);
    },
    // reset() {
    //   this.term = '';
    //   this.$emit('reset');
    // }
  }
}
</script>