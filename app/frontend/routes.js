import Vue from 'vue/dist/vue.esm';
import VueRouter from 'vue-router';
import About from './components/About.vue';
import ProductIndex from './components/ProductIndex.vue';
import Contact from './components/Contact.vue';

Vue.use(VueRouter);

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/about', component: About },
    { path: '/products', component: ProductIndex },
    { path: '/contact', component: Contact }
  ]
});

