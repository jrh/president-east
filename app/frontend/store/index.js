import Vue from 'vue';
import Vuex from 'vuex';
import createPersistedState from 'vuex-persistedstate';
import auth from './modules/auth';
import flash from './modules/flash';
import products from './modules/products';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    auth,
    flash,
    products
  },
  plugins: [
    createPersistedState({
      paths: ['auth.currentUser', 'auth.isLoggedIn']
    })
  ]
});

