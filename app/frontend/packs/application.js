import '../styles/application.scss';
import Rails from '@rails/ujs';
Rails.start()
import Vue from 'vue';
import App from '../App.vue';
import store from '../store';
import router from '../routes.js';
import '../filters/titleize.js';
import Cookies from 'js-cookie';

// Axios config
import axios from 'axios';
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
    store.dispatch('forcedLogout');
    // trigger event and login modal
  }
  return Promise.reject(error);
});
Vue.prototype.$http = instance;

// Bootstrap Vue
import {
  AlertPlugin,
  AvatarPlugin,
  BadgePlugin,
  ButtonPlugin,
  CardPlugin,
  FormPlugin,
  FormGroupPlugin,
  FormInputPlugin,
  FormRadioPlugin,
  FormSelectPlugin,
  InputGroupPlugin,
  LayoutPlugin,
  LinkPlugin,
  ModalPlugin,
  NavbarPlugin,
  SpinnerPlugin,
  TablePlugin
} from 'bootstrap-vue'

Vue.use(AlertPlugin);
Vue.use(AvatarPlugin);
Vue.use(BadgePlugin);
Vue.use(ButtonPlugin);
Vue.use(CardPlugin);
Vue.use(FormPlugin);
Vue.use(FormGroupPlugin);
Vue.use(FormInputPlugin);
Vue.use(FormRadioPlugin);
Vue.use(FormSelectPlugin);
Vue.use(InputGroupPlugin);
Vue.use(LayoutPlugin);
Vue.use(LinkPlugin);
Vue.use(ModalPlugin);
Vue.use(NavbarPlugin);
Vue.use(SpinnerPlugin);
Vue.use(TablePlugin);

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
  faExclamationCircle,
  faSearch
} from '@fortawesome/pro-solid-svg-icons';

import {
  faEdit,
  faImage
} from '@fortawesome/pro-regular-svg-icons';

library.add(
  faEdit,
  faExclamationCircle,
  faImage,
  faSearch
);
Vue.component('font-awesome-icon', FontAwesomeIcon);
