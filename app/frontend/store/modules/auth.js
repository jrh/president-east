const state = {
  currentUser: null,
  isLoggedIn: false
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
    // TODO:  router:  if in admin area move to home
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
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};

