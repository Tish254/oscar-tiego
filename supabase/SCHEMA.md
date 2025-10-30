# Database Schema Documentation

## Entity Relationship Diagram (Text Format)

```
┌─────────────────┐
│    profiles     │
├─────────────────┤
│ id (PK)         │
│ email           │◄────────┐
│ display_name    │         │
│ avatar_url      │         │
│ role            │         │
│ created_at      │         │
│ updated_at      │         │
└─────────────────┘         │
                            │
                            │ (author_id)
┌─────────────────┐         │
│   blog_posts    │         │
├─────────────────┤         │
│ id (PK)         │         │
│ title           │         │
│ slug (UNIQUE)   │         │
│ excerpt         │         │
│ content         │         │
│ status          │         │
│ published_at    │         │
│ author_id (FK)  ├─────────┘
│ featured_img_id │─────────┐
│ view_count      │         │
│ created_at      │         │
│ updated_at      │         │
└─────────────────┘         │
        │                   │
        │                   │
        │ (blog_post_id)    │
        │                   │
        ▼                   │
┌─────────────────┐         │
│ blog_post_tags  │         │
├─────────────────┤         │
│blog_post_id(PK) │         │
│blog_tag_id (PK) │─────┐   │
│ created_at      │     │   │
└─────────────────┘     │   │
                        │   │
                        │   │ (blog_tag_id)
┌─────────────────┐     │   │
│   blog_tags     │     │   │
├─────────────────┤     │   │
│ id (PK)         │◄────┘   │
│ name (UNIQUE)   │         │
│ slug (UNIQUE)   │         │
│ description     │         │
│ created_at      │         │
└─────────────────┘         │
                            │
                            │
┌─────────────────┐         │
│     media       │         │
├─────────────────┤         │
│ id (PK)         │◄────────┘
│ storage_path    │
│ file_name       │
│ mime_type       │
│ file_size       │
│ alt_text        │
│ caption         │
│ uploaded_by(FK) │───┐
│ created_at      │   │
│ updated_at      │   │
└─────────────────┘   │
                      │
                      └───► profiles

┌──────────────────────┐
│ portfolio_projects   │
├──────────────────────┤
│ id (PK)              │
│ title                │
│ slug (UNIQUE)        │
│ description          │
│ technologies[]       │
│ live_url             │
│ github_url           │
│ display_order        │
│ is_featured          │
│ is_published         │
│ created_at           │
│ updated_at           │
└──────────────────────┘
            │
            │ (project_id)
            ▼
┌──────────────────────┐
│  project_images      │
├──────────────────────┤
│ id (PK)              │
│ project_id (FK)      │
│ storage_path         │
│ alt_text             │
│ is_primary           │
│ display_order        │
│ created_at           │
└──────────────────────┘

┌──────────────────────┐
│     services         │
├──────────────────────┤
│ id (PK)              │
│ title                │
│ description          │
│ icon                 │
│ display_order        │
│ is_published         │
│ created_at           │
│ updated_at           │
└──────────────────────┘

┌──────────────────────┐
│   site_content       │
├──────────────────────┤
│ id (PK)              │
│ key (UNIQUE)         │
│ content_type         │
│ value                │
│ description          │
│ created_at           │
│ updated_at           │
└──────────────────────┘
```

## Table Details

### profiles

**Purpose**: User accounts and author information

| Column       | Type        | Constraints                | Description                       |
| ------------ | ----------- | -------------------------- | --------------------------------- |
| id           | UUID        | PRIMARY KEY                | Unique identifier                 |
| email        | TEXT        | UNIQUE, NOT NULL           | User email address                |
| display_name | TEXT        | NOT NULL                   | Public display name               |
| avatar_url   | TEXT        | NULL                       | Profile image URL                 |
| role         | user_role   | NOT NULL, DEFAULT 'viewer' | Access role (admin/editor/viewer) |
| created_at   | TIMESTAMPTZ | NOT NULL, DEFAULT NOW()    | Account creation time             |
| updated_at   | TIMESTAMPTZ | NOT NULL, DEFAULT NOW()    | Last update time                  |

