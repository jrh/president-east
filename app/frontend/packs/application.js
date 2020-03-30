import '../styles/application.scss';
import Rails from '@rails/ujs';
Rails.start()
import Vue from 'vue';
import App from '../App.vue';
import store from '../store';
import router from '../routes.js';
import '../filters/capitalize.js';
import Cookies from 'js-cookie';

// Axios config
import axios from 'axios';
Vue.use({
  install (Vue) {
    const instance = axios.create({
      withCredentials: true,
      baseURL: '/api',
      headers: {
        'Content-Type': 'application/json'
      }
    });
    instance.interceptors.request.use(config => {
      config.headers.Authorization =  'Bearer ' + Cookies.get('jwt');

      return config;
    }, error => {
      // Do something with request error
      return Promise.reject(error);
    });
    instance.interceptors.response.use(response => {
      return response;
    }, error => {
      if (error.response.status == 401 || error.response.status == 422) {
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
import { extend } from 'vee-validate';
import { required, email } from 'vee-validate/dist/rules';

extend('required', {
  ...required,
  message: 'This field is required'
});
extend('email', email);

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
