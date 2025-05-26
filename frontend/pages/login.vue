<template>
  <div class="h-screen flex justify-center items-center">
    <div
      class="hidden md:block lg:w-1/3 bg-white h-full auth-background rounded-tr-lg rounded-br-lg"
    ></div>
    <div class="w-auto md:w-2/4 lg:w-2/3 flex justify-center items-center">
      <div class="w-full lg:w-1/2 px-10 lg:px-0">
        <h2 class="font-normal mb-6 text-3xl text-white">
          Sign In to Your Account
        </h2>
        <div class="mb-6">
          <div class="mb-4">
            <label class="font-normal text-lg text-white block mb-3"
              >Email Address</label
            >
            <input
              type="email"
              v-model="loginData.email"
              class="auth-form focus:outline-none focus:bg-purple-hover focus:shadow-outline focus:border-purple-hover-stroke focus:text-gray-100"
              placeholder="Write your email address here"
            />
          </div>
        </div>
        <div class="mb-6">
          <div class="mb-4">
            <label class="font-normal text-lg text-white block mb-3"
              >Password</label
            >
            <input
              @keyup.enter="userLogin"
              type="password"
              v-model="loginData.password"
              class="auth-form focus:outline-none focus:bg-purple-hover focus:shadow-outline focus:border-purple-hover-stroke focus:text-gray-100"
              placeholder="Write your password here"
            />
          </div>
        </div>
        <div class="mb-6">
          <div class="mb-4">
            <button
              @click="userLogin"
              class="block w-full bg-orange-button hover:bg-green-button text-white font-semibold px-6 py-4 text-lg rounded-full"
            >
              Sign In
            </button>
          </div>
        </div>
        <div class="text-center">
          <p class="text-white text-md">
            Don't have account?
            <NuxtLink to="/register" class="no-underline text-orange-button"
              >Sign Up</NuxtLink
            >.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useAuthStore } from '~/stores/auth'; 
import { useRouter } from 'vue-router';

// Mendefinisikan layout
definePageMeta({
  layout: 'auth',
});

const authStore = useAuthStore();
const router = useRouter();
const config = useRuntimeConfig(); 

const loginData = ref({
  email: 'moder-test@jck.com',
  password: 'password',
});

async function userLogin() {
  try {
    const response = await fetch(`${config.public.BASE_URL_API}/api/v1/sessions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(loginData.value),
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.meta?.message || 'Login failed');
    }

    const responseData = await response.json();
    
    authStore.login({ 
        name: responseData.data.name, 
        // image_url: responseData.data.image_url 
    }); 
    
    if (responseData.data.token) {
        localStorage.setItem('authToken', responseData.data.token);
    }

    router.push('/'); 

    console.log(responseData);
  } catch (err) {
    console.error(err.message || err);
  }
}


</script>

<style lang="scss" scoped>
.auth-background {
  background-image: url('/sign-in-background.jpg');
  background-position: center;
  background-size: cover;
}
</style>