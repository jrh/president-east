import Vue from 'vue/dist/vue.esm';
import VueRouter from 'vue-router';
import ProductIndex from './components/ProductIndex';

Vue.use(VueRouter);

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/products', component: ProductIndex }
  ]
});

