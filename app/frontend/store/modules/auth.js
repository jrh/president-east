const state = {
  currentUser: null,
  token: null
};

const getters = {
  isLoggedIn(state) {
    return state.token ? true : false;
  }
};

const actions = {
  logout({ commit }) {
    commit('setCurrentUser', null);
    commit('setToken', null);
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

