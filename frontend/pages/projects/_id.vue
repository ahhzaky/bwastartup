<template>
  <div class="project-page" v-if="campaignData">
    <section class="project-header pt-5">
      <div class="container mx-auto relative">
        <Navbar />
      </div>
    </section>
    <section class="container project-container mx-auto -mt-56">
      <div class="flex mt-3">
        <div class="w-3/4 mr-6">
          <div class="bg-white p-3 mb-3 border border-gray-400 rounded-20">
            <figure class="item-image">
              <img
                :src="defaultImage"
                alt="Project default image"
                class="rounded-20 w-full object-cover h-96"
              />
            </figure>
          </div>
          <div class="flex -mx-2">
            <div
              v-for="image in campaignData.images"
              :key="image.image_url"
              class="relative w-1/4 bg-white m-2 p-2 border border-gray-400 rounded-20"
            >
              <figure class="item-thumbnail cursor-pointer">
                <img
                  :src="`${config.public.BASE_URL_API}/${image.image_url}`"
                  @click="
                    changeImage(`${config.public.BASE_URL_API}/${image.image_url}`)
                  "
                  alt="Project thumbnail"
                  class="rounded-20 w-full h-32 object-cover"
                />
              </figure>
            </div>
          </div>
        </div>
        <div class="w-1/4">
          <div
            class="bg-white w-full p-5 border border-gray-400 rounded-20 sticky"
            style="top: 15px;"
          >
            <h3>Project Leader:</h3>

            <div class="flex mt-3">
              <div class="w-1/4">
                <img
                  :src="`${config.public.BASE_URL_API}/${campaignData.user.image_url}`"
                  alt="User avatar"
                  class="w-full inline-block rounded-full"
                />
              </div>
              <div class="w-3/4 ml-5 mt-1">
                <div class="font-semibold text-xl text-gray-800">
                  {{ campaignData.user.name }}
                </div>
                <div class="font-light text-md text-gray-400">
                  {{ campaignData.backer_count }} backer
                </div>
              </div>
            </div>

            <h4 class="mt-5 font-semibold">What you will get:</h4>
            <ul class="list-check mt-3">
              <li v-for="perk in campaignData.perks" :key="perk">
                {{ perk }}
              </li>
            </ul>
            <template v-if="authStore.loggedIn">
              <input
                type="number"
                class="border border-gray-500 block w-full px-6 py-3 mt-4 rounded-full text-gray-800 transition duration-300 ease-in-out focus:outline-none focus:shadow-outline"
                placeholder="Amount in Rp"
                v-model.number="transaction.amount"
                @keyup.enter="fundProject"
              />
              <button
                @click="fundProject"
                class="mt-3 button-cta block w-full bg-orange-button hover:bg-green-button text-white font-medium px-6 py-3 text-md rounded-full"
              >
                Fund Now
              </button>
            </template>
            <template v-else>
              <button
                @click="router.push({ path: '/login' })"
                class="mt-3 button-cta block w-full bg-orange-button hover:bg-green-button text-white font-medium px-6 py-3 text-md rounded-full"
              >
                Sign in to Fund
              </button>
            </template>
          </div>
        </div>
      </div>
    </section>
    <section class="container mx-auto pt-8">
      <div class="flex justify-between items-center">
        <div class="w-full md:w-3/4 mr-6">
          <h2 class="text-4xl text-gray-900 mb-2 font-medium">
            {{ campaignData.name }}
          </h2>
          <p class="font-light text-xl mb-5">
            {{ campaignData.short_description }}
          </p>

          <div class="relative progress-bar">
            <div
              class="overflow-hidden mb-4 text-xs flex rounded-full bg-gray-200 h-6"
            >
              <div
                :style="{ width: progressBarWidth + '%' }"
                class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-purple-progress progress-striped"
              ></div>
            </div>
          </div>
          <div class="flex progress-info mb-6">
            <div class="text-2xl">{{ progressBarWidth.toFixed(0) }}%</div>
            <div class="ml-auto font-semibold text-2xl">
              Rp {{ new Intl.NumberFormat().format(campaignData.goal_amount) }}
            </div>
          </div>

          <p class="font-light text-xl mb-5" v-html="campaignData.description"></p>
        </div>
        <div class="w-1/4 hidden md:block"></div>
      </div>
    </section>
    <div class="cta-clip -mt-20"></div>
    <CallToAction />
    <Footer />
  </div>
  <div v-else class="container mx-auto h-screen flex justify-center items-center">
    <p class="text-2xl">Loading project data...</p>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAuthStore } from '~/stores/auth'; // Sesuaikan path jika perlu
