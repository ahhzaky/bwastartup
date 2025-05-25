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

      <div v-if="campaignPending" class="text-center py-10">
        <p>Loading campaign details...</p>
      </div>
      <div v-else-if="campaignError" class="text-center py-10 text-red-500">
        <p>Failed to load campaign: {{ campaignError.message || campaignError }}</p>
      </div>
      <div v-else-if="!campaign.value" class="text-center py-10 text-gray-500">
         <p>Campaign not found or you do not have permission to view it.</p>
      </div>

      <template v-else>
        <div class="flex justify-between items-center">
          <div class="w-3/4 mr-6">
            <h3 class="text-2xl text-gray-900 mb-4">Campaign Details</h3>
          </div>
          <div class="w-1/4 text-right">
            <NuxtLink
              :to="`/dashboard/projects/${campaignId}/edit`"
              class="bg-green-button hover:bg-green-darker text-white font-bold px-4 py-2 rounded inline-flex items-center text-sm"
            >
              Edit Campaign
            </NuxtLink>
          </div>
        </div>
        <div class="block mb-2">
          <div class="w-full lg:max-w-full lg:flex mb-4">
            <div
              class="w-full border border-gray-400 bg-white rounded p-8 flex flex-col justify-between leading-normal"
            >
              <div>
                <div class="text-gray-900 font-bold text-xl mb-2">
                  {{ campaign.value.name }}
                </div>
                <p class="text-gray-700 text-base">
                  {{ campaign.value.short_description }}
                </p>
                <p class="text-sm font-bold flex items-center mb-1 mt-4">
                  Description
                </p>
                <p class="text-gray-700 text-base" v-html="campaign.value.description"></p>
                <p class="text-sm font-bold flex items-center mb-1 mt-4">
                  What Will Funders Get
                </p>
                <ul class="list-disc ml-5">
                  <li v-for="perk in campaign.value.perks" :key="perk">
                    {{ perk }}
                  </li>
                </ul>
                <p class="text-sm font-bold flex items-center mb-1 mt-4">
                  Goal Amount
                </p>
                <p class="text-4xl text-gray-700 text-base">
                  Rp {{ new Intl.NumberFormat('id-ID').format(campaign.value.goal_amount) }}
                </p>
                 <p class="text-sm font-bold flex items-center mb-1 mt-4">
                  Current Amount
                </p>
                <p class="text-2xl text-gray-700 text-base">
                  Rp {{ new Intl.NumberFormat('id-ID').format(campaign.value.current_amount) }}
                   ({{ progressBarWidth.toFixed(0) }}%)
                </p>
              </div>
            </div>
          </div>
        </div>

        <div class="flex justify-between items-center mt-10">
          <div class="w-2/4 mr-6">
            <h3 class="text-2xl text-gray-900 mb-4 mt-5">Gallery</h3>
          </div>
          <div class="w-2/4 text-right">
            <input
              type="file"
              ref="fileInputRef"
              @change="selectFile"
              class="border p-1 rounded overflow-hidden w-auto text-sm"
              accept="image/*"
            />
            <button
              @click="uploadImage"
              :disabled="!selectedFile || isUploading"
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold px-4 py-2 rounded inline-flex items-center text-sm ml-2"
              :class="{ 'opacity-50 cursor-not-allowed': !selectedFile || isUploading }"
            >
              <svg v-if="isUploading" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ isUploading ? 'Uploading...' : 'Upload' }}
            </button>
          </div>
        </div>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-3 -mx-2">
          <div
            class="relative w-full bg-white m-2 p-2 border border-gray-400 rounded"
            v-for="image in campaign.value.images"
            :key="image.image_url"
          >
            <figure class="item-thumbnail">
              <img
                :src="`${config.public.BASE_URL_API}/${image.image_url}`"
                alt="Campaign image"
                class="rounded w-full h-40 object-cover"
              />
            </figure>
          </div>
           <div v-if="campaign.value.images && campaign.value.images.length === 0" class="col-span-full text-center text-gray-500 py-4">
            No images uploaded yet for this campaign.
          </div>
        </div>

        <div class="flex justify-between items-center mt-10">
          <div class="w-3/4 mr-6">
            <h3 class="text-2xl text-gray-900 mb-4 mt-5">Transaction History</h3>
          </div>
        </div>
        <div class="block mb-2">
           <div v-if="transactionsPending" class="text-center py-10">
            <p>Loading transactions...</p>
          </div>
          <div v-else-if="transactionsError" class="text-center py-10 text-red-500">
            <p>Failed to load transactions: {{ transactionsError.message || transactionsError }}</p>
          </div>
           <div v-else-if="transactions.value && transactions.value.length === 0" class="text-center py-10 text-gray-500">
            No transactions found for this campaign.
          </div>
          <div
            v-else
            class="w-full lg:max-w-full lg:flex mb-4"
            v-for="transaction_item in transactions.value"
            :key="transaction_item.id"
          >
            <div
              class="w-full border border-gray-400 lg:border-gray-400 bg-white rounded p-8 flex flex-col justify-between leading-normal"
            >
              <div>
                <div class="text-gray-900 font-bold text-xl mb-1">
                  {{ transaction_item.name }} </div>
                <p class="text-sm text-gray-600 flex items-center mb-2">
                  Rp.
                  {{ new Intl.NumberFormat('id-ID').format(transaction_item.amount) }}
                  &middot; {{ formatDate(transaction_item.created_at) }}
                </p>
                 </div>
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
import { ref, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { useAuthStore } from '~/stores/auth';

// Komponen akan di-auto-import
// import Navbar from '~/components/Navbar.vue';
// import Footer from '~/components/Footer.vue';

definePageMeta({
  middleware: 'auth',
});

const route = useRoute();
const authStore = useAuthStore();
const config = useRuntimeConfig();

const campaignId = computed(() => route.params.id);

const selectedFile = ref(null);
const fileInputRef = ref(null); // Ref untuk input file
const isUploading = ref(false);

// Fetch Campaign Details
const { data: campaign, error: campaignError, pending: campaignPending, refresh: refreshCampaign } = await useAsyncData(
  `campaign-${campaignId.value}`, // Kunci unik per campaign
  async () => {
    const token = localStorage.getItem('authToken');
    if (!token) {
      console.warn('No token for campaign details');
      // Middleware auth seharusnya sudah menangani ini, tapi bisa juga redirect di sini
      // return navigateTo('/login'); 
      return null; 
    }
    try {
      const response = await $fetch(`/api/v1/campaigns/${campaignId.value}`, {
        baseURL: config.public.BASE_URL_API,
        headers: { 'Authorization': `Bearer ${token}` },
        transform: (res) => res.data // Sesuai CampaignDetailFormatter
      });
      return response;
    } catch (e) {
      console.error("Error in useAsyncData (campaign):", e);
      return null; // Kembalikan null jika error agar tidak crash
    }
  },
  {
    watch: [campaignId], // Re-fetch jika campaignId berubah (walaupun di halaman ini ID tidak akan berubah)
    default: () => null
  }
);

// Fetch Campaign Transactions
const { data: transactions, error: transactionsError, pending: transactionsPending, refresh: refreshTransactions } = await useAsyncData(
  `campaign-transactions-${campaignId.value}`,
  async () => {
    const token = localStorage.getItem('authToken');
     if (!token) {
      console.warn('No token for transactions');
      return [];
    }
    try {
        const response = await $fetch(`/api/v1/campaigns/${campaignId.value}/transactions`, {
          baseURL: config.public.BASE_URL_API,
          headers: { 'Authorization': `Bearer ${token}` },
          // Backend mengembalikan array langsung untuk CampaignTransactionFormatter
          // Jika ada property 'data', gunakan transform: (res) => res.data || []
          transform: (res) => res.data || [] // Berdasarkan CampaignTransactionFormatter di backend
        });
        return response;
    } catch (e) {
      console.error("Error in useAsyncData (transactions):", e);
      return [];
    }
  },
  {
    watch: [campaignId],
    default: () => []
  }
);


function selectFile(event) {
  if (event.target.files && event.target.files[0]) {
    selectedFile.value = event.target.files[0];
  } else {
    selectedFile.value = null;
  }
}

async function uploadImage() {
  if (!selectedFile.value || !authStore.loggedIn) {
    alert('Please select a file and ensure you are logged in.');
    return;
  }
  const token = localStorage.getItem('authToken');
   if (!token) {
    alert('Authentication token not found.');
    return;
  }

  const formData = new FormData();
  formData.append('campaign_id', campaignId.value);
  formData.append('file', selectedFile.value);
  formData.append('is_primary', true); // Atau buat ini bisa dipilih oleh user

  isUploading.value = true;
  try {
    await $fetch('/api/v1/campaign-images', {
      baseURL: config.public.BASE_URL_API,
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        // Content-Type akan di-set otomatis oleh browser untuk FormData
      },
      body: formData,
    });
    alert('Image uploaded successfully!');
    selectedFile.value = null; // Reset file input
    if (fileInputRef.value) { // Reset tampilan input file
      fileInputRef.value.value = '';
    }
    await refreshCampaign(); // Panggil refresh dari useAsyncData untuk campaign
    await refreshTransactions(); // Mungkin tidak perlu, tapi bisa jadi ada update data terkait
  } catch (err) {
    console.error('Error uploading image:', err);
    alert(`Error uploading image: ${err.data?.meta?.message || err.message}`);
  } finally {
    isUploading.value = false;
  }
}

const progressBarWidth = computed(() => {
  if (campaign.value && campaign.value.goal_amount > 0) {
    const percentage = (campaign.value.current_amount / campaign.value.goal_amount) * 100;
    return Math.min(percentage, 100);
  }
  return 0;
});

function formatDate(dateString) {
  if (!dateString) return '';
  const options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' };
  return new Date(dateString).toLocaleDateString('id-ID', options);
}

</script>

<style lang="scss">
/* Styles dari halaman sebelumnya bisa dimasukkan di sini */
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
/* Tambahkan style lain jika diperlukan */
</style>