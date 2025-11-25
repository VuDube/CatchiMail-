# CatchiMail — Edge-First Inbox PWA
[cloudflarebutton]
CatchiMail is a polished, mobile-first Progressive Web App (PWA) email client optimized to run at the Cloudflare edge. This repository implements a feature-complete, production-ready application with a visually stunning dark-mode frontend, core integrations, and advanced multi-zone capabilities. It supports primary flows in a single-page UI: authentication, a multi-zone inbox with AI-summary previews and triage actions, adaptive message detail rendering, and a mobile-optimized compose experience with mock AI tone analysis. The app is built on a React + shadcn/ui + Tailwind foundation, ensuring zero-risk deployment to Cloudflare Pages and Workers.
## Features
- **Multi-Zone Support**: Manage multiple domains (zones) from a single interface. A global zone selector filters the inbox and other views.
- **Authentication**: Minimalist login/register interface integrated with Cloudflare API endpoints.
- **Inbox View**: Single-column, mobile-first message list displaying sender, subject, and AI-generated summaries. Includes swipe gestures for quick triage (archive/delete).
- **Adaptive Detail View**: Renders messages based on category: OTP (large code + one-click copy), FORM_DATA (key-value cards), and standard HTML.
- **Compose View**: Mobile-friendly drafting with a prominent send button and a mock AI Tone Check to analyze message sentiment before sending.
- **PWA & Offline Support**: Installable on mobile devices with a service worker for offline caching of messages, zones, and assets.
- **CI/CD**: Automated deployments to Cloudflare on every push to `main` via GitHub Actions.
- **Edge-Optimized**: All data flows through Cloudflare Workers with persistence handled by a single Durable Object, demonstrating a scalable, low-latency architecture.
## Tech Stack
- **Frontend**: React 18, React Router 6, TypeScript, shadcn/ui, Tailwind CSS 3, Lucide React, Framer Motion, Sonner, Zustand.
- **Backend**: Hono, Cloudflare Workers, Durable Objects.
- **Build & Deploy**: Vite, Bun, Wrangler, GitHub Actions.
- **Deployment**: Cloudflare Pages (static assets) + Workers (API endpoints).
## Quick Start
### Prerequisites
- Bun 1.0+ (`curl -fsSL https://bun.sh/install | bash`).
- Cloudflare account (free tier is sufficient).
- Wrangler CLI: `bun add -g wrangler`.
### Installation
1. Clone the repository: `git clone <repository-url> && cd catchimail`
2. Install dependencies: `bun install`
3. Generate TypeScript types for Cloudflare bindings: `bun run cf-typegen`
### Development
1. Start the frontend dev server: `bun run dev` (App at `http://localhost:3000`)
2. In a separate terminal, start the Cloudflare Worker: `wrangler dev` (Backend at `http://localhost:8787`)
## API Token Setup for Deployment
To deploy automatically with GitHub Actions, you need a Cloudflare API token with specific permissions.
1. Go to **Cloudflare Dashboard > My Profile > API Tokens > Create Token**.
2. Use the **"Create Custom Token"** template.
3. Grant the following permissions:
   - `Account`: `Workers Scripts`: `Edit`
   - `Account`: `Workers KV Storage`: `Edit` (if using KV)
   - `User`: `User Details`: `Read`
   - `Zone`: `Zone`: `Read`
   - `Zone`: `Zone Settings`: `Read`
4. Continue to summary, create the token, and copy it.
5. In your GitHub repository, go to **Settings > Secrets and variables > Actions** and create two new secrets:
   - `CLOUDFLARE_API_TOKEN`: Paste the token you just created.
   - `CLOUDFLARE_ACCOUNT_ID`: Your Cloudflare Account ID (find it on the right sidebar of the Workers & Pages overview page).
## Deployment
- **Automatic**: Push or merge to the `main` branch. The GitHub Action in `.github/workflows/deploy.yml` will automatically build and deploy the application.
- **Manual**: Run `bun run deploy` from your local machine after logging in with `wrangler login`.
## Feature Details
### Multi-Zone Usage
The app discovers and lists your Cloudflare zones in a dropdown. Selecting a zone filters the inbox to show messages associated with that domain. The compose view adapts to help you send from the correct context.
### Mocks & Placeholders
- **AI Tone Analysis**: A client-side function provides mock sentiment analysis on your draft. The backend also returns a mock tone.
- **SendPulse**: The backend logs a "Sent via SendPulse" message to the console as a placeholder for a real email integration.
- **Email Processing**: The worker mocks an email processing pipeline. It classifies incoming messages, generates a summary, and stores the data in the Durable Object.
- **Scheduled Cleanup**: The `/api/inbox` endpoint includes logic to simulate a cron job that cleans up messages older than 7 days.
### PWA Functionality
Add the app to your mobile home screen for a native-like experience. The service worker provides a robust offline mode, allowing you to read cached messages and zones even without a connection.
[cloudflarebutton]# CatchiMail-
