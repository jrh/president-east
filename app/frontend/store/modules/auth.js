import router from '../../routes.js';

const state = {
  loginModalShow: false,
  // persisted
  isLoggedIn: false,
  currentUser: null,
};

const getters = {
  isAdmin(state) {
    if (state.currentUser && state.currentUser.admin) {
      return true;
    } else {
      return false;
    }
  }
};

const actions = {
  logout({ commit }) {
    commit('setCurrentUser', null);
    commit('logoutUser');
    router.push('/');  // TODO: only redirect if in admin area
  },
  forcedLogout({ commit }) {
    commit('setCurrentUser', null);
    commit('logoutUser');
    commit('toggleLoginModalShow', true);
    router.push('/');
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