**Indexes**: email, role

**RLS**:

- Public can view all profiles (for author attribution)
- Admins have full CRUD access

---

### blog_posts

**Purpose**: Blog content with publishing workflow

| Column            | Type        | Constraints                | Description              |
| ----------------- | ----------- | -------------------------- | ------------------------ |
| id                | UUID        | PRIMARY KEY                | Unique identifier        |
| title             | TEXT        | NOT NULL                   | Post title               |
| slug              | TEXT        | UNIQUE, NOT NULL           | URL-friendly identifier  |
| excerpt           | TEXT        | NULL                       | Short summary            |
| content           | TEXT        | NOT NULL                   | Full post content (HTML) |
| status            | blog_status | NOT NULL, DEFAULT 'draft'  | Publishing status        |
| published_at      | TIMESTAMPTZ | NULL                       | Publication date/time    |
| author_id         | UUID        | NOT NULL, FK → profiles.id | Post author              |
| featured_image_id | UUID        | NULL, FK → media.id        | Featured image           |
| view_count        | INTEGER     | NOT NULL, DEFAULT 0        | Page views               |
| created_at        | TIMESTAMPTZ | NOT NULL, DEFAULT NOW()    | Creation time            |
| updated_at        | TIMESTAMPTZ | NOT NULL, DEFAULT NOW()    | Last update time         |

**Indexes**: slug (unique), status, author_id, published_at, (status, published_at)

**RLS**:

- Public can view posts with status='published' AND published_at <= NOW()
- Admins can view and edit all posts

---

### blog_tags

**Purpose**: Tags for categorizing blog posts

| Column      | Type        | Constraints             | Description             |
| ----------- | ----------- | ----------------------- | ----------------------- |
| id          | UUID        | PRIMARY KEY             | Unique identifier       |
| name        | TEXT        | UNIQUE, NOT NULL        | Display name            |
| slug        | TEXT        | UNIQUE, NOT NULL        | URL-friendly identifier |
| description | TEXT        | NULL                    | Tag description         |
| created_at  | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Creation time           |

**Indexes**: slug (unique)

**RLS**:

- Public can view all tags
- Admins have full CRUD access

---

### blog_post_tags

**Purpose**: Many-to-many relationship between posts and tags

| Column       | Type        | Constraints                  | Description      |
| ------------ | ----------- | ---------------------------- | ---------------- |
| blog_post_id | UUID        | NOT NULL, FK → blog_posts.id | Post reference   |
| blog_tag_id  | UUID        | NOT NULL, FK → blog_tags.id  | Tag reference    |
| created_at   | TIMESTAMPTZ | NOT NULL, DEFAULT NOW()      | Association time |

**Composite Primary Key**: (blog_post_id, blog_tag_id)

**Indexes**: blog_post_id, blog_tag_id

**RLS**:

- Public can view all associations
- Admins have full CRUD access

---

### media

**Purpose**: Centralized metadata for uploaded media files

| Column       | Type        | Constraints             | Description            |
| ------------ | ----------- | ----------------------- | ---------------------- |
| id           | UUID        | PRIMARY KEY             | Unique identifier      |
| storage_path | TEXT        | NOT NULL                | Path in storage bucket |
| file_name    | TEXT        | NOT NULL                | Original filename      |
| mime_type    | TEXT        | NOT NULL                | File MIME type         |
| file_size    | INTEGER     | NULL                    | File size in bytes     |
| alt_text     | TEXT        | NULL                    | Accessibility text     |
| caption      | TEXT        | NULL                    | Display caption        |
| uploaded_by  | UUID        | NULL, FK → profiles.id  | Uploader               |
| created_at   | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Upload time            |
| updated_at   | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Last update time       |

**Indexes**: storage_path, uploaded_by

**RLS**:

- Public can view all media metadata
- Admins have full CRUD access

---

### portfolio_projects

**Purpose**: Portfolio project showcases

| Column        | Type        | Constraints             | Description             |
| ------------- | ----------- | ----------------------- | ----------------------- |
| id            | UUID        | PRIMARY KEY             | Unique identifier       |
| title         | TEXT        | NOT NULL                | Project title           |
| slug          | TEXT        | UNIQUE, NOT NULL        | URL-friendly identifier |
| description   | TEXT        | NOT NULL                | Project description     |
| technologies  | TEXT[]      | NOT NULL, DEFAULT '{}'  | Technology stack        |
| live_url      | TEXT        | NULL                    | Live demo URL           |
| github_url    | TEXT        | NULL                    | Source code URL         |
| display_order | INTEGER     | NOT NULL, DEFAULT 0     | Display position        |
| is_featured   | BOOLEAN     | NOT NULL, DEFAULT false | Featured flag           |
| is_published  | BOOLEAN     | NOT NULL, DEFAULT true  | Visibility flag         |
| created_at    | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Creation time           |
| updated_at    | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Last update time        |

**Indexes**: slug (unique), display_order, is_published, is_featured

**RLS**:

- Public can view projects with is_published=true
- Admins can view and edit all projects

---

### project_images

**Purpose**: Images associated with portfolio projects

| Column        | Type        | Constraints                          | Description        |
| ------------- | ----------- | ------------------------------------ | ------------------ |
| id            | UUID        | PRIMARY KEY                          | Unique identifier  |
| project_id    | UUID        | NOT NULL, FK → portfolio_projects.id | Parent project     |
| storage_path  | TEXT        | NOT NULL                             | Image path         |
| alt_text      | TEXT        | NULL                                 | Accessibility text |
| is_primary    | BOOLEAN     | NOT NULL, DEFAULT false              | Primary image flag |
| display_order | INTEGER     | NOT NULL, DEFAULT 0                  | Display position   |
| created_at    | TIMESTAMPTZ | NOT NULL, DEFAULT NOW()              | Creation time      |

**Indexes**: project_id, is_primary, display_order

**RLS**:

- Public can view all project images
- Admins have full CRUD access

---

### services

**Purpose**: Service offerings displayed on the site

| Column        | Type        | Constraints             | Description             |
| ------------- | ----------- | ----------------------- | ----------------------- |
| id            | UUID        | PRIMARY KEY             | Unique identifier       |
| title         | TEXT        | NOT NULL                | Service title           |
| description   | TEXT        | NOT NULL                | Service description     |
| icon          | TEXT        | NOT NULL                | Font Awesome icon class |
| display_order | INTEGER     | NOT NULL, DEFAULT 0     | Display position        |
| is_published  | BOOLEAN     | NOT NULL, DEFAULT true  | Visibility flag         |
| created_at    | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Creation time           |
| updated_at    | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Last update time        |

**Indexes**: display_order, is_published

**RLS**:

- Public can view services with is_published=true
- Admins can view and edit all services

---

### site_content

**Purpose**: Key-value store for dynamic site content

| Column       | Type        | Constraints             | Description                          |
| ------------ | ----------- | ----------------------- | ------------------------------------ |
| id           | UUID        | PRIMARY KEY             | Unique identifier                    |
| key          | TEXT        | UNIQUE, NOT NULL        | Content key                          |
| content_type | TEXT        | NOT NULL                | Data type (text/html/json/image_url) |
| value        | TEXT        | NOT NULL                | Content value                        |
| description  | TEXT        | NULL                    | Usage description                    |
| created_at   | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Creation time                        |
| updated_at   | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Last update time                     |

**Indexes**: key (unique)

**RLS**:

- Public can view all site content
- Admins have full CRUD access

---

## Custom Types

### user_role (ENUM)

- `admin` - Full access to all content and user management
- `editor` - Can create and edit content (future use)
- `viewer` - Read-only access (future use)

### blog_status (ENUM)

- `draft` - Not published, only visible to admins
- `published` - Published and visible to public
- `archived` - Removed from public view but preserved

---

## Key Relationships

1. **profiles → blog_posts**: One-to-Many
   - One author can write many blog posts
   - Cascade delete: Deleting a profile deletes their posts

2. **blog_posts ↔ blog_tags**: Many-to-Many (via blog_post_tags)
   - One post can have many tags
   - One tag can be on many posts

3. **profiles → media**: One-to-Many
   - One user can upload many media files
   - Set NULL on delete: Keep media if uploader is deleted

4. **blog_posts → media**: Many-to-One (featured image)
   - Many posts can reference the same image
   - Set NULL on delete: Keep post if image is deleted

5. **portfolio_projects → project_images**: One-to-Many
   - One project can have many images
   - Cascade delete: Deleting a project deletes its images

---

## Indexes Strategy

### Unique Indexes

- All `slug` fields for URL routing
- `profiles.email` for authentication
- `blog_tags.name` for tag management
- `site_content.key` for content lookup

### Query Optimization Indexes

- `blog_posts.status` - Filter published posts
- `blog_posts.published_at` - Order by date
- `blog_posts.(status, published_at)` - Composite for published post queries
- `portfolio_projects.display_order` - Order projects
- `services.display_order` - Order services
- `project_images.display_order` - Order images

### Foreign Key Indexes

- All foreign key columns have indexes for join performance

---

## Row Level Security Overview

### Public Access (Unauthenticated Users)

✅ Read published blog posts (status='published' AND published_at <= NOW())
✅ Read published portfolio projects (is_published=true)
✅ Read published services (is_published=true)
✅ Read all site content
✅ Read all tags and media metadata
✅ Read public profiles

❌ Cannot create, update, or delete any content
❌ Cannot view unpublished/draft content

### Admin Access (role='admin')

✅ Full CRUD on all tables
✅ Can view unpublished/draft content
✅ Can manage users and roles

### Security Notes

- All policies check `auth.uid()` from Supabase Auth context
- Service role bypasses RLS entirely (for migrations, backend jobs)
- No privilege escalation possible without admin role assignment
- Foreign key constraints use CASCADE/SET NULL to prevent orphaned data

---

## Performance Considerations

1. **Indexes**: All frequently queried columns are indexed
2. **Array Types**: `technologies[]` in portfolio_projects allows efficient storage
3. **Timestamps**: All tables have created_at, most have updated_at
4. **Triggers**: `updated_at` automatically updated via trigger function
5. **Soft Deletes**: Use `is_published` flags instead of deleting content
6. **View Counts**: Tracked in database for analytics

---

## Migration Strategy

Migrations are applied in order by timestamp:

1. `20240101000000_initial_schema.sql` - Tables, indexes, triggers
2. `20240101000001_row_level_security.sql` - RLS policies
3. Future migrations as needed

Each migration is idempotent where possible (CREATE IF NOT EXISTS, etc.)

---

## Backup & Recovery

### Recommended Backup Strategy

- Daily automated backups via Supabase
- Weekly manual exports for critical data
- Point-in-time recovery available with Supabase Pro

### Critical Tables (Priority Order)

1. `blog_posts` - Content
2. `site_content` - Site configuration
3. `portfolio_projects` - Portfolio data
4. `profiles` - User accounts
5. `media` - Asset metadata
6. Supporting tables (tags, images, services)

---

## Future Enhancements

- Full-text search on blog posts (PostgreSQL tsvector)
- Comments system (new table: blog_comments)
- Analytics table for detailed tracking
- Draft versioning system
- Scheduled publishing (cron jobs)
- Multi-language support (i18n table)
- API rate limiting (usage tracking table)