// Komponen akan di-auto-import jika berada di direktori ~/components
// import Navbar from '~/components/Navbar.vue';
// import CallToAction from '~/components/CallToAction.vue';
// import Footer from '~/components/Footer.vue';


const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();
const config = useRuntimeConfig();

const campaignData = ref(null);
const defaultImage = ref('');
const transaction = ref({
  amount: 0,
  campaign_id: Number.parseInt(route.params.id),
});

// Fetch data campaign
// Di Nuxt 3, $fetch adalah helper yang direkomendasikan untuk mengambil data API.
// useAsyncData atau useFetch bisa digunakan untuk data yang lebih kompleks atau memerlukan SSR.
// Untuk CSR murni seperti ini, $fetch atau fetch standar cukup.
async function fetchCampaignData() {
  try {
    const response = await $fetch(`/api/v1/campaigns/${route.params.id}`, {
      baseURL: config.public.BASE_URL_API,
    });
    // Struktur response API  mungkin: response.data (sesuai kode lama this.campaign.data)
    // Jika API mengembalikan { data: { ...campaignDetails... } }, maka:
    campaignData.value = response.data; 
    if (response.data && response.data.image_url) {
      defaultImage.value = `${config.public.BASE_URL_API}/${response.data.image_url}`;
    } else if (response.data && response.data.images && response.data.images.length > 0) {
      // Fallback jika image_url utama tidak ada, ambil dari array images
      defaultImage.value = `${config.public.BASE_URL_API}/${response.data.images[0].image_url}`;
    } else {
      defaultImage.value = '/avatar.jpg'; // Gambar default jika tidak ada
    }
  } catch (error) {
    console.error('Failed to fetch campaign data:', error);
    // Handle error, misalnya redirect ke halaman error atau tampilkan pesan
  }
}

onMounted(() => {
  fetchCampaignData();
});

function changeImage(url) {
  defaultImage.value = url;
}

async function fundProject() {
  if (transaction.value.amount <= 0) {
    alert('Amount must be greater than 0'); // Ganti dengan notifikasi yang lebih baik
    return;
  }
  try {
    const token = localStorage.getItem('authToken');
    if (!token) {
      alert('Please login to fund this project.');
      router.push('/login');
      return;
    }

    const response = await $fetch('/api/v1/transactions', {
      baseURL: config.public.BASE_URL_API,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: {
        campaign_id: transaction.value.campaign_id,
        amount: transaction.value.amount,
      },
    });

    if (response.data && response.data.payment_url) {
      window.location = response.data.payment_url;
    } else {
      console.error('Payment URL not found in response:', response);
      // Tampilkan pesan error kepada pengguna
    }
  } catch (err) {
    console.error('Failed to fund project:', err);
    // Tampilkan pesan error kepada pengguna
  }
}

const progressBarWidth = computed(() => {
  if (campaignData.value && campaignData.value.goal_amount > 0) {
    const percentage = (campaignData.value.current_amount / campaignData.value.goal_amount) * 100;
    return Math.min(percentage, 100); 
  }
  return 0;
});


</script>

<style lang="scss">
.project-header {
  background-image: url('/auth-background.svg'); 
  background-position: top right;
  background-repeat: no-repeat;
  background-color: #3b41e3;
  background-size: 250px;
  height: 350px;
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

.card-project {
  transition: all 0.3s ease 0s, opacity 0.5s cubic-bezier(0.5, 0, 0, 1) 1ms;
  max-height: 485px;
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