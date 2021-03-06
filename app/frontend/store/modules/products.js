import axios from 'axios';
import { normalize, schema } from 'normalizr';

const state = {
  productData: {},
  productList: [],
  loading: false
};

const getters = {
  products(state) {
    return state.productList.map(id => state.productData[id]);
  },
  // searchResults(state) {
  //   return state.searchResults;
  // }
};

const actions = {
  fetchProducts({ commit }) {
    axios.get('/api/products')
      .then(response => {
        const myData = { products: response.data };
        const product = new schema.Entity('products');
        const mySchema = { products: [ product ] }
        const normalizedData = normalize(myData, mySchema);
        commit('loadProducts', normalizedData);
      })
      .catch(error => console.log(error))
  }
  // searchProducts({ commit }, term) {
  //   axios.get('/api/products/search', {
  //     params: { search: term }
  //   })
  //   .then(response => {
  //     console.log(response);
  //     commit('setSearchResults', response.data);
  //   })
  //   .catch(error => console.log(error))
  // }
};

const mutations = {
  loadProducts(state, data) {
    state.productData = data.entities.products;
    state.productList = data.result.products;
  },
  addProduct(state, payload) {
    state.productList.push(payload.id);
    state.productData[payload.id] = {
      item_no: payload.item_no,
      name_en: payload.name_en,
      name_zh: payload.name_zh,
      box_quantity: payload.box_quantity,
      storage_temp: payload.storage_temp,
      image_data: payload.image_data,
      image_url: payload.image_url
    };
  },
  setProduct(state, payload) {
    const product = state.productData[payload.id]
    product.item_no = payload.item_no;
    product.name_en = payload.name_en;
    product.name_zh = payload.name_zh;
    product.box_quantity = payload.box_quantity;
    product.storage_temp = payload.storage_temp;
    product.image_data = payload.image_data;
    product.image_url = payload.image_url;
  }
  // setSearchResults(state, data) {
  //   state.searchResults = data;
  // }
};

export default {
  state,
  getters,
  actions,
  mutations
};

