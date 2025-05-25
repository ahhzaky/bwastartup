<template>
  <div class="success-page">
    <NuxtPage />
  </div>
</template>

<script setup>
// Tidak ada logika JavaScript spesifik yang diperlukan untuk layout sederhana ini di Nuxt 3,
// kecuali ingin menambahkan sesuatu yang spesifik untuk semua halaman yang menggunakan layout 'success'.
// Misalnya, jika ingin menjalankan kode tertentu saat layout ini dimuat:
// import { onMounted } from 'vue';
// onMounted(() => {
//   console.log('Success layout mounted');
// });
</script>

<style lang="scss">
/* Style ini akan diterapkan secara global ke semua halaman yang menggunakan layout 'success'
  dan juga ke komponen anak (child components) jika tidak di-scope.
  Jika ingin style ini hanya berlaku untuk elemen root dari layout ini (div.success-page),
  gunakan <style lang="scss" scoped>.
*/
html {
  font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
    Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
}

/* bisa menambahkan style spesifik untuk .success-page di sini jika perlu */
/* Contoh:
.success-page {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f0f2f5;
}
*/
</style>