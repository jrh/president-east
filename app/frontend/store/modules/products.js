import axios from 'axios';

const state = {
  productData: [],
  productList: [],
  searchResults: [],
  loading: false
};

const getters = {
  products(state) {
    return state.productData;
  }
};

const actions = {
  fetchProducts({ commit }) {
    axios.get('/api/products')
      .then(response => {
        console.log(response);
        commit('setProducts', response.data);
      })
      .catch(error => console.log(error))
  }
};

const mutations = {
  setProducts(state, data) {
    state.productData = data;
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};

