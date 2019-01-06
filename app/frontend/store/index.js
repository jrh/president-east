import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';
import products from './modules/products';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    products
  }
});

