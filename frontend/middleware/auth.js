// frontend/middleware/auth.js
import { useAuthStore } from '~/stores/auth'

export default defineNuxtRouteMiddleware((to, from) => {
  const authStore = useAuthStore()
  const token = localStorage.getItem('authToken')

  if ((!authStore.loggedIn || !token) && to.path !== '/login') {
    return navigateTo('/login') // Arahkan ke halaman login
  }

  if (authStore.loggedIn && token && to.path === '/login') {
    return navigateTo('/dashboard')
  }
})
