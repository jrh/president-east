import '../styles/application.scss';
import Vue from 'vue';
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

// Bootstrap Vue
import BootstrapVue from 'bootstrap-vue';
Vue.use(BootstrapVue);

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

// Font Awesome SVG
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { library } from '@fortawesome/fontawesome-svg-core';
import {
  faSearch
} from '@fortawesome/pro-solid-svg-icons';

import {
  faImage
} from '@fortawesome/pro-regular-svg-icons';

library.add(
  faImage,
  faSearch
);
Vue.component('font-awesome-icon', FontAwesomeIcon);
