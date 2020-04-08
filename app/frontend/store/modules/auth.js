import router from '../../routes.js';
import axios from 'axios';

const state = {
  loginModalShow: false,
  // persisted
  isLoggedIn: false,
  currentUser: null,
  csrf: null
};

const getters = {
  isAdmin(state) {
    if (state.currentUser && (state.currentUser.role == 'admin' || state.currentUser.role == 'super_admin')) {
      return true;
    } else {
      return false;
    }
  }
};

const actions = {
  logout({ commit }) {
    axios.delete('/api/logout')
      .then(response => {
        console.log(response)
        commit('setCurrentUser', null);
        commit('logoutUser');
        router.push('/');
      })
      .catch(error => {
        console.log(error)
      });
  },
  forcedLogout({ commit }) {
    axios.delete('/api/logout')
      .then(response => {
        console.log(response)
        commit('setCurrentUser', null);
        commit('logoutUser');
        commit('toggleLoginModalShow', true);
        router.push('/');
      })
      .catch(error => {
        console.log(error)
      });
  }
};

const mutations = {
  setCurrentUser(state, user) {
    state.currentUser = user;
  },
  loginUser(state) {
    state.isLoggedIn = true;
  },
  logoutUser(state) {
    state.isLoggedIn = false;
  },
  toggleLoginModalShow(state, boolean) {
    state.loginModalShow = boolean;
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};

