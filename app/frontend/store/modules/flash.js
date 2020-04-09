const state = {
  show: false,
  message: '',
  variant: ''
};

const actions = {
  displayFlash({ commit }, payload) {
    commit('setVariant', payload.variant);
    commit('setMessage', payload.message);
    commit('toggleShow', true);
  },
  clearFlash({ commit }) {
    commit('toggleShow', false);
    commit('setVariant', '');
    commit('setMessage', '');
  }
};

const mutations = {
  toggleShow(state, boolean) {
    state.show = boolean;
  },
  setVariant(state, string) {
    state.variant = string;
  },
  setMessage(state, string) {
    state.message = string;
  }
};

export default {
  state,
  actions,
  mutations
};
