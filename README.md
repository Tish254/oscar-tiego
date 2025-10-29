# Portfolio Website

A modern, responsive portfolio website showcasing web development projects, services, and blog content.

## Features

- 🎨 Responsive design with mobile-first approach
- 💼 Portfolio project showcase with hover effects
- 📝 Blog system with tags and categories
- 🎯 Services section highlighting expertise
- 👤 About section with personal information
- 📧 Contact information and social media links
- 🔒 Secure content management with Supabase

## Tech Stack

### Frontend
- HTML5
- CSS3 (Custom styles with CSS variables)
- Vanilla JavaScript
- Font Awesome icons
- Google Fonts (Lora, Roboto Slab)
- Normalize.css

### Backend & Database
- [Supabase](https://supabase.com) - PostgreSQL database with Row Level Security
- RESTful API via Supabase
- Row Level Security (RLS) for content protection

## Project Structure

```
porfolio-main/
├── index.html          # Main HTML file
├── css/
│   └── style.css      # Custom styles
├── js/
│   └── index.js       # JavaScript functionality
├── img/               # Images and assets
├── supabase/          # Database schema and migrations
│   ├── migrations/    # SQL migration files
│   │   ├── 20240101000000_initial_schema.sql
│   │   └── 20240101000001_row_level_security.sql
│   ├── seed.sql       # Initial seed data
│   └── README.md      # Database documentation
└── README.md          # This file
```

## Database Schema

The project uses Supabase (PostgreSQL) with a normalized schema supporting:

- **Blog System**: Posts, tags, and author management
- **Portfolio Projects**: Project showcases with images and metadata
- **Services**: Service offerings and descriptions
- **Site Content**: Dynamic content management for hero, about sections
- **User Profiles**: Role-based access control (admin, editor, viewer)
- **Media Management**: Centralized asset metadata

### Key Features

✅ **Row Level Security (RLS)**: All tables protected with security policies  
✅ **Public Read Access**: Published content accessible without authentication  
✅ **Admin CRUD**: Full content management for authenticated admins  
✅ **Normalized Schema**: Proper relationships with foreign keys  
✅ **Optimized Indexes**: Fast queries on slugs, ordering, and status fields  
✅ **Seed Data**: Pre-populated with current site content  

For detailed schema documentation, migration instructions, and RLS policy rationale, see [supabase/README.md](supabase/README.md).

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd porfolio-main
```

### 2. Set Up Supabase Database

Follow the instructions in [supabase/README.md](supabase/README.md) to:
1. Create a Supabase project
2. Apply database migrations
3. Run seed scripts
4. Configure environment variables

Quick start:
```bash
# Install Supabase CLI
npm install -g supabase

# Link to your project
supabase link --project-ref your-project-ref

# Apply migrations and seed data
supabase db push
psql -h your-db-host -U postgres -d postgres -f supabase/seed.sql
```

### 3. Configure Environment

Create a `.env` file (not tracked in git):

```env
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

### 4. Open the Website

Simply open `index.html` in a web browser, or serve it using a local server:

```bash
# Using Python
python -m http.server 8000

# Using Node.js (http-server)
npx http-server

# Using PHP
php -S localhost:8000
```

Then navigate to `http://localhost:8000`

## Development

### Running Locally

The site is a static single-page application that can be opened directly in a browser. For development with live reload, use a local server.

### Database Changes

To modify the database schema:

```bash
# Create a new migration
supabase migration new your_migration_name

# Edit the generated file in supabase/migrations/

# Apply the migration
supabase db push

# Test locally
supabase start
supabase db reset
```

### Content Management

Content can be managed through:
1. Supabase Dashboard (SQL Editor or Table Editor)
2. Custom admin interface (to be implemented)
3. Direct API calls using `@supabase/supabase-js`

## Content Sections

### Hero Section
- Name: Oscar Tiego
- Title: full-stack dev
- Profile image

### Services
1. **Web Design** - Figma, Adobe Illustrator, Adobe XD
2. **Web Development** - HTML, CSS, JavaScript, React, Express, Node.js
3. **Desktop Development** - PyQt Python framework

### Portfolio Projects
1. **Dukas E-Commerce** - Modern e-commerce platform
2. **Zebraz E-learning** - Interactive education platform
3. **Akan Name Generator** - Cultural web application

### About Section
Designer & developer based in Nairobi with interests in:
- Blockchain technologies
- Cyber security
- Database programming
- React, C#, and modern frameworks
- Chess and building things for fun

### Contact
- Email: tiegomseeraoscar295@gmail.com
- [Facebook](https://www.facebook.com/oscar.tiego.92/)
- [LinkedIn](https://www.linkedin.com/in/oscar-tiego-b1b190171)
- [Twitter](https://twitter.com/py12317)
- [GitHub](https://github.com/Tish254)

## Features in Detail

### Responsive Navigation
- Desktop: Horizontal navigation bar with active section highlighting
- Mobile: Hamburger menu with slide-out navigation

### Portfolio Grid
- Hover effects revealing project details
- Links to live demos
- Technology tags

### Scroll-based Active States
- Navigation items highlight as you scroll to each section
- Smooth scrolling behavior

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Future Enhancements

- [ ] Connect frontend to Supabase backend
- [ ] Implement blog functionality
- [ ] Add admin dashboard for content management
- [ ] Integrate Supabase Storage for image uploads
- [ ] Add search functionality for blog posts
- [ ] Implement dark mode toggle
- [ ] Add animations with GSAP or Framer Motion
- [ ] Implement contact form with email notifications
- [ ] Add analytics tracking
- [ ] Optimize images and implement lazy loading

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).

## Contact

Oscar Tiego - [tiegomseeraoscar295@gmail.com](mailto:tiegomseeraoscar295@gmail.com)

Portfolio: [https://github.com/Tish254](https://github.com/Tish254)
