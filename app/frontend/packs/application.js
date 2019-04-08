import '../styles/application.scss';
import Vue from 'vue/dist/vue.esm';
import Vuetify from 'vuetify';
import VeeValidate from 'vee-validate';
import App from '../App.vue';
import store from '../store';
import router from '../routes.js';
import '../filters/capitalize.js';

Vue.use(Vuetify);
Vue.use(VeeValidate);

document.addEventListener("DOMContentLoaded", () => {
  const el = document.getElementById("vue-app");
  if (el != null) {
    new Vue({
      el,
      store,
      router,
      template: "<App />",
      components: { App },
      created() {
        // load data into store
      }
    });
  }
});
