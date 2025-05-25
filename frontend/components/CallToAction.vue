<template>
  <section class="call-to-action bg-purple-progress pt-64 pb-10">
    <div class="container mx-auto">
      <div class="w-full text-center">
        <h1 class="text-5xl text-white font-semibold">
          Easy way to funding
          <br />
          best idea and innovation
        </h1>
        <button
          @click="goToRegister"
          class="inline-block bg-orange-button hover:bg-green-button text-white font-semibold px-6 py-4 mt-8 text-lg rounded-full"
        >
          Getting Started
        </button>
      </div>
    </div>
  </section>
</template>

<script setup>
import { useRouter } from 'vue-router';

const router = useRouter();

function goToRegister() {
  router.push({ path: '/register' });
}
</script>

<style scoped>
/* Style spesifik untuk komponen ini bisa ditambahkan di sini jika perlu,
   meskipun sebagian besar styling tampaknya menggunakan kelas Tailwind CSS.
   Style yang ada di file lain (seperti .call-to-action di index.vue)
   akan tetap berlaku jika komponen ini digunakan di sana.
*/
/* Jika ingin style default untuk komponen ini terpisah dari penggunaannya di index.vue,
.call-to-action {
  Namun, kelas bg-purple-progress, pt-64, pb-10 sudah ada di template.
  bisa mendefinisikannya di sini.
     Jika ada style spesifik untuk .call-to-action yang belum tercakup Tailwind, tambahkan di sini.
    }
    */
</style>