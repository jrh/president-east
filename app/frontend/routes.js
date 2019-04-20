import Vue from 'vue/dist/vue.esm';
import VueRouter from 'vue-router';
import Home from './components';
import About from './components/About';
import ProductIndex from './components/ProductIndex';
import AdminProductIndex from './components/AdminProductIndex';
import AdminUserIndex from './components/AdminUserIndex';
import SignUp from './components/SignUp';

Vue.use(VueRouter);

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/', component: Home },
    { path: '/about', component: About },
    { path: '/products', component: ProductIndex },
    { path: '/admin/products', component: AdminProductIndex },
    { path: '/admin/users', component: AdminUserIndex },
    { path: '/sign_up', component: SignUp }
  ]
});

