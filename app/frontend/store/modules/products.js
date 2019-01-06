import axios from 'axios';

const state = {
  products: [],
  searchResults: []
};

const getters = {
};

const actions = {
  async fetchProducts({ rootState, commit }) {
    const response = await axios.get('/api/products');
    commit('setProducts', response.data);
  }
};

const mutations = {
  setProducts: (state, products) => {
    state.products = products;
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};

