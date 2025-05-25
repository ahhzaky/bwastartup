<template>
  <header class="flex items-center">
    <div style="height: 54px" class="pr-5">
      <img src="/logo.svg" alt="logo" class="h-full" />
    </div>
    <ul class="flex items-center">
      <li>
        <NuxtLink
          class="text-white hover:text-teal-500 text-lg px-4 py-3"
          to="/"
        >
          Home
        </NuxtLink>
      </li>
      <li>
        <a
          class="text-white hover:text-teal-500 text-lg px-4 py-3"
          href="#projects"
          >Project</a
        >
      </li>
      <li>
        <a
          class="text-white hover:text-teal-500 text-lg px-4 py-3"
          href="#features"
          >Features</a
        >
      </li>
      <li>
        <a
          class="text-white hover:text-teal-500 text-lg px-4 py-3"
          href="#testimonials"
          >Success Stories</a
        >
      </li>
    </ul>
    <ul
      class="flex ml-auto items-center mt-2"
      v-if="!authStore.loggedIn"
    >
      <li>
        <NuxtLink
          to="/register"
          class="inline-block bg-transparent border-white border hover:bg-white hover:bg-opacity-25 text-white font-light w-40 text-center px-6 py-1 text-lg rounded-full mr-4"
        >
          Sign Up
        </NuxtLink>
      </li>
      <li>
        <NuxtLink
          to="/login"
          class="inline-block bg-transparent border-white border hover:bg-white hover:bg-opacity-25 text-white font-light w-40 text-center px-6 py-1 text-lg rounded-full"
        >
          My Account
        </NuxtLink>
      </li>
    </ul>
    <div class="flex ml-auto" v-else>
      <div class="dropdown inline-block relative z-10">
        <button
          class="bg-white text-gray-700 font-semibold py-4 px-6 rounded inline-flex items-center"
        >
          <img
            v-if="authStore.user?.image_url"
            :src="`${config.public.BASE_URL_API}/${authStore.user.image_url}`"
            alt="User Avatar"
            class="h-8 w-8 object-cover rounded-full mr-2"
          />
          <img
            v-else
            src="/avatar.jpg"
            alt="Default Avatar"
            class="h-8 w-8 object-cover rounded-full mr-2"
          />
          <span class="mr-1">
            {{ authStore.user?.name || 'User' }}
          </span>
          <svg
            class="fill-current h-4 w-4"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
          >
            <path
              d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
            />
          </svg>
        </button>
        <ul
          class="dropdown-menu absolute hidden text-gray-700 pt-1 shadow w-full -mt-2"
        >
          <li class="">
            <NuxtLink
              class="bg-white hover:bg-gray-100 hover:text-orange-500 py-2 px-4 block whitespace-no-wrap"
              to="/dashboard"
              >My Dashboard</NuxtLink
            >
          </li>
          <li class="">
            <NuxtLink
              class="bg-white hover:bg-gray-100 border-t hover:text-orange-500 py-2 px-4 block whitespace-no-wrap"
              to="/dashboard/settings" 
            >Account Settings</NuxtLink 
            >
          </li>
          <li class="">
            <a
              class="cursor-pointer rounded-b bg-white hover:bg-gray-100 border-t hover:text-orange-500 py-2 px-4 block whitespace-no-wrap"
              @click="performLogout"
              >Logout</a
            >
          </li>
        </ul>
      </div>
    </div>
  </header>
</template>

<style scoped>
.dropdown:hover .dropdown-menu {
  display: block;
}
</style>

<script setup>
import { useAuthStore } from '~/stores/auth'; // Pastikan path ini benar
import { useRouter } from 'vue-router';

const authStore = useAuthStore();
const router = useRouter();
const config = useRuntimeConfig();
// const baseURL = config.public.BASE_URL_API; // Sudah ada di config

async function performLogout() {
  // Panggil action logout di store, yang seharusnya menghapus data user dan token
  authStore.logout();

  // Hapus token dari localStorage (atau di mana pun menyimpannya)
  localStorage.removeItem('authToken');

  // (Opsional) Panggil endpoint logout di backend jika ada
  // try {
  //   await $fetch('/api/v1/logout', { // Ganti dengan endpoint logout yang sebenarnya
  //     method: 'POST', // atau GET, sesuai implementasi backend
  //     baseURL: config.public.BASE_URL_API,
  //     headers: {
  //       // 'Authorization': `Bearer ${token_yang_mungkin_masih_ada}`, // Jika backend memerlukan token untuk logout
  //     },
  //   });
  //   console.log('Successfully logged out from backend');
  // } catch (error) {
  //   console.error('Error logging out from backend:', error);
  // }

  // Redirect ke halaman login
  router.push({ path: '/login' });
}
</script>