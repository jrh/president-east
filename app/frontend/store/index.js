import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';
import auth from './modules/auth';
import products from './modules/products';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    auth,
    products
  }
});

