const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const customConfig = require('./custom')
const vue = require('./loaders/vue')

environment.config.merge(customConfig)
environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
module.exports = environment
