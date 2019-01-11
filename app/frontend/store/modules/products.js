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
  },
  createProduct({ commit }) {
    axios.post('/api/products', {

    })
    .then(response => console.log(response))
    .catch(error => console.log(error))
  },
  updateProduct({ commit }, product) {
    axios({
      method: 'put',
      url: `/api/products/${product.id}`,
      data: { product }
    })
    .then(response => {
      console.log(response)
      commit('editProduct', response.data)
    })
    .catch(error => console.log(error))
  }
};

const mutations = {
  setProducts(state, data) {
    state.productData = data.entities.products;
    state.productList = data.result.products;
  },
  editProduct(state, payload) {
    const product = state.productData[payload.id]
    product.name_en = payload.name_en
    product.name_zh = payload.name_zh
    product.brand_en = payload.brand_en
    product.box_quantity = payload.box_quantity
    product.storage_temp = payload.storage_temp
  },
  newProduct(state, payload) {

  }
};

export default {
  state,
  getters,
  actions,
  mutations
};

