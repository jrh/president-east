import Vue from 'vue/dist/vue.esm';
import VueRouter from 'vue-router';
import Home from './components';
import About from './components/About';
import ProductIndex from './components/ProductIndex';
import Contact from './components/Contact';
import AdminProductIndex from './components/AdminProductIndex';
import SignUp from './components/SignUp';

Vue.use(VueRouter);

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/', component: Home },
    { path: '/about', component: About },
    { path: '/products', component: ProductIndex },
    { path: '/contact', component: Contact },
    { path: '/admin_products', component: AdminProductIndex },
    { path: '/sign_up', component: SignUp }
  ]
});

