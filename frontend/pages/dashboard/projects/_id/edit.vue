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
      <div v-if="pending" class="text-center py-10">
        <p>Loading campaign data...</p>
      </div>
      <div v-else-if="fetchError" class="text-center py-10 text-red-500">
        <p>Failed to load campaign: {{ fetchError.message || fetchError }}</p>
      </div>
      <div v-else-if="!campaignFormData" class="text-center py-10 text-gray-500">
        <p>Campaign not found.</p>
      </div>
      <template v-else>
        <div class="flex justify-between items-center">
          <div class="w-3/4 mr-6">
            <h3 class="text-2xl text-gray-900 mb-4">
              Edit Campaign "{{ campaignInitialName }}"
            </h3>
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
              {{ isSaving ? 'Saving...' : 'Save' }}
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
                      v-model="campaignFormData.name"
                    />
                  </div>
                  <div class="w-full md:w-1/2 px-3">
                    <label
                      class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
                    >
                      Goal Amount
                    </label>
                    <input
                      class="appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"
                      type="number"
                      placeholder="Contoh: 200000"
                      v-model.number="campaignFormData.goal_amount"
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
                      v-model="campaignFormData.short_description"
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
                      v-model="perksString"
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
                      rows="5"
                      placeholder="Isi deskripsi panjang untuk projectmu"
                      v-model="campaignFormData.description"
                    ></textarea>
                  </div>
                </div>
                 </form>
            </div>
          </div>
        </div>
      </template>
    </section>
    <div class="cta-clip -mt-20"></div>
    <section class="call-to-action bg-purple-progress pt-64 pb-10"></section>
    <Footer />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAuthStore } from '~/stores/auth'; // Pastikan path ini benar

// Komponen Navbar dan Footer akan di-auto-import
// import Navbar from '~/components/Navbar.vue';
// import Footer from '~/components/Footer.vue';

definePageMeta({
  middleware: 'auth', // Pastikan middleware auth sudah ada dan berfungsi
  // layout: 'dashboard', // Jika ada layout khusus dashboard
});

const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();
const config = useRuntimeConfig();

const campaignId = computed(() => route.params.id);
const campaignFormData = ref(null); // Untuk data form yang bisa diedit
const campaignInitialName = ref(''); // Untuk menampilkan nama awal di judul
const fetchError = ref(null);
const pending = ref(true);
const isSaving = ref(false);

// Computed property untuk mengubah array perks menjadi string dan sebaliknya
const perksString = computed({
  get() {
    return campaignFormData.value?.perks?.join(', ') || '';
  },
  set(value) {
    if (campaignFormData.value) {
      campaignFormData.value.perks = value.split(',').map(perk => perk.trim()).filter(perk => perk);
    }
  }
});


async function fetchCampaignDetails() {
  if (!authStore.loggedIn) {
    pending.value = false;
    return router.push('/login');
  }
  const token = localStorage.getItem('authToken');
  if (!token) {
    pending.value = false;
    return router.push('/login');
  }

  pending.value = true;
  fetchError.value = null;
  try {
    const response = await $fetch(`/api/v1/campaigns/${campaignId.value}`, {
      baseURL: config.public.BASE_URL_API,
      headers: {
        'Authorization': `Bearer ${token}`,
      },
      //  Diasumsikan API mengembalikan objek campaign langsung di bawah 'data'
      //  Sesuai CampaignDetailFormatter di backend
      transform: (res) => res.data 
    });
    
    // Salin data ke ref yang akan diikat ke form
    // Ini penting agar data asli tidak termutasi langsung jika menggunakan data dari useAsyncData
    campaignFormData.value = { ...response };
    campaignInitialName.value = response.name; // Simpan nama awal

    // Backend  tampaknya mengembalikan perks sebagai array string
    // Jika tidak,  perlu menyesuaikan ini.
    // perksString.value = response.perks.join(', '); // Di-handle oleh computed property

  } catch (e) {
    console.error('Error fetching campaign details:', e);
    fetchError.value = e.data?.meta?.message || e.message || 'Failed to load campaign details.';
    campaignFormData.value = null;
  } finally {
    pending.value = false;
  }
}

async function saveCampaign() {
  if (!campaignFormData.value || !authStore.loggedIn) {
    alert('Cannot save campaign. Please check data or login status.');
    return;
  }
  const token = localStorage.getItem('authToken');
  if (!token) {
    alert('Authentication required.');
    return router.push('/login');
  }

  isSaving.value = true;
  fetchError.value = null;

  // Backend  (campaign.CreateCampaignInput) mengharapkan perks sebagai string tunggal,
  // jadi pastikan `perksString.value` digunakan jika perks di `campaignFormData.value.perks` adalah array.
  // Namun, dari input.go (CreateCampaignInput), perks adalah string.
  // FormUpdateCampaignInput di backend juga mengindikasikan perks adalah string tunggal.
  // Jika perks di form adalah array, kita perlu `join` lagi sebelum mengirim.
  
  const payload = {
    name: campaignFormData.value.name,
    short_description: campaignFormData.value.short_description,
    description: campaignFormData.value.description,
    goal_amount: Number(campaignFormData.value.goal_amount), // Pastikan ini angka
    // Jika campaignFormData.value.perks adalah array dari input, maka:
    perks: Array.isArray(campaignFormData.value.perks) ? campaignFormData.value.perks.join(',') : campaignFormData.value.perks,
  };

  try {
    await $fetch(`/api/v1/campaigns/${campaignId.value}`, {
      baseURL: config.public.BASE_URL_API,
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: payload,
    });
    alert('Campaign updated successfully!');
    router.push(`/dashboard/projects/${campaignId.value}`); // atau ke halaman daftar campaign
  } catch (e) {
    console.error('Error updating campaign:', e);
    fetchError.value = e.data?.meta?.message || e.message || 'Failed to update campaign.';
    alert(`Error: ${fetchError.value}`);
  } finally {
    isSaving.value = false;
  }
}

// Panggil fetchCampaignDetails saat komponen dimuat
onMounted(() => {
  fetchCampaignDetails();
});
</script>

<style lang="scss">
/* Style yang sudah ada sebelumnya dari halaman dashboard/index.vue dan projects/_id.vue */
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