<template>
  <div class="h-screen flex justify-center items-center">
    <div
      class="hidden md:block lg:w-1/3 bg-white h-full auth-background rounded-tr-lg rounded-br-lg"
    ></div>
    <div class="w-auto md:w-2/4 lg:w-2/3 flex justify-center items-center">
      <div class="w-full lg:w-1/2 px-10 lg:px-0">
        <h2 class="font-normal mb-6 text-3xl text-white">Sign Up Account</h2>
        <div class="mb-6">
          <div class="mb-4">
            <label class="font-normal text-lg text-white block mb-3"
              >Full Name</label
            >
            <input
              type="text"
              class="auth-form focus:outline-none focus:bg-purple-hover focus:shadow-outline focus:border-purple-hover-stroke focus:text-gray-100"
              placeholder="Write Your Name Here"
              v-model="registerData.name"
            />
          </div>
        </div>
        <div class="mb-6">
          <div class="mb-4">
            <label class="font-normal text-lg text-white block mb-3"
              >Occupation</label
            >
            <input
              type="text"
              class="auth-form focus:outline-none focus:bg-purple-hover focus:shadow-outline focus:border-purple-hover-stroke focus:text-gray-100"
              placeholder="Write your occupation here"
              v-model="registerData.occupation"
            />
          </div>
        </div>
        <div class="mb-6">
          <div class="mb-4">
            <label class="font-normal text-lg text-white block mb-3"
              >Email Address</label
            >
            <input
              type="email"
              class="auth-form focus:outline-none focus:bg-purple-hover focus:shadow-outline focus:border-purple-hover-stroke focus:text-gray-100"
              placeholder="Write your email address here"
              v-model="registerData.email"
            />
          </div>
        </div>
        <div class="mb-6">
          <div class="mb-4">
            <label class="font-normal text-lg text-white block mb-3"
              >Password</label
            >
            <input
              type="password"
              class="auth-form focus:outline-none focus:bg-purple-hover focus:shadow-outline focus:border-purple-hover-stroke focus:text-gray-100"
              placeholder="Type your password here"
              v-model="registerData.password"
              @keyup.enter="userRegister"
            />
          </div>
        </div>
        <div class="mb-6">
          <div class="mb-4">
            <button
              @click="userRegister"
              class="block w-full bg-orange-button hover:bg-green-button text-white font-semibold px-6 py-4 text-lg rounded-full"
            >
              Continue Sign Up
            </button>
          </div>
        </div>
        <div class="text-center">
          <p class="text-white text-md">
            Already have account?
            <NuxtLink to="/login" class="no-underline text-orange-button"
              >Sign In</NuxtLink
            >.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '~/stores/auth'; // Asumsi path store

// Mendefinisikan layout
definePageMeta({
  layout: 'auth', // Pastikan memiliki layout bernama 'auth' di direktori layouts
});

const router = useRouter();
const authStore = useAuthStore(); // Jika ingin menyimpan state setelah registrasi
const config = useRuntimeConfig();

const registerData = ref({
  name: 'Input user', // Default value, bisa dikosongkan
  email: 'test@test.com', // Default value, bisa dikosongkan
  occupation: 'Product Designer', // Default value, bisa dikosongkan
  password: 'password', // Default value, sebaiknya dikosongkan
});

async function userRegister() {
  try {
    const response = await fetch(`${config.public.BASE_URL_API}/api/v1/users`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(registerData.value),
    });

    if (!response.ok) {
      const errorData = await response.json();
      // bisa menampilkan pesan error spesifik dari API
      throw new Error(errorData.meta?.message || 'Registration failed');
    }

    const responseData = await response.json();
    console.log(responseData);

    // Jika API mengembalikan token atau data user setelah registrasi,
    // bisa menyimpannya di Pinia store atau localStorage di sini.
    // Contoh:
    // if (responseData.data.token) {
    //   localStorage.setItem('authToken', responseData.data.token);
    //   authStore.login(responseData.data.user); // Asumsi API mengembalikan data user
    // }

    // Redirect ke halaman sukses atau login
    // Mengganti `this.$router.push({ path: '/upload' })`
    // Umumnya setelah registrasi, pengguna diarahkan ke halaman login atau halaman sukses
    router.push('/register-success'); // Atau '/login', atau '/upload' jika itu alur yang diinginkan

  } catch (err) {
    console.error(err.message || err);
    // Handle error (tampilkan notifikasi ke pengguna, dll.)
  }
}
</script>

<style lang="scss" scoped>
.auth-background {
  background-image: url('/sign-up-background.jpg'); /* Pastikan path gambar benar dan ada di direktori public */
  background-position: center;
  background-size: cover;
}
</style>