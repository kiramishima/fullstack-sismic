// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  runtimeConfig: {
    // Keys within public are also exposed client-side
    public: {
      apiBase: '/api'
    }
  },
  // Tailwind
  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },
  css: ['~/assets/css/main.css'],
  modules: [
    '@nuxtjs/device',
  ],
  devServer: {
    port: 4000
  },
  spaLoadingTemplate: false
})
