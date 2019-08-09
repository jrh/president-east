import '../styles/application.scss';
import Vue from 'vue';
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
      if (error.response.status === 401) {
        console.log('401 error intercepted!!!')
        return Promise.reject(error)
      }
      return error;
    });
    Vue.prototype.$http = instance;
  }
});

// Bootstrap Vue
import BootstrapVue from 'bootstrap-vue';
Vue.use(BootstrapVue);

// Vee Validate
import { Validator, install as VeeValidate } from 'vee-validate/dist/vee-validate.minimal.esm.js';
import { required, email } from 'vee-validate/dist/rules.esm.js';

Validator.extend('required', required);
Validator.extend('email', email);
Vue.use(VeeValidate, {
  inject: true,
  errorBagName: 'veeErrors',
  fieldsBagName: 'veeFields'
});

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
  faEdit,
  faImage
} from '@fortawesome/pro-regular-svg-icons';

library.add(
  faEdit,
  faImage,
  faSearch
);
Vue.component('font-awesome-icon', FontAwesomeIcon);
