# Schema Changelog

All notable changes to the database schema will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to timestamp-based migration versioning.

## [Initial Release] - 2024-01-01

### Added - Migration 20240101000000_initial_schema.sql

#### Tables

- `profiles` - User accounts with role-based access (admin, editor, viewer)
- `media` - Centralized metadata for uploaded media files
- `blog_tags` - Tags for categorizing blog posts
- `blog_posts` - Blog content with publishing workflow (draft, published, archived)
- `blog_post_tags` - Many-to-many join table for posts and tags
- `portfolio_projects` - Portfolio project showcases with technologies array
- `project_images` - Images associated with portfolio projects
- `services` - Service offerings with display ordering
- `site_content` - Key-value store for dynamic content (hero, about, etc.)

#### Enums

- `user_role` - admin, editor, viewer
- `blog_status` - draft, published, archived

#### Indexes

- **Unique indexes**: All slug fields, profiles.email, site_content.key, blog_tags.name
- **Performance indexes**:
  - blog_posts: status, published_at, author_id, (status, published_at) composite
  - portfolio_projects: display_order, is_published, is_featured
  - services: display_order, is_published
  - project_images: project_id, is_primary, display_order
  - Various foreign key indexes for join performance

#### Triggers

- `update_updated_at_column()` function to automatically update timestamps
- Triggers on: profiles, media, blog_posts, portfolio_projects, services, site_content

### Added - Migration 20240101000001_row_level_security.sql

#### Row Level Security

- Enabled RLS on all 9 tables
- 36 policies total across all tables

#### Public Read Policies

- Published blog posts (`status='published'` AND `published_at <= NOW()`)
- Published portfolio projects (`is_published=true`)
- Published services (`is_published=true`)
- All site content, tags, media metadata, and public profiles

#### Admin Policies

- Full CRUD access for users with `role='admin'`
- Can view unpublished/draft content
- Can manage all users and roles

#### Security Features

- All policies use `auth.uid()` for user identification
- Service role bypasses RLS (for migrations and backend operations)
- No privilege escalation possible without admin role
- Foreign keys use CASCADE/SET NULL to prevent orphaned records

### Seed Data

#### Profiles

- 1 admin user (Oscar Tiego)

#### Site Content

- 19 entries covering hero, about, work, services, and contact sections

#### Services

- 3 services: Web Design, Web Development, Desktop Development

#### Portfolio Projects

- 3 projects: Dukas E-Commerce, Zebraz E-learning, Akan Name Generator
- 3 project images (one per project)

#### Blog System

- 10 blog tags covering common topics
- 4 blog posts (3 published, 1 draft)
- Tag associations for all posts

#### Media

- 6 media entries referencing existing static assets

## Migration Guidelines

### Creating New Migrations

Use the helper script:

```bash
./supabase/new-migration.sh feature_name
```

### Naming Convention

Format: `YYYYMMDDHHmmss_description.sql`

Example: `20240201143000_add_comments_table.sql`

### Migration Best Practices

1. **Idempotent Operations**: Use `IF EXISTS` / `IF NOT EXISTS` where possible
2. **Rollback Instructions**: Document how to undo changes in comments
3. **Test Locally**: Always test on local database before production
4. **Backward Compatible**: Avoid breaking existing queries when possible
5. **Index Strategy**: Add indexes for new filterable/sortable columns
6. **RLS Policies**: Add policies for any new tables immediately

### Breaking Changes

If a migration contains breaking changes, document them here:

#### None Yet

No breaking changes in initial release.

## Future Enhancements

### Planned

- [ ] Full-text search on blog posts (tsvector)
- [ ] Comments system
- [ ] Blog post versioning
- [ ] Multi-language support (i18n)
- [ ] Analytics tracking table
- [ ] Newsletter subscriptions

### Under Consideration

- [ ] Draft autosave functionality
- [ ] Scheduled publishing with cron jobs
- [ ] Content categories in addition to tags
- [ ] User preferences table
- [ ] API usage tracking

## Version History

| Version | Date       | Migration      | Description                    |
| ------- | ---------- | -------------- | ------------------------------ |
| 1.0.0   | 2024-01-01 | 20240101000000 | Initial schema with all tables |
| 1.0.0   | 2024-01-01 | 20240101000001 | Row Level Security policies    |

## Support

For migration issues or questions:

1. Check [README.md](README.md) for detailed documentation
2. Review [SCHEMA.md](SCHEMA.md) for table relationships
3. Run [test-schema.sql](test-schema.sql) to verify integrity
4. Check Supabase project logs for errors
5. Use [example-queries.sql](example-queries.sql) for query patterns

## Contributing

When adding migrations:

1. Create feature branch: `git checkout -b feature/your-feature-name`
2. Generate migration: `./supabase/new-migration.sh your_feature_name`
3. Write SQL with proper comments and documentation
4. Test migration locally: `supabase db reset`
5. Update this CHANGELOG.md
6. Update SCHEMA.md if adding tables or relationships
7. Add example queries to example-queries.sql if needed
8. Submit pull request with clear description

## Rollback Procedures

### Full Rollback (⚠️ Destructive)

```sql
-- Drop all tables and start fresh
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
-- Then re-apply migrations
```

### Selective Rollback

Each migration should document its rollback steps in comments.

Example:

```sql
-- To rollback this migration:
-- DROP TABLE IF EXISTS new_table;
-- ALTER TABLE existing_table DROP COLUMN IF EXISTS new_column;
```

---

_Last Updated: 2024-01-01_
