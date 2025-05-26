# Frontend - BWAStartup Project

This directory contains the frontend application for the BWAStartup project, built with [Nuxt 3](https://nuxt.com/) and styled with [Tailwind CSS](https://tailwindcss.com/).

## 🚀 Features

- **Campaign Browse**: Users can view and search for startup campaigns.
- **Campaign Details**: View detailed information about a specific campaign, including goals, progress, and perks.
- **User Authentication**: Sign up, sign in, and user profile management.
- **Campaign Creation & Management**: Logged-in users can create and manage their own funding campaigns.
- **Funding**: Users can contribute funds to campaigns.
- **Dashboard**: A user dashboard to view their projects and transaction history.
- **Responsive Design**: Styled with Tailwind CSS for a responsive experience across devices.

## 🛠️ Tech Stack

- **Framework**: [Nuxt 3](https://nuxt.com/) (Vue 3)
- **Styling**: [Tailwind CSS](https://tailwindcss.com/)
- **State Management**: [Pinia](https://pinia.vuejs.org/)
- **HTTP Client**: Native `Workspace` or `$fetch` (Nuxt 3's isomorphic fetch wrapper)
- **Linting/Formatting**: (Assumed ESLint and Prettier based on `package.json` devDependencies)

## ⚙️ Configuration

The frontend application connects to a backend API. The base URL for this API is configured via an environment variable.

1.  Create a `.env` file in the `frontend` directory by copying `.env.example` (if it exists, or create one).
2.  Set the `NUXT_PUBLIC_BASE_URL_API` variable in your `.env` file:

    ```env
    NUXT_PUBLIC_BASE_URL_API=http://localhost:8080
    ```

    Replace `http://localhost:8080` with the actual URL of your running backend API if it's different. This is configured in `nuxt.config.ts`.

## 📦 Project Structure

```
frontend/
├── assets/             # Un-compiled assets like CSS, fonts
│   └── css/
│       └── tailwind.css # Main Tailwind CSS import and custom styles
├── components/         # Vue components (auto-imported)
├── layouts/            # Layout components for pages
├── middleware/         # Route middleware (e.g., for authentication)
├── pages/              # Application views and routes
│   ├── dashboard/
│   │   ├── projects/
│   │   │   ├── create.vue
│   │   │   └── _id/
│   │   │       ├── edit.vue
│   │   │       └── index.vue
│   │   ├── transactions.vue
│   │   └── index.vue
│   ├── login/
│   │   └── index.vue   # Or pages/login.vue
│   ├── projects/
│   │   └── _id.vue
│   ├── register/
│   │   └── success.vue
│   ├── upload.vue
│   └── index.vue       # Landing page
├── public/             # Static assets directly served
│   ├── avatar.jpg
│   ├── icon-avatar-add.svg
│   ├── ... (other static images and files)
│   └── robots.txt
├── stores/             # Pinia state management stores
│   └── auth.ts         # Authentication store
├── nuxt.config.ts      # Nuxt 3 configuration file
├── package.json        # Project dependencies and scripts
├── tailwind.config.js  # Tailwind CSS configuration
├── tsconfig.json       # TypeScript configuration (even if not strictly used in all .vue files)
└── README.md           # This file
```

## 🚀 Development

### Prerequisites

- Node.js (version recommended by Nuxt 3, typically LTS)
- npm, yarn, or pnpm

### Setup

Make sure to install dependencies:

```bash
# npm
npm install

# yarn
yarn install

# pnpm
pnpm install
```

### Development Server

Start the development server on `http://localhost:3000` (or the next available port):

```bash
# npm
npm run dev

# yarn
yarn dev

# pnpm
pnpm dev
```

The application will automatically reload if you change any of the source files.

## 🏗️ Production

### Build

Build the application for production:

```bash
# npm
npm run build

# yarn
yarn build

# pnpm
pnpm build
```

### Preview Production Build

Locally preview the production build:

```bash
# npm
npm run preview

# yarn
yarn preview

# pnpm
pnpm preview
```

For more information on deployment, check out the [Nuxt 3 deployment documentation](https://nuxt.com/docs/getting-started/deployment).

## 🎨 Styling

- **Tailwind CSS**: Utility-first CSS framework used for styling. Configuration can be found in `tailwind.config.js`.
- **Custom CSS**: Global custom styles and Tailwind directives are in `assets/css/tailwind.css`.
- **Poppins Font**: The Poppins font is imported in `assets/css/tailwind.css` and set as the default sans-serif font in `tailwind.config.js`.

## 🚦 Routing

Nuxt 3 uses a file-system based router. Files in the `pages/` directory automatically become application routes.

- **Dynamic Routes**: Files or directories prefixed with an underscore (`_`) create dynamic routes (e.g., `pages/projects/_id.vue` becomes `/projects/:id`).
- **Nested Routes**: Nested directories create nested routes (e.g., `pages/dashboard/projects/create.vue` becomes `/dashboard/projects/create`).

## 💾 State Management

[Pinia](https://pinia.vuejs.org/) is used for state management. Store modules are located in the `stores/` directory.

- `stores/auth.ts`: Manages authentication state (user data, login status).

## 🔒 Authentication

- Authentication is handled manually by interacting with the backend API.
- User sessions and tokens are managed on the client-side (e.g., using `localStorage`).
- Route middleware (in `middleware/auth.js` or similar) is used to protect routes that require authentication.

## 💡 Further Information

- Look at the [Nuxt 3 documentation](https://nuxt.com/docs/getting-started/introduction) to learn more.
- Refer to the `package.json` for a full list of dependencies and scripts.
- The main Nuxt configuration is in `nuxt.config.ts`.
