<template>
  <div class="container mx-auto h-screen flex justify-center items-center">
    <div class="w-full lg:w-1/3 px-10 lg:px-0">
      <div class="flex justify-center items-center mx-auto mb-4 w-40">
        <div class="relative">
          <div class="cursor-pointer" @click="triggerFileInput">
            <img
              :src="previewUrl || '/avatar.jpg'"
              alt="Avatar Preview"
              class="rounded-full border-white border-4 w-40 h-40 object-cover"
            />
            <img
              src="/icon-avatar-add.svg"
              alt="Add Avatar"
              class="absolute right-0 bottom-0 pb-2"
            />
          </div>
          <input
            type="file"
            ref="fileInput"
            style="display: none"
            accept="image/*"
            @change="onFileChange"
          />
        </div>
      </div>
      <h2 class="font-normal mb-3 text-3xl text-white text-center">
        Hi, {{ authStore.user?.name || 'User' }}
      </h2>
      <p class="text-white text-center font-light">Please upload your selfie</p>
      <div class="mb-4 mt-6">
        <div class="mb-3">
          <button
            :disabled="!selectedFile"
            @click="uploadAvatar"
            :class="
              !selectedFile ? 'opacity-50 cursor-not-allowed' : ''
            "
            class="block w-full bg-orange-button hover:bg-green-button text-white font-semibold px-6 py-4 text-lg rounded-full"
          >
            Sign Up Now
          </button>
        </div>
      </div>
      <div>
        <div class="mb-4">
          <button
            @click="skipUpload"
            class="block w-full bg-transparent border-white border hover:bg-white hover:bg-opacity-25 text-white font-light px-6 py-4 text-lg rounded-full"
          >
            Skip
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useAuthStore } from '~/stores/auth'; 
import { useRouter } from 'vue-router';

definePageMeta({
  layout: 'auth', 
  middleware: 'auth' 
});

const authStore = useAuthStore();
const router = useRouter();
const config = useRuntimeConfig();

const previewUrl = ref(authStore.user?.image_url || '/avatar.jpg'); 
const selectedFile = ref(null);
const fileInput = ref(null);

function triggerFileInput() {
  fileInput.value?.click();
}

function onFileChange(event) {
  const target = event.target;
  if (target.files && target.files[0]) {
    const file = target.files[0];
    previewUrl.value = URL.createObjectURL(file);
    selectedFile.value = file;
  }
}

async function uploadAvatar() {
  if (!selectedFile.value) {
    console.error('No file selected');
    return;
  }

  const formData = new FormData();
  formData.append('avatar', selectedFile.value);

  try {
    const token = localStorage.getItem('authToken');
    if (!token) {
        console.error('Authentication token not found. Please login.');
        router.push('/login');
        return;
    }

    const response = await fetch(`${config.public.BASE_URL_API}/api/v1/avatars`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
      },
      body: formData,
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.meta?.message || 'Avatar upload failed');
    }

    const responseData = await response.json();
    console.log(responseData);

    // example of updating user avatar in store
    // if (responseData.data && responseData.data.avatar_file_name) {
    //   authStore.updateUserAvatar(responseData.data.avatar_file_name);
    // }

    router.push('/register/success');
  } catch (err) {
    console.error(err.message || err);
  }
}

function skipUpload() {
  router.push('/register/success');
}
</script>

<style lang="scss" scoped>
.auth-background {
  background-image: url('/sign-in-background.jpg');
  background-position: center;
  background-size: cover;
}
</style>