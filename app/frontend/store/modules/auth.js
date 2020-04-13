import router from '../../routes.js';
import axios from 'axios';
const instance = axios.create({
  baseURL: '/api',
  headers: {
    'Content-Type': 'application/json'
  },
  withCredentials: true,
  xsrfCookieName: 'CSRF-TOKEN',
  xsrfHeaderName: 'X-CSRF-Token'
});

const state = {
  loginModalShow: false,
  authError: false,
  authMessage: '',
  // persisted
  isLoggedIn: false,
  currentUser: null
};

const getters = {
  isAdmin(state) {
    if (state.currentUser && (state.currentUser.role == 'admin' || state.currentUser.role == 'super_admin')) {
      return true;
    } else {
      return false;
    }
  },
  isSuperAdmin(state) {
    if (state.currentUser && state.currentUser.role == 'super_admin') {
      return true;
    } else {
      return false;
    }
  }
};

const actions = {
  logout({ commit }) {
    instance.delete('/logout')
      .then(response => {
        console.log(response)
        commit('setCurrentUser', null);
        commit('logoutUser');
        router.push('/').catch(err => {});
      })
      .catch(error => {
        console.log(error)
      });
  },
  forcedLogout({ commit }, message) {
    instance.delete('/logout')
      .then(response => {
        console.log(response)
        commit('setCurrentUser', null);
        commit('logoutUser');
        commit('toggleAuthError', true);
        commit('setAuthMessage', message);
        commit('toggleLoginModalShow', true);
        router.push('/').catch(err => {});
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
  },
  toggleAuthError(state, boolean) {
    state.authError = boolean;
  },
  setAuthMessage(state, string) {
    state.authMessage = string;
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};
