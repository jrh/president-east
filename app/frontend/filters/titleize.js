import Vue from 'vue';

Vue.filter('titleize', function (value) {
  if (!value) return ''
  value = value.toString()
  let words = value.split("_");
  return words.map(function (word) {
    return word.charAt(0).toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
})
