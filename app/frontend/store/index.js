import Vue from 'vue';
import Vuex from 'vuex';
import createPersistedState from 'vuex-persistedstate';
import auth from './modules/auth';
import products from './modules/products';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    auth,
    products
  },
  plugins: [
    createPersistedState()
  ]
});

