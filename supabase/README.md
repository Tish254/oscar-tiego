# Supabase Database Schema

This directory contains the SQL migration files and seed data for the portfolio website's Supabase database.

## 📁 Files in This Directory

- **[QUICK_START.md](QUICK_START.md)** - 🚀 Start here! Get up and running in 5 minutes
- **[SCHEMA.md](SCHEMA.md)** - 📊 Detailed schema documentation with ERD and table details
- **[README.md](README.md)** - 📖 This file - comprehensive documentation
- **migrations/** - SQL migration files (apply in order)
  - `20240101000000_initial_schema.sql` - Tables, indexes, triggers
  - `20240101000001_row_level_security.sql` - RLS policies
- **[seed.sql](seed.sql)** - Initial data from current static site
- **[example-queries.sql](example-queries.sql)** - Common query patterns and examples
- **[test-schema.sql](test-schema.sql)** - Verification tests for schema
- **[apply-migrations.sh](apply-migrations.sh)** - Helper script to apply migrations
- **[new-migration.sh](new-migration.sh)** - Helper script to create new migrations

## Overview

The database schema supports:

- **Blog System**: Posts, tags, and author attribution
- **Portfolio Projects**: Project showcases with images and metadata
- **Services**: Service offerings displayed on the site
- **Site Content**: Dynamic content for hero, about, and other sections
- **User Profiles**: Author/admin management
- **Media Management**: Centralized asset metadata

## Schema Structure

### Tables

#### `profiles`

Stores user/author information with role-based access control.

- **Fields**: id, email, display_name, avatar_url, role, created_at, updated_at
- **Roles**: admin, editor, viewer
- **Indexes**: email, role

#### `blog_posts`

Blog content with publishing workflow.

- **Fields**: id, title, slug, excerpt, content, status, published_at, author_id, featured_image_id, view_count, created_at, updated_at
- **Status**: draft, published, archived
- **Indexes**: slug (unique), status, author_id, published_at
- **Relations**: author (profiles), featured_image (media)

#### `blog_tags`

Tags for categorizing blog posts.

- **Fields**: id, name, slug, description, created_at
- **Indexes**: slug (unique)

#### `blog_post_tags`

Many-to-many join table for blog posts and tags.

- **Fields**: blog_post_id, blog_tag_id, created_at
- **Composite Key**: (blog_post_id, blog_tag_id)

#### `portfolio_projects`

Portfolio project showcases.

- **Fields**: id, title, slug, description, technologies[], live_url, github_url, display_order, is_featured, is_published, created_at, updated_at
- **Indexes**: slug (unique), display_order, is_published, is_featured

#### `project_images`

Images associated with portfolio projects.

- **Fields**: id, project_id, storage_path, alt_text, is_primary, display_order, created_at
- **Indexes**: project_id, is_primary, display_order

#### `services`

Service offerings displayed on the site.

- **Fields**: id, title, description, icon, display_order, is_published, created_at, updated_at
- **Indexes**: display_order, is_published

#### `site_content`

Key-value store for dynamic site content (hero, about sections, etc.).

- **Fields**: id, key, content_type, value, description, created_at, updated_at
- **Content Types**: text, html, json, image_url
- **Indexes**: key (unique)

#### `media`

Centralized metadata for media assets.

- **Fields**: id, storage_path, file_name, mime_type, file_size, alt_text, caption, uploaded_by, created_at, updated_at
- **Indexes**: storage_path, uploaded_by

### Enums

- **`user_role`**: admin, editor, viewer
- **`blog_status`**: draft, published, archived

## Row Level Security (RLS)

All tables have RLS enabled with the following policies:

### Public Read Access

- ✅ Published blog posts (`status='published'` AND `published_at <= NOW()`)
- ✅ Published portfolio projects (`is_published=true`)
- ✅ Published services (`is_published=true`)
- ✅ All site content
- ✅ All tags
- ✅ All media
- ✅ Public profiles (for author attribution)
- ✅ Project images

### Admin Full CRUD

Users with `role='admin'` in the `profiles` table have:

- ✅ Full CREATE, READ, UPDATE, DELETE access on all tables
- ✅ Can view unpublished/draft content
- ✅ Can manage user profiles

### Policy Rationale

1. **Public Content Display**: Unauthenticated users can view published content to enable the public portfolio site
2. **Content Management**: Admins can manage all content through admin interfaces
3. **Draft Protection**: Unpublished content is only visible to admins
4. **Service Role Bypass**: Backend services and migrations bypass RLS entirely using the service role
5. **Security**: No user can escalate privileges without admin role assignment

## Setup Instructions

### Prerequisites

1. Install Supabase CLI:

   ```bash
   npm install -g supabase
   ```

2. Initialize Supabase (if not already done):

   ```bash
   supabase init
   ```

3. Link to your Supabase project:
   ```bash
   supabase link --project-ref your-project-ref
   ```

### Option 1: Using Supabase CLI (Recommended)

#### Apply Migrations

Run migrations in order:

```bash
# Apply all migrations
supabase db push
```

Or apply individually:

```bash
# Apply schema migration
psql -h your-db-host -U postgres -d postgres -f supabase/migrations/20240101000000_initial_schema.sql

# Apply RLS policies
psql -h your-db-host -U postgres -d postgres -f supabase/migrations/20240101000001_row_level_security.sql
```

#### Seed the Database

```bash
# Apply seed data
psql -h your-db-host -U postgres -d postgres -f supabase/seed.sql
```

Or using Supabase CLI:

```bash
supabase db reset
```

### Option 2: Using Supabase Dashboard

1. Navigate to your Supabase project dashboard
2. Go to **SQL Editor**
3. Copy and paste the contents of each migration file in order:
   - `20240101000000_initial_schema.sql`
   - `20240101000001_row_level_security.sql`
4. Execute each script
5. Run the `seed.sql` file to populate initial data

### Option 3: Local Development

```bash
# Start local Supabase instance
supabase start

# Apply migrations
supabase db reset

# View local database
supabase db studio
```

## Verifying the Setup

After applying migrations and seeds, verify with these queries:

```sql
-- Check table counts
SELECT
    'profiles' as table_name, COUNT(*) as count FROM profiles
UNION ALL
SELECT 'blog_posts', COUNT(*) FROM blog_posts
UNION ALL
SELECT 'blog_tags', COUNT(*) FROM blog_tags
UNION ALL
SELECT 'portfolio_projects', COUNT(*) FROM portfolio_projects
UNION ALL
SELECT 'services', COUNT(*) FROM services
UNION ALL
SELECT 'site_content', COUNT(*) FROM site_content
UNION ALL
SELECT 'media', COUNT(*) FROM media;

-- Verify RLS is enabled
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename IN ('profiles', 'blog_posts', 'portfolio_projects', 'services', 'site_content');

-- Test public access (should only see published content)
SET ROLE anon;
SELECT title, status FROM blog_posts;
RESET ROLE;
```

## Linting/Validation

Validate SQL syntax using Supabase CLI:

```bash
# Lint migrations
supabase db lint

# Check for common issues
supabase db diff
```

Or manually review:

- All tables have primary keys
- Foreign keys have proper CASCADE/SET NULL actions
- Indexes on frequently queried columns
- RLS enabled on all tables
- Policies cover all CRUD operations

## Seed Data Contents

The seed script populates:

### Profiles

- 1 admin user (Oscar Tiego)

### Site Content (19 entries)

- Hero section (name, title, greeting, image)
- About section (title, subtitle, 2 paragraphs, image)
- Work section (title, subtitle)
- Services section (title)
- Contact/social links (email, Facebook, LinkedIn, Twitter, GitHub)

### Services (3 entries)

1. Web Design (Figma, Adobe Illustrator, Adobe XD)
2. Web Development (HTML, CSS, JavaScript, React, Express, Node.js)
3. Desktop Development (PyQt Python framework)

### Portfolio Projects (3 entries)

1. Dukas E-Commerce
2. Zebraz E-learning
3. Akan Name Generator

### Project Images (3 entries)

- One primary image per project

### Blog Tags (10 entries)

Web Development, JavaScript, React, Node.js, CSS, Python, Database, Blockchain, Cybersecurity, Tutorial

### Blog Posts (4 entries)

- 3 published posts with relevant content
- 1 draft post for testing

### Media (6 entries)

- References to existing static assets (hero images, logos, project thumbnails)

## Updating Schema

To create a new migration:

```bash
# Generate a new migration file
supabase migration new your_migration_name

# Edit the generated file in supabase/migrations/
# Then apply it
supabase db push
```

## Resetting Database

⚠️ **Warning**: This will delete all data!

```bash
# Reset local database
supabase db reset

# For production, use manual backup/restore through dashboard
```

## Backup and Restore

### Backup

```bash
# Using pg_dump
pg_dump -h your-db-host -U postgres -d postgres > backup.sql

# Or use Supabase dashboard backup feature
```

### Restore

```bash
# Using psql
psql -h your-db-host -U postgres -d postgres < backup.sql
```

## Environment Variables

When connecting to Supabase from your application, you'll need:

```env
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

- **ANON_KEY**: For public read access (respects RLS)
- **SERVICE_ROLE_KEY**: For admin operations (bypasses RLS) - keep secure!

## Next Steps

1. ✅ Apply migrations to Supabase project
2. ✅ Run seed script to populate initial data
3. ✅ Verify RLS policies are working correctly
4. 🔲 Connect frontend to Supabase using `@supabase/supabase-js`
5. 🔲 Implement admin dashboard for content management
6. 🔲 Set up Supabase Storage for image uploads
7. 🔲 Configure Supabase Auth for admin login
8. 🔲 Add database triggers for additional business logic
9. 🔲 Implement search functionality using PostgreSQL full-text search

## Troubleshooting

### Migration Fails

- Check syntax errors in SQL files
- Ensure migrations are applied in order
- Verify database permissions
- Check Supabase project logs

### RLS Policies Not Working

- Verify RLS is enabled: `ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;`
- Check if using correct API key (anon vs service role)
- Test policies by setting role: `SET ROLE anon;`

### Seed Data Issues

- Ensure migrations are applied first
- Check for unique constraint violations
- Verify foreign key references exist

## Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [PostgreSQL Row Level Security](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
- [Supabase CLI Reference](https://supabase.com/docs/reference/cli)
- [Database Design Best Practices](https://supabase.com/docs/guides/database/design)
