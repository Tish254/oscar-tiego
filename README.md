# Portfolio Website

A modern, responsive portfolio website built with Next.js 13+ (App Router) and TypeScript, showcasing web development projects, services, and professional experience.

## Features

- 🎨 Responsive design with mobile-first approach
- 💼 Portfolio project showcase with hover effects
- 🎯 Services section highlighting expertise
- 👤 About section with personal information
- 📧 Contact information and social media links
- ⚡ Built with Next.js 13+ App Router for optimal performance
- 🔒 TypeScript for type safety
- 🎨 CSS custom properties for maintainable theming

## Tech Stack

### Frontend

- **Next.js 16** - React framework with App Router
- **TypeScript** - Type-safe development
- **React 19** - Latest React features
- **CSS3** - Custom styles with CSS variables
- **Font Awesome** - Icon library via React components
- **Google Fonts** - Lora and Roboto Slab fonts via next/font

### Backend & Database

- **Supabase** - PostgreSQL database, authentication, and storage
- **@supabase/ssr** - Server-side rendering support for Supabase
- **Zod** - Runtime type validation for environment variables

### Development Tools

- **ESLint** - Code linting
- **Prettier** - Code formatting
- **Turbopack** - Fast development bundler

## Project Structure

```
portfolio/
├── app/
│   ├── layout.tsx          # Root layout with fonts and metadata
│   ├── page.tsx            # Home page with all sections
│   ├── globals.css         # Global styles and CSS variables
│   └── favicon.ico         # Site favicon
├── components/
│   ├── Header.tsx          # Responsive navigation component
│   └── Footer.tsx          # Footer with social links
├── lib/
│   └── supabase/           # Supabase client helpers and utilities
│       ├── client.ts       # Browser client for client components
│       ├── server.ts       # Server client for server components
│       ├── route-handler.ts # Client for route handlers
│       ├── admin.ts        # Admin client with service role key
│       ├── provider.tsx    # Auth context provider
│       ├── utils.ts        # Typed wrappers and utilities
│       ├── env.ts          # Environment validation
│       └── index.ts        # Exports
├── public/
│   └── images/             # Static images and assets
├── css/                    # Original static site CSS (archived)
├── js/                     # Original static site JS (archived)
├── img/                    # Original static site images (archived)
├── supabase/               # Database schema and migrations
├── package.json            # Dependencies and scripts
├── tsconfig.json           # TypeScript configuration
├── next.config.ts          # Next.js configuration
├── eslint.config.mjs       # ESLint configuration
└── README.md               # This file
```

## Getting Started

### Prerequisites

- Node.js 18.x or later
- npm or yarn

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd portfolio
```

2. Install dependencies:

```bash
npm install
```

3. Set up environment variables:

```bash
cp .env.example .env.local
```

Edit `.env.local` with your Supabase project credentials:

- `NEXT_PUBLIC_SUPABASE_URL`: Your Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Your Supabase anon/public key
- `SUPABASE_SERVICE_ROLE_KEY`: (Optional) Service role key for admin operations
- `SUPABASE_JWT_SECRET`: (Optional) JWT secret for token verification

You can find these values in your [Supabase project dashboard](https://app.supabase.com) under Settings > API.

### Development

Run the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser to see the result.

The page auto-updates as you edit files. The development server uses Turbopack for fast refresh.

### Building for Production

Build the application:

```bash
npm run build
```

Start the production server:

```bash
npm start
```

### Code Quality

Run ESLint:

```bash
npm run lint
```

Format code with Prettier:

```bash
npm run format
```

## Features in Detail

### Responsive Navigation

- **Desktop**: Horizontal navigation bar with active section highlighting
- **Mobile**: Hamburger menu with slide-out navigation
- **Scroll Detection**: Automatic active state updates based on scroll position

### Hero Section

- Name: Oscar Tiego
- Title: full-stack dev
- Profile image with Next.js Image optimization

### Services

1. **Web Design** - Figma, Adobe Illustrator, Adobe XD
2. **Web Development** - HTML, CSS, JavaScript, React, Express, Node.js
3. **Desktop Development** - PyQt Python framework

### Portfolio Projects

1. **Dukas E-Commerce** - Modern e-commerce platform
2. **Zebraz E-learning** - Interactive education platform
3. **Akan Name Generator** - Cultural web application

All projects feature hover overlays with links to live demos.

### About Section

Designer & developer based in Nairobi with interests in:

- Blockchain technologies
- Cyber security
- Database programming
- React, C#, and modern frameworks
- Chess and building things for fun

### Contact & Social

- Email: tiegomseeraoscar295@gmail.com
- [Facebook](https://www.facebook.com/oscar.tiego.92/)
- [LinkedIn](https://www.linkedin.com/in/oscar-tiego-b1b190171)
- [Twitter](https://twitter.com/py12317)
- [GitHub](https://github.com/Tish254)

## CSS Variables

The project uses CSS custom properties for easy theming:

- `--ff-primary`: Primary font (Lora)
- `--ff-secondary`: Secondary font (Roboto Slab)
- `--clr-light`: Light color (#fff)
- `--clr-dark`: Dark color (#303030)
- `--clr-accent`: Accent color (#16e0bd)
- `--fs-h1`, `--fs-h2`, `--fs-h3`, `--fs-body`: Font sizes
- `--fw-reg`, `--fw-bold`: Font weights

## Next.js Features Used

- **App Router**: Modern routing with layouts and nested routes
- **Server Components**: Default server-side rendering for better performance
- **Client Components**: Interactive components with 'use client' directive
- **next/font**: Optimized font loading with automatic self-hosting
- **next/image**: Automatic image optimization
- **TypeScript**: Full type safety throughout the application
- **Turbopack**: Fast development experience

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Supabase Integration

This project uses Supabase for backend services including authentication, database, and storage.

### Configuration

Environment variables are validated using Zod schemas. Required variables:

- `NEXT_PUBLIC_SUPABASE_URL` - Your Supabase project URL (public)
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Your Supabase anonymous key (public)
- `SUPABASE_SERVICE_ROLE_KEY` - Service role key for admin operations (server-only)
- `SUPABASE_JWT_SECRET` - JWT secret for token verification (server-only)

### Client Helpers

The project provides several Supabase client helpers for different contexts:

**Browser Client (Client Components)**

```typescript
import { createBrowserClient } from '@/lib/supabase/client';

