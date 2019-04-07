const state = {
  currentUser: null,
  token: null
};

const getters = {
  isLoggedIn(state) {
    return state.token ? true : false;
  },
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
    commit('setToken', null);
    // TODO:  router:  if in admin area move to home
  }
};

const mutations = {
  setCurrentUser(state, user) {
    state.currentUser = user;
  },
  setToken(state, token) {
    state.token = token;
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};

