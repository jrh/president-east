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
  createProduct({ commit }, product) {
    axios.post('/api/products', { product })
      .then(response => {
        console.log(response);
        commit('addProduct', response.data);
      })
      .catch(error => console.log(error))
  },
  updateProduct({ commit }, product) {
    axios({
      method: 'put',
      url: `/api/products/${product.id}`,
      data: { product }
    })
    .then(response => {
      console.log(response);
      commit('editProduct', response.data);
    })
    .catch(error => console.log(error))
  }
};

const mutations = {
  setProducts(state, data) {
    state.productData = data.entities.products;
    state.productList = data.result.products;
  },
  addProduct(state, payload) {
    state.productList.push(payload.id);
    state.productData[payload.id] = {
      item_no: payload.item_no,
      name_en: payload.name_en,
      name_zh: payload.name_zh,
      brand_en: payload.brand_en,
      brand_zh: payload.brand_zh,
      box_quantity: payload.box_quantity,
      storage_temp: payload.storage_temp
    };
  },
  editProduct(state, payload) {
    const product = state.productData[payload.id]
    product.item_no = payload.item_no;
    product.name_en = payload.name_en;
    product.name_zh = payload.name_zh;
    product.brand_en = payload.brand_en;
    product.brand_zh = payload.brand_zh;
    product.box_quantity = payload.box_quantity;
    product.storage_temp = payload.storage_temp;
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};

