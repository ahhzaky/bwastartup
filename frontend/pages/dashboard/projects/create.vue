<template>
  <div class="project-page">
    <section class="dashboard-header pt-5">
      <div class="container mx-auto relative">
        <Navbar />
      </div>
    </section>
    <section class="container mx-auto pt-8">
      <div class="flex justify-between items-center mb-6">
        <div class="w-full mr-6">
          <h2 class="text-4xl text-gray-900 mb-2 font-medium">Dashboard</h2>
        </div>
      </div>
      <div class="flex justify-between items-center">
        <div class="w-3/4 mr-6">
          <h3 class="text-2xl text-gray-900 mb-4">Create New Project</h3>
        </div>
        <div class="w-1/4 text-right">
          <button
            @click="saveCampaign"
            class="bg-green-button hover:bg-green-darker text-white font-bold px-4 py-2 rounded inline-flex items-center"
            :disabled="isSaving"
          >
             <svg v-if="isSaving" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
            {{ isSaving ? 'Saving...' : 'Save Project' }}
          </button>
        </div>
      </div>
      <div class="block mb-2">
        <div class="w-full lg:max-w-full lg:flex mb-4">
          <div
            class="w-full border border-gray-400 bg-white rounded p-8 flex flex-col justify-between leading-normal"
          >
            <form class="w-full" @submit.prevent="saveCampaign">
              <div class="flex flex-wrap -mx-3 mb-6">
                <div class="w-full md:w-1/2 px-3 mb-6 md:mb-0">
                  <label
                    class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
                  >
                    Campaign Name
                  </label>
                  <input
                    class="appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
                    type="text"
                    placeholder="Contoh: Demi Gunpla Demi Istri"
                    v-model="campaign.name"
                  />
                </div>
                <div class="w-full md:w-1/2 px-3">
                  <label
                    class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
                  >
                    Goal Amount (Rp)
                  </label>
                  <input
                    class="appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
                    type="number"
                    placeholder="Contoh: 200000"
                    v-model.number="campaign.goal_amount"
                  />
                </div>
                <div class="w-full px-3">
                  <label
                    class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2 mt-3"
                  >
                    Short Description
                  </label>
                  <input
                    class="appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
                    type="text"
                    placeholder="Deskripsi singkat mengenai projectmu"
                    v-model="campaign.short_description"
                  />
                </div>
                <div class="w-full px-3">
                  <label
                    class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
                  >
                    What will backers get (comma separated)
                  </label>
                  <input
                    class="appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
                    type="text"
                    placeholder="Contoh: Ayam, Nasi Goreng, Piring"
                    v-model="campaign.perks"
                  />
                </div>
                <div class="w-full px-3">
                  <label
                    class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
                  >
                    Description
                  </label>
                  <textarea
                    class="appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
                    type="text"
                    rows="5"
                    placeholder="Isi deskripsi panjang untuk projectmu"
                    v-model="campaign.description"
                  ></textarea>
                </div>
                 <div class="w-full px-3 mt-4">
                    <button
                      type="submit"
                      class="bg-green-button hover:bg-green-darker text-white font-bold py-3 px-6 rounded"
                      :disabled="isSaving"
                    >
                       <svg v-if="isSaving" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white inline" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                      </svg>
                      {{ isSaving ? 'Saving...' : 'Save Campaign' }}
                    </button>
                  </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </section>
    <div class="cta-clip -mt-20"></div>
    <section class="call-to-action bg-purple-progress pt-64 pb-10"></section>
    <Footer />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '~/stores/auth'; // Pastikan path ini benar

// Komponen Navbar dan Footer akan di-auto-import
// import Navbar from '~/components/Navbar.vue';
// import Footer from '~/components/Footer.vue';

definePageMeta({
  middleware: 'auth', // Pastikan middleware auth sudah ada dan berfungsi
});

const router = useRouter();
const authStore = useAuthStore();
const config = useRuntimeConfig();

const campaign = ref({
  name: '',
  short_description: '',
  description: '',
  goal_amount: 0,
  perks: '', // Perks diharapkan sebagai string tunggal dipisahkan koma oleh backend
});

const isSaving = ref(false);
const errorLog = ref(null);


async function saveCampaign() {
  if (!authStore.loggedIn) {
    alert('Please login to create a campaign.');
    return router.push('/login');
  }
  const token = localStorage.getItem('authToken');
  if (!token) {
    alert('Authentication token not found.');
    return router.push('/login');
  }

  isSaving.value = true;
  errorLog.value = null;

  // Pastikan goal_amount adalah angka
  const payload = {
    ...campaign.value,
    goal_amount: Number(campaign.value.goal_amount) || 0,
  };

  try {
    const response = await $fetch('/api/v1/campaigns', {
      baseURL: config.public.BASE_URL_API,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: payload,
    });

    // response.data.id berdasarkan struktur yang diharapkan dari CreateCampaign handler
    if (response.data && response.data.id) {
        alert('Campaign created successfully!');
        router.push({
            name: 'dashboard-projects-id', // Rute ke detail campaign yang baru dibuat
            params: { id: response.data.id },
        });
    } else {
        console.error('Campaign ID not found in response:', response);
        alert('Campaign created, but could not retrieve ID. Please check your dashboard.');
        router.push('/dashboard');
    }
  } catch (err) {
    console.error('Error creating campaign:', err);
    errorLog.value = err.data?.meta?.message || err.message || 'Failed to create campaign.';
    alert(`Error: ${errorLog.value}`);
  } finally {
    isSaving.value = false;
  }
}
</script>

<style lang="scss">
/* Style dari halaman dashboard/index.vue atau halaman lain yang relevan dapat dimasukkan di sini */
.dashboard-header {
  background-image: url('/auth-background.svg');
  background-position: top right;
  background-repeat: no-repeat;
  background-color: #3b41e3;
  background-size: 250px;
  height: 100px;
}

.cta-clip {
  position: relative;
  top: 200px;
  bottom: 0;
  right: 0;
  left: 0;
  width: 100%;
  height: 300px;
  background-position: top right;
  background-size: 300px;
  background-repeat: no-repeat;
  background-color: #fff;
  transform: skewY(4deg);
  transform-origin: bottom right;
}

.call-to-action {
  background-image: url('/auth-background.svg');
  background-position: top right;
  background-repeat: no-repeat;
  background-size: 450px;
}

footer {
  z-index: inherit;
}
</style>