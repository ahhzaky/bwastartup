// frontend/middleware/auth.js
import { useAuthStore } from '~/stores/auth'

export default defineNuxtRouteMiddleware((to, from) => {
  const authStore = useAuthStore()
  const token = localStorage.getItem('authToken') // Atau cara menyimpan token

  // Jika pengguna belum login (cek store dan token) dan rute yang dituju bukan halaman login
  if ((!authStore.loggedIn || !token) && to.path !== '/login') {
    return navigateTo('/login') // Arahkan ke halaman login
  }
  // Jika pengguna sudah login tapi mencoba mengakses halaman login, arahkan ke dashboard
  if (authStore.loggedIn && token && to.path === '/login') {
    return navigateTo('/dashboard')
  }
})
