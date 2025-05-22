// stores/auth.ts
import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null as null | { name: string; image_url?: string },
    loggedIn: false,
  }),
  actions: {
    login(userData: any) {
      this.user = userData
      this.loggedIn = true
    },
    logout() {
      this.user = null
      this.loggedIn = false
    },
  },
})
