import axios from 'axios';
import { normalize, schema } from 'normalizr';

const state = {
  productData: {},
  productList: [],
  searchResults: [],
  loading: false
};

const getters = {
  products(state) {
    return state.productList.map(id => state.productData[id]);
  }
};

const actions = {
  fetchProducts({ commit }) {
    axios.get('/api/products')
      .then(response => {
        const myData = { products: response.data };
        const product = new schema.Entity('products');
        const mySchema = { products: [ product ] }
        const normalizedData = normalize(myData, mySchema);
        commit('setProducts', normalizedData);
      })
      .catch(error => console.log(error))
  }
};

const mutations = {
  setProducts(state, data) {
    state.productData = data.entities.products;
    state.productList = data.result.products;
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};

