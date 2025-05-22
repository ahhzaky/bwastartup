// nuxt.config.ts
export default defineNuxtConfig({
  // Kompatibilitas dan devtools
  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },
  css: ['@/assets/css/tailwind.css'],
  tailwindcss: {
    exposeConfig: true,
    configPath: 'tailwind.config.js',
    viewer: false
  },

  // SPA-like behavior (disable SSR)
  ssr: false,

  // Modules
  modules: [
    '@nuxtjs/tailwindcss',
    '@pinia/nuxt',
  ],

  // Runtime environment (env var)
  runtimeConfig: {
    public: {
        BASE_URL_API: process.env.BASE_URL_API || 'https://localhost:8080'  // untuk axios module 
    }
  },

  // App head
  app: {
  // Auth config is now moved to auth property in @nuxtjs/auth-next module options

  // // Auth config
  // auth: {
  //   strategies: {
  //     local: {
  //       token: {
  //         property: 'data.token',
  //         type: 'Bearer'
  //       },
  //       user: {
  //         property: 'data',
  //         autoFetch: true
  //       },
  //       endpoints: {
  //         login: { url: '/api/v1/sessions', method: 'post' },
  //         logout: false,
  //         user: { url: '/api/v1/users/fetch', method: 'get' }
  //       }
  //     }
  //   }
  // },

    head: {
      title: 'CrowdFunding App Starup',
      meta: [
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { charset: 'utf-8' },
        { name: 'description', content: 'Nuxt 3 App' }
      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
      ]
    }
  },
  // Build config
  build: {
  }
})
