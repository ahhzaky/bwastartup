<template>
  <div class="project-page">
    <section class="dashboard-header pt-5">
      <div class="container mx-auto relative">
        <Navbar />
      </div>
    </section>
    <section class="container mx-auto pt-8">
      <div class="flex justify-between items-center mb-6">
        <div class="w-3/4 mr-6">
          <h2 class="text-4xl text-gray-900 mb-2 font-medium">Dashboard</h2>
          <ul class="flex mt-2">
            <li class="mr-6">
              <NuxtLink
                class="text-gray-500 hover:text-gray-800"
                to="/dashboard"
              >
                Your Projects
              </NuxtLink>
            </li>
            <li class="mr-6">
              <NuxtLink
                class="text-gray-800 font-bold"
                to="/dashboard/transactions"
              >
                Your Transactions
              </NuxtLink>
            </li>
          </ul>
        </div>
        <div class="w-1/4 text-right">
          <NuxtLink
            to="/dashboard/projects/create"
            class="bg-orange-button hover:bg-green-button text-white font-bold py-4 px-4 rounded inline-flex items-center"
          >
            + Create Campaign
          </NuxtLink>
        </div>
      </div>
      <hr />
      <div class="block mb-2">
        <div v-if="pending" class="text-center py-10">
          <p>Loading your transactions...</p>
        </div>
        <div v-else-if="fetchError" class="text-center py-10 text-red-500">
          <p>Failed to load transactions: {{ fetchError.message || fetchError }}</p>
        </div>
        <div v-else-if="transactions && transactions.length === 0" class="text-center py-10 text-gray-500">
          <p>You have no transactions yet.</p>
        </div>
        <div
          v-else
          class="w-full lg:max-w-full lg:flex mb-4"
          v-for="transaction in transactions"
          :key="transaction.id"
        >
          <div
            class="border h-48 lg:h-auto lg:w-64 flex-none bg-cover rounded-t lg:rounded-t-none lg:rounded-l text-center overflow-hidden"
            :style="{
              backgroundColor: '#bbb',
              backgroundPosition: 'center',
              backgroundImage: `url('${config.public.BASE_URL_API}/${transaction.campaign.image_url}')`
            }"
          ></div>
          <div
            class="w-full border-r border-b border-l border-gray-400 lg:border-l-0 lg:border-t lg:border-gray-400 bg-white rounded-b lg:rounded-b-none lg:rounded-r p-8 flex flex-col justify-between leading-normal"
          >
            <div>
              <div class="text-gray-900 font-bold text-xl mb-1">
                {{ transaction.campaign.name }}
              </div>
              <p class="text-sm text-gray-600 flex items-center mb-2">
                Rp.
                {{ new Intl.NumberFormat('id-ID').format(transaction.amount) }}
                &middot; {{ formatDate(transaction.created_at) }} &middot;
                <span :class="statusClass(transaction.status)">{{ transaction.status }}</span>
              </p>
            </div>
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
import { ref, onMounted } from 'vue';
import { useAuthStore } from '~/stores/auth';
import { useRouter } from 'vue-router'; // Jika diperlukan untuk navigasi programatik

// Komponen Navbar dan Footer akan di-auto-import
// import Navbar from '~/components/Navbar.vue';
// import Footer from '~/components/Footer.vue';

definePageMeta({
  middleware: 'auth', // Pastikan middleware auth sudah ada dan berfungsi
});

const authStore = useAuthStore();
const router = useRouter(); // Jika  butuh router instance
const config = useRuntimeConfig();

const transactions = ref([]);
const fetchError = ref(null);
const pending = ref(true);

async function fetchUserTransactions() {
  if (!authStore.loggedIn || !authStore.user?.id) {
    console.warn('User not logged in or user ID missing for fetching transactions.');
    pending.value = false;
    // Middleware 'auth' seharusnya sudah menghandle redirect jika tidak login
    return;
  }

  const token = localStorage.getItem('authToken');
  if (!token) {
    console.warn('Auth token not found for fetching transactions.');
    pending.value = false;
    // Middleware 'auth' seharusnya sudah menghandle redirect
    return;
  }
  
  pending.value = true;
  fetchError.value = null;

  try {
    // Berdasarkan handler/transaction.go, endpointnya adalah /api/v1/transactions
    // dan sudah difilter berdasarkan currentUser (dari token) di backend
    const response = await $fetch('/api/v1/transactions', {
      baseURL: config.public.BASE_URL_API,
      headers: {
        'Authorization': `Bearer ${token}`,
      },
      transform: (res) => res.data || [] // Sesuai UserTransactionFormatter
    });
    transactions.value = response;
  } catch (e) {
    console.error('Error fetching user transactions:', e);
    fetchError.value = e.data?.meta?.message || e.message || 'Failed to load transactions.';
    transactions.value = [];
  } finally {
    pending.value = false;
  }
}

// Panggil fetchUserTransactions saat komponen dimuat
onMounted(() => {
  fetchUserTransactions();
});

// Helper function untuk format tanggal (opsional, bisa dipindah ke utils)
function formatDate(dateString) {
  if (!dateString) return '';
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('id-ID', options);
}

// Helper function untuk styling status (opsional)
function statusClass(status) {
  if (status === 'pending') return 'text-yellow-600 font-semibold';
  if (status === 'paid') return 'text-green-600 font-semibold';
  if (status === 'cancelled' || status === 'failed') return 'text-red-600 font-semibold';
  return 'text-gray-600';
}

</script>

<style lang="scss">
/* Style yang sudah ada sebelumnya dari halaman dashboard/index.vue */
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

/*  mungkin ingin menghapus style .card-project jika tidak relevan di halaman ini */
/* atau sesuaikan jika tampilannya berbeda */
/* .card-project { ... } */

footer {
  z-index: inherit;
}

.hero-underline {
  text-decoration-color: #1abc9c;
}

.testimonial-user {
  opacity: 0.4;
  &.active {
    opacity: 1;
    border: 5px solid #fff;
    box-shadow: 0 0 0 1px #3b41e3;
  }
}

.list-check {
  li {
    background: url('/icon-checklist.svg') no-repeat left 8px;
    padding: 6px 0px 3px 28px;
  }
}

.item-thumbnail:hover {
  background-color: #ff872e;
  border-radius: 20px;
  &:after {
    position: absolute;
    top: 38%;
    left: 41%;
    content: url('/icon-thumbnail-hover.svg');
  }
  img {
    opacity: 0.3;
  }
}
</style>