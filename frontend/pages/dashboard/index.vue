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
              <NuxtLink class="text-gray-800 font-bold" to="/dashboard"> Your Projects </NuxtLink>
            </li>
            <li class="mr-6">
              <NuxtLink
                class="text-gray-500 hover:text-gray-800"
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
          <p>Loading your projects...</p>
          </div>
        <div v-else-if="fetchError" class="text-center py-10 text-red-500">
          <p>Failed to load your projects: {{ fetchError.message || fetchError }}</p>
        </div>
        <div v-else-if="campaigns && campaigns.length === 0" class="text-center py-10 text-gray-500">
          <p>You haven't created any projects yet. <NuxtLink to="/dashboard/projects/create" class="text-orange-button hover:underline">Create one now!</NuxtLink></p>
        </div>
        <div
          v-else
          class="w-full lg:max-w-full lg:flex mb-4"
          v-for="campaign in campaigns"
          :key="campaign.id"
        >
          <div
            class="border h-48 lg:h-auto lg:w-64 flex-none bg-cover rounded-t lg:rounded-t-none lg:rounded-l text-center overflow-hidden"
            :style="{
              backgroundColor: '#bbb',
              backgroundPosition: 'center',
              backgroundImage: `url('${config.public.BASE_URL_API}/${campaign.image_url}')`
            }"
          ></div>
          <NuxtLink
            :to="`/dashboard/projects/${campaign.id}`" 
            class="w-full border-r border-b border-l border-gray-400 lg:border-l-0 lg:border-t lg:border-gray-400 bg-white rounded-b lg:rounded-b-none lg:rounded-r p-8 flex flex-col justify-between leading-normal"
          >
            <div class="mb-8">
              <div class="text-gray-900 font-bold text-xl mb-1">
                {{ campaign.name }}
              </div>
              <p class="text-sm text-gray-600 flex items-center mb-2">
                Rp.
                {{ new Intl.NumberFormat().format(campaign.goal_amount) }}
                &middot;
                {{ progressBarWidth(campaign).toFixed(0) }}%
              </p>
              <p class="text-gray-700 text-base">
                {{ campaign.short_description }}
              </p>
            </div>
            <div class="flex items-center">
              <NuxtLink :to="`/dashboard/projects/${campaign.id}`" class="bg-green-button text-white py-2 px-4 rounded">
                Detail
              </NuxtLink>
            </div>
          </NuxtLink>
        </div>
      </div>
    </section>
    <div class="cta-clip -mt-20"></div>
    <section class="call-to-action bg-purple-progress pt-64 pb-10"></section>
    <Footer />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useAuthStore } from '~/stores/auth'; 
import { useRouter } from 'vue-router';

// import Navbar from '~/components/Navbar.vue';
// import Footer from '~/components/Footer.vue';

definePageMeta({
  middleware: 'auth',
  // layout: 'dashboard', 
});

const authStore = useAuthStore();
const router = useRouter();
const config = useRuntimeConfig();

const campaigns = ref([]);
const fetchError = ref(null);
const pending = ref(true); 

async function fetchUserCampaigns() {
  if (!authStore.user || !authStore.user.id) {
    console.error('User not logged in or user ID not available');
    // router.push('/login'); 
    pending.value = false;
    return;
  }

  const token = localStorage.getItem('authToken');
  if (!token) {
    console.error('Auth token not found');
    // router.push('/login');
    pending.value = false;
    return;
  }
  
  pending.value = true;
  fetchError.value = null;

  try {
    const response = await $fetch(`/api/v1/campaigns?user_id=${authStore.user.id}`, {
      baseURL: config.public.BASE_URL_API,
      headers: {
        'Authorization': `Bearer ${token}`,
      },
      transform: (res) => res.data || []
    });
    campaigns.value = response;
  } catch (e) {
    console.error('Error fetching user campaigns:', e);
    fetchError.value = e.data?.meta?.message || e.message || 'Failed to load projects.';
    campaigns.value = [];
  } finally {
    pending.value = false;
  }
}

// Middleware authStore.loggedIn must be true to access this page.
onMounted(() => {
  if (authStore.loggedIn) {
    fetchUserCampaigns();
  } else {
    console.log('User not logged in, redirecting from dashboard index.');
    // router.push('/login'); 
    pending.value = false;
  }
});

const progressBarWidth = (campaign) => {
  if (campaign && campaign.goal_amount > 0) {
    const percentage = (campaign.current_amount / campaign.goal_amount) * 100;
    return Math.min(percentage, 100);
  }
  return 0;
};


</script>

<style lang="scss">
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
  background-image: url('/auth-background.svg'); /* Pastikan path ini benar */
  background-position: top right;
  background-repeat: no-repeat;
  background-size: 450px;
}

/* Style lain yang sudah ada sebelumnya */
.card-project {
  transition: all 0.3s ease 0s, opacity 0.5s cubic-bezier(0.5, 0, 0, 1) 1ms;
  /* max-height: 485px; */ /* Mungkin perlu disesuaikan atau dihapus jika memotong konten */
  overflow: hidden;

  .button-cta {
    opacity: 0;
    transition: all 300ms ease;
  }

  &:hover {
    box-shadow: 0 4px 25px 0 rgba(0, 0, 0, 0.15);

    .button-cta {
      opacity: 1;
      transition: all 300ms ease;
    }

    .progress-bar,
    .progress-info {
      opacity: 0;
      height: 0px;
      margin: 0px;
      padding: 0px;
      transition: all 300ms ease;
    }
  }
}

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
    background: url('/icon-checklist.svg') no-repeat left 8px; /* Pastikan path ini benar */
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
    content: url('/icon-thumbnail-hover.svg'); /* Pastikan path ini benar */
  }
  img {
    opacity: 0.3;
  }
}
</style>