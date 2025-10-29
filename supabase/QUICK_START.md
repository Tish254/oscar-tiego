# Supabase Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites
- PostgreSQL client (`psql`) or Supabase CLI
- Access to a Supabase project

### Step 1: Install Supabase CLI (Optional)
```bash
npm install -g supabase
```

### Step 2: Set Up Your Database

#### Option A: Using Supabase Dashboard (Easiest)
1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Navigate to SQL Editor
3. Copy and paste each file in order:
   - `migrations/20240101000000_initial_schema.sql`
   - `migrations/20240101000001_row_level_security.sql`
   - `seed.sql`
4. Execute each script

#### Option B: Using the Helper Script
```bash
# Set your database URL
export DATABASE_URL="postgresql://postgres:[PASSWORD]@[HOST]:5432/postgres"

# Run the migration script
./supabase/apply-migrations.sh
```

#### Option C: Using psql Directly
```bash
psql "postgresql://postgres:[PASSWORD]@[HOST]:5432/postgres" -f supabase/migrations/20240101000000_initial_schema.sql
psql "postgresql://postgres:[PASSWORD]@[HOST]:5432/postgres" -f supabase/migrations/20240101000001_row_level_security.sql
psql "postgresql://postgres:[PASSWORD]@[HOST]:5432/postgres" -f supabase/seed.sql
```

### Step 3: Verify Setup
```sql
-- Check table counts
SELECT 
    'profiles' as table, COUNT(*) as count FROM profiles
UNION ALL
SELECT 'blog_posts', COUNT(*) FROM blog_posts
UNION ALL
SELECT 'portfolio_projects', COUNT(*) FROM portfolio_projects
UNION ALL
SELECT 'services', COUNT(*) FROM services;
```

Expected results:
- profiles: 1
- blog_posts: 4
- portfolio_projects: 3
- services: 3

## 📚 What You Get

### Tables Created
✅ `profiles` - User accounts  
✅ `blog_posts` - Blog content  
✅ `blog_tags` - Post tags  
✅ `blog_post_tags` - Tag relationships  
✅ `portfolio_projects` - Portfolio items  
✅ `project_images` - Project images  
✅ `services` - Service offerings  
✅ `site_content` - Dynamic content  
✅ `media` - Asset metadata  

### Security Enabled
✅ Row Level Security (RLS) on all tables  
✅ Public read access for published content  
✅ Admin-only write access  

### Sample Data Included
✅ 1 admin profile (Oscar Tiego)  
✅ 3 portfolio projects (Dukas, Zebraz, Akan)  
✅ 3 services (Web Design, Web Dev, Desktop Dev)  
✅ 4 blog posts (3 published, 1 draft)  
✅ 10 blog tags  
✅ 19 site content entries  

## 🔑 Environment Variables

Add these to your `.env` file:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

Get these from: Supabase Dashboard → Settings → API

## 📖 Common Queries

### Get All Published Blog Posts
```sql
SELECT title, slug, excerpt, published_at
FROM blog_posts
WHERE status = 'published'
ORDER BY published_at DESC;
```

### Get All Portfolio Projects
```sql
SELECT title, slug, description, live_url
FROM portfolio_projects
WHERE is_published = true
ORDER BY display_order ASC;
```

### Get All Services
```sql
SELECT title, description, icon
FROM services
WHERE is_published = true
ORDER BY display_order ASC;
```

### Get Hero Content
```sql
SELECT key, value
FROM site_content
WHERE key LIKE 'hero_%';
```

## 🛠 Development Workflow

### Creating a New Migration
```bash
./supabase/new-migration.sh add_comments_table
# Edit the generated file
# Apply: ./supabase/apply-migrations.sh
```

### Testing Queries
```bash
# Use the example queries file
psql $DATABASE_URL -f supabase/example-queries.sql
```

### Resetting Database (⚠️ Destructive)
```bash
# Drop all tables and re-apply
psql $DATABASE_URL -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
./supabase/apply-migrations.sh
```

## 📱 Frontend Integration

### Install Supabase Client
```bash
npm install @supabase/supabase-js
```

### Initialize Client
```javascript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
)
```

### Fetch Published Blog Posts
```javascript
const { data, error } = await supabase
  .from('blog_posts')
  .select(`
    *,
    author:profiles(display_name, avatar_url),
    tags:blog_post_tags(tag:blog_tags(name, slug))
  `)
  .eq('status', 'published')
  .order('published_at', { ascending: false })
```

### Fetch Portfolio Projects
```javascript
const { data, error } = await supabase
  .from('portfolio_projects')
  .select(`
    *,
    images:project_images(storage_path, alt_text, is_primary)
  `)
  .eq('is_published', true)
  .order('display_order')
```

### Fetch Services
```javascript
const { data, error } = await supabase
  .from('services')
  .select('*')
  .eq('is_published', true)
  .order('display_order')
```

### Fetch Site Content
```javascript
const { data, error } = await supabase
  .from('site_content')
  .select('key, value, content_type')

// Convert to object
const content = data.reduce((acc, item) => {
  acc[item.key] = item.value
  return acc
}, {})
```

## 🔒 Admin Operations

For admin operations, use the service role key:

```javascript
const supabaseAdmin = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
)

// Create a new blog post
const { data, error } = await supabaseAdmin
  .from('blog_posts')
  .insert({
    title: 'New Post',
    slug: 'new-post',
    content: '<p>Content here</p>',
    status: 'draft',
    author_id: 'author-uuid'
  })

// Publish a post
const { data, error } = await supabaseAdmin
  .from('blog_posts')
  .update({ 
    status: 'published',
    published_at: new Date().toISOString()
  })
  .eq('slug', 'new-post')
```

## 📊 Database Size & Performance

### Current Schema Stats
- **Tables**: 9
- **Indexes**: 25+
- **Policies**: 36
- **Triggers**: 6

### Expected Storage (with seed data)
- Minimal: < 1 MB
- With media metadata: < 5 MB
- With 100 blog posts: ~10-20 MB

### Performance Tips
1. Use indexes - they're already set up!
2. Filter on indexed columns (slug, status, is_published)
3. Use `.select()` to fetch only needed columns
4. Paginate large result sets

## 🆘 Troubleshooting

### "Permission denied" errors
- Check if you're using the correct API key
- Verify RLS policies are enabled
- Use service role key for admin operations

### "Relation does not exist"
- Migrations not applied
- Wrong database connection
- Run `apply-migrations.sh` again

### Seed data not appearing
- Check if migrations were successful first
- Re-run seed script
- Verify no unique constraint violations

### Slow queries
- Check if indexes exist: `\d+ table_name` in psql
- Use EXPLAIN ANALYZE in psql
- Add indexes on frequently filtered columns

## 📝 Next Steps

1. ✅ Database set up and seeded
2. 🔲 Connect frontend to Supabase
3. 🔲 Implement authentication for admin
4. 🔲 Build admin dashboard
5. 🔲 Set up Supabase Storage for images
6. 🔲 Add realtime subscriptions
7. 🔲 Implement search functionality
8. 🔲 Add analytics tracking

## 📖 Additional Resources

- [Full README](README.md) - Detailed documentation
- [Schema Documentation](SCHEMA.md) - Table relationships and structure
- [Example Queries](example-queries.sql) - Common query patterns
- [Supabase Docs](https://supabase.com/docs)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)

## 🤝 Need Help?

- Check [Supabase Community](https://github.com/supabase/supabase/discussions)
- Review RLS policies in `migrations/20240101000001_row_level_security.sql`
- Test queries in `example-queries.sql`
- Check logs in Supabase Dashboard → Logs
