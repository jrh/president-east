import Vue from 'vue';
import VueRouter from 'vue-router';
import Home from './components';
import About from './components/About';
import UserProfile from './components/UserProfile';
import ProductIndex from './components/ProductIndex';
import ProductShow from './components/ProductShow';
import AdminProductIndex from './components/AdminProductIndex';
import AdminBrandIndex from './components/AdminBrandIndex';
import AdminUserIndex from './components/AdminUserIndex';
import SignUp from './components/SignUp';
import PasswordResetEmail from './components/PasswordResetEmail';
import PasswordReset from './components/PasswordReset';
import NotFoundComponent from './components/NotFoundComponent';

Vue.use(VueRouter);

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/', component: Home, name: 'Home' },
    { path: '/about', component: About },
    { path: '/users/:id/profile', component: UserProfile, props: true },
    { path: '/products', component: ProductIndex },
    { path: '/products/:id', component: ProductShow, props: true },
    { path: '/admin/products', component: AdminProductIndex },
    { path: '/admin/brands', component: AdminBrandIndex },
    { path: '/admin/users', component: AdminUserIndex },
    { path: '/sign_up', component: SignUp },
    { path: '/password/new', component: PasswordResetEmail },
    { path: '/password/edit/:token', component: PasswordReset },

    // Not found
    { path: '/*', component: NotFoundComponent }
  ]
});

