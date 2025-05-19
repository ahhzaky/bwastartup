// nuxt.config.ts
export default defineNuxtConfig({
  // Kompatibilitas dan devtools
  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },

  // SPA-like behavior (disable SSR)
  ssr: false,

  // Modules
  modules: [
    '@nuxtjs/tailwindcss',
    '@nuxtjs/axios',
    [
      '@nuxtjs/auth-next',
      {
        strategies: {
          local: {
            token: {
              property: 'data.token',
              type: 'Bearer'
            },
            user: {
              property: 'data',
              autoFetch: true
            },
            endpoints: {
              login: { url: '/api/v1/sessions', method: 'post' },
              logout: false,
              user: { url: '/api/v1/users/fetch', method: 'get' }
            }
          }
        }
      }
    ]
  ],

  // Runtime environment (env var)
  runtimeConfig: {
    public: {
      axios: {
        baseURL: process.env.BASEURL  // untuk axios module 
      }
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
  build: {}
})
