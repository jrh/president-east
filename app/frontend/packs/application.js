import '../styles/application.scss';
import Vue from 'vue/dist/vue.esm';
import Vuetify from 'vuetify';
import VeeValidate from 'vee-validate';
import App from '../App.vue';
import store from '../store';
import router from '../routes.js';
import '../filters/capitalize.js';

// Axios config
import axios from 'axios';
Vue.use({
  install (Vue) {
    const instance = axios.create({
      baseURL: '/api'
    });
    instance.interceptors.response.use(response => {
      return response;
    }, error => {
      // if (error.response.status === 401) {
      //   console.log('401 error intercepted!!!')
      //   Rails.ajax({
      //     url: '/timeout',
      //     type: 'GET',
      //     dataType: 'script',
      //     success: function() { window.location.href = '/accounts/sign_in' }
      //   });
      // }
      return error;
    });
    Vue.prototype.$http = instance;
  }
});

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