// In a client component
const supabase = createBrowserClient();
```

**Server Client (Server Components)**

```typescript
import { createServerClient } from '@/lib/supabase/server';

// In a server component
const supabase = await createServerClient();
```

**Route Handler Client (API Routes)**

```typescript
import { createRouteHandlerClient } from '@/lib/supabase/route-handler';

// In a route handler
const supabase = await createRouteHandlerClient();
```

**Admin Client (Server-Side Admin Operations)**

```typescript
import { createAdminClient } from '@/lib/supabase/admin';

// For admin operations with elevated privileges
const supabase = createAdminClient();
```

### Auth Context

The `SupabaseProvider` wraps the app and provides auth context:

```typescript
import { useSupabase, useSession, useUser } from '@/lib/supabase/provider';

// Access Supabase client and auth state
const { supabase, session, user, isLoading } = useSupabase();

// Or use specific hooks
const { session, isLoading } = useSession();
const { user, isLoading } = useUser();
```

### Utility Functions

Typed wrappers for common operations:

- `fetchSingle<T>()` - Fetch a single record with error handling
- `fetchMany<T>()` - Fetch multiple records with error handling
- `uploadFile()` - Upload files to Supabase Storage
- `getPublicUrl()` - Get public URL for stored files
- `getSignedUrl()` - Generate signed URLs for private files
- `deleteFile()` - Delete files from storage

Example usage:

```typescript
import { fetchMany, uploadFile } from '@/lib/supabase/utils';
import { createBrowserClient } from '@/lib/supabase';

const supabase = createBrowserClient();

// Fetch data with error handling
const { data, error } = await fetchMany(() => supabase.from('posts').select('*'));

// Upload a file
const result = await uploadFile(supabase, {
  bucket: 'images',
  path: 'avatar.jpg',
  file: fileBlob,
});
```

### Database Schema

The project includes comprehensive database schema and migrations. See [supabase/README.md](supabase/README.md) for details.

## Future Enhancements

- [x] Connect frontend to Supabase backend
- [ ] Implement blog functionality
- [ ] Add admin dashboard for content management
- [ ] Integrate Supabase Storage for image uploads
- [ ] Add search functionality for blog posts
- [ ] Implement dark mode toggle
- [ ] Add animations with Framer Motion
- [ ] Implement contact form with email notifications
- [ ] Add analytics tracking
- [ ] Optimize images with responsive breakpoints

## Migration Notes

This project was migrated from a static HTML/CSS/JS site to Next.js 13+ with TypeScript:

- ✅ All CSS styles ported to globals.css
- ✅ Navigation converted to React components with hooks
- ✅ Google Fonts integrated via next/font
- ✅ Font Awesome integrated via React components
- ✅ Images moved to public/images directory
- ✅ Responsive behavior preserved
- ✅ Scroll-based active states reimplemented with React

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).

## Contact

Oscar Tiego - [tiegomseeraoscar295@gmail.com](mailto:tiegomseeraoscar295@gmail.com)

Portfolio: [https://github.com/Tish254](https://github.com/Tish254)
