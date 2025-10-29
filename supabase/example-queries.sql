-- ============================================================================
-- EXAMPLE QUERIES FOR PORTFOLIO DATABASE
-- This file contains useful queries for working with the database
-- ============================================================================

-- ============================================================================
-- READING DATA (Public-facing queries)
-- ============================================================================

-- Get all published blog posts with author and tags
SELECT 
    bp.id,
    bp.title,
    bp.slug,
    bp.excerpt,
    bp.content,
    bp.published_at,
    bp.view_count,
    p.display_name as author_name,
    p.avatar_url as author_avatar,
    ARRAY_AGG(bt.name) as tags
FROM blog_posts bp
JOIN profiles p ON bp.author_id = p.id
LEFT JOIN blog_post_tags bpt ON bp.id = bpt.blog_post_id
LEFT JOIN blog_tags bt ON bpt.blog_tag_id = bt.id
WHERE bp.status = 'published' 
    AND bp.published_at <= NOW()
GROUP BY bp.id, p.display_name, p.avatar_url
ORDER BY bp.published_at DESC;

-- Get a single blog post by slug
SELECT 
    bp.*,
    p.display_name as author_name,
    p.avatar_url as author_avatar,
    m.storage_path as featured_image_path,
    m.alt_text as featured_image_alt
FROM blog_posts bp
JOIN profiles p ON bp.author_id = p.id
LEFT JOIN media m ON bp.featured_image_id = m.id
WHERE bp.slug = 'building-modern-ecommerce-platforms'
    AND bp.status = 'published';

-- Get all tags with post counts
SELECT 
    bt.id,
    bt.name,
    bt.slug,
    COUNT(bpt.blog_post_id) as post_count
FROM blog_tags bt
LEFT JOIN blog_post_tags bpt ON bt.id = bpt.blog_tag_id
GROUP BY bt.id
ORDER BY post_count DESC, bt.name;

-- Get all published portfolio projects with primary images
SELECT 
    pp.*,
    pi.storage_path as primary_image,
    pi.alt_text as primary_image_alt
FROM portfolio_projects pp
LEFT JOIN project_images pi ON pp.id = pi.project_id AND pi.is_primary = true
WHERE pp.is_published = true
ORDER BY pp.display_order ASC;

-- Get a single project with all images
SELECT 
    pp.*,
    json_agg(
        json_build_object(
            'id', pi.id,
            'storage_path', pi.storage_path,
            'alt_text', pi.alt_text,
            'is_primary', pi.is_primary,
            'display_order', pi.display_order
        ) ORDER BY pi.display_order
    ) as images
FROM portfolio_projects pp
LEFT JOIN project_images pi ON pp.id = pi.project_id
WHERE pp.slug = 'dukas-ecommerce'
GROUP BY pp.id;

-- Get all published services
SELECT *
FROM services
WHERE is_published = true
ORDER BY display_order ASC;

-- Get site content (all key-value pairs)
SELECT key, value, content_type
FROM site_content
ORDER BY key;

-- Get specific site content values
SELECT 
    MAX(CASE WHEN key = 'hero_name' THEN value END) as hero_name,
    MAX(CASE WHEN key = 'hero_title' THEN value END) as hero_title,
    MAX(CASE WHEN key = 'hero_greeting' THEN value END) as hero_greeting,
    MAX(CASE WHEN key = 'about_title' THEN value END) as about_title,
    MAX(CASE WHEN key = 'about_subtitle' THEN value END) as about_subtitle
FROM site_content;

-- ============================================================================
-- BLOG POST SEARCH & FILTERING
-- ============================================================================

-- Search blog posts by keyword (title or content)
SELECT 
    id, title, slug, excerpt, published_at
FROM blog_posts
WHERE (title ILIKE '%react%' OR content ILIKE '%react%')
    AND status = 'published'
    AND published_at <= NOW()
ORDER BY published_at DESC;

-- Get blog posts by tag
SELECT 
    bp.id,
    bp.title,
    bp.slug,
    bp.excerpt,
    bp.published_at
FROM blog_posts bp
JOIN blog_post_tags bpt ON bp.id = bpt.blog_post_id
JOIN blog_tags bt ON bpt.blog_tag_id = bt.id
WHERE bt.slug = 'javascript'
    AND bp.status = 'published'
ORDER BY bp.published_at DESC;

-- Get recent blog posts (last 5)
SELECT title, slug, excerpt, published_at
FROM blog_posts
WHERE status = 'published'
    AND published_at <= NOW()
ORDER BY published_at DESC
LIMIT 5;

-- Get featured/popular blog posts (by view count)
SELECT title, slug, excerpt, view_count
FROM blog_posts
WHERE status = 'published'
ORDER BY view_count DESC
LIMIT 10;

-- ============================================================================
-- ADMIN QUERIES (Full access)
-- ============================================================================

-- Get all blog posts (including drafts)
SELECT 
    bp.id,
    bp.title,
    bp.status,
    bp.published_at,
    bp.created_at,
    bp.updated_at,
    p.display_name as author
FROM blog_posts bp
JOIN profiles p ON bp.author_id = p.id
ORDER BY bp.updated_at DESC;

-- Get draft posts
SELECT title, slug, status, updated_at
FROM blog_posts
WHERE status = 'draft'
ORDER BY updated_at DESC;

-- Get unpublished projects
SELECT title, slug, is_published, updated_at
FROM portfolio_projects
WHERE is_published = false
ORDER BY updated_at DESC;

-- ============================================================================
-- STATISTICS & ANALYTICS
-- ============================================================================

-- Blog post statistics
SELECT 
    COUNT(*) as total_posts,
    COUNT(*) FILTER (WHERE status = 'published') as published_posts,
    COUNT(*) FILTER (WHERE status = 'draft') as draft_posts,
    SUM(view_count) as total_views,
    AVG(view_count) as avg_views_per_post
FROM blog_posts;

-- Most popular tags
SELECT 
    bt.name,
    COUNT(bpt.blog_post_id) as post_count
FROM blog_tags bt
JOIN blog_post_tags bpt ON bt.id = bpt.blog_tag_id
JOIN blog_posts bp ON bpt.blog_post_id = bp.id
WHERE bp.status = 'published'
GROUP BY bt.name
ORDER BY post_count DESC;

-- Posts per author
SELECT 
    p.display_name,
    COUNT(bp.id) as post_count,
    SUM(bp.view_count) as total_views
FROM profiles p
LEFT JOIN blog_posts bp ON p.id = bp.author_id
GROUP BY p.id, p.display_name
ORDER BY post_count DESC;

-- ============================================================================
-- CONTENT MANAGEMENT (INSERT/UPDATE/DELETE)
-- ============================================================================

-- Insert a new blog post (draft)
-- INSERT INTO blog_posts (title, slug, excerpt, content, status, author_id)
-- VALUES (
--     'My New Blog Post',
--     'my-new-blog-post',
--     'A brief excerpt about the post',
--     '<p>Full content goes here</p>',
--     'draft',
--     (SELECT id FROM profiles WHERE role = 'admin' LIMIT 1)
-- );

-- Publish a blog post
-- UPDATE blog_posts
-- SET status = 'published',
--     published_at = NOW()
-- WHERE slug = 'my-new-blog-post';

-- Increment view count
-- UPDATE blog_posts
-- SET view_count = view_count + 1
-- WHERE slug = 'building-modern-ecommerce-platforms';

-- Add tags to a blog post
-- INSERT INTO blog_post_tags (blog_post_id, blog_tag_id)
-- SELECT 
--     (SELECT id FROM blog_posts WHERE slug = 'my-new-blog-post'),
--     id
-- FROM blog_tags
-- WHERE slug IN ('javascript', 'tutorial');

-- Update site content
-- UPDATE site_content
-- SET value = 'Updated value here'
-- WHERE key = 'hero_title';

-- Insert new service
-- INSERT INTO services (title, description, icon, display_order)
-- VALUES (
--     'API Development',
--     'Building robust RESTful APIs with Node.js and Express',
--     'fa-solid fa-server',
--     4
-- );

-- Update project display order
-- UPDATE portfolio_projects
-- SET display_order = 1
-- WHERE slug = 'zebraz-elearning';

-- ============================================================================
-- MAINTENANCE & CLEANUP
-- ============================================================================

-- Find orphaned media (not referenced by any content)
SELECT m.*
FROM media m
LEFT JOIN blog_posts bp ON m.id = bp.featured_image_id
LEFT JOIN project_images pi ON m.storage_path = pi.storage_path
WHERE bp.id IS NULL AND pi.id IS NULL;

-- Find blog posts without tags
SELECT bp.title, bp.slug
FROM blog_posts bp
LEFT JOIN blog_post_tags bpt ON bp.id = bpt.blog_post_id
WHERE bpt.blog_tag_id IS NULL
    AND bp.status = 'published';

-- Find projects without images
SELECT pp.title, pp.slug
FROM portfolio_projects pp
LEFT JOIN project_images pi ON pp.id = pi.project_id
WHERE pi.id IS NULL;

-- ============================================================================
-- TESTING RLS POLICIES
-- ============================================================================

-- Test public access (should only see published content)
-- SET ROLE anon;
-- SELECT title, status FROM blog_posts;
-- RESET ROLE;

-- Test admin access (should see all content)
-- This requires actual Supabase Auth context in practice
-- The policies check auth.uid() which is set by Supabase

-- ============================================================================
-- USEFUL FUNCTIONS
-- ============================================================================

-- Function to get full blog post data (post, author, tags, featured image)
CREATE OR REPLACE FUNCTION get_blog_post_full(post_slug TEXT)
RETURNS JSON AS $$
    SELECT json_build_object(
        'post', row_to_json(bp.*),
        'author', json_build_object(
            'name', p.display_name,
            'avatar', p.avatar_url
        ),
        'tags', COALESCE(
            json_agg(DISTINCT bt.name) FILTER (WHERE bt.id IS NOT NULL),
            '[]'
        ),
        'featured_image', CASE 
            WHEN m.id IS NOT NULL THEN json_build_object(
                'path', m.storage_path,
                'alt', m.alt_text
            )
            ELSE NULL
        END
    )
    FROM blog_posts bp
    JOIN profiles p ON bp.author_id = p.id
    LEFT JOIN blog_post_tags bpt ON bp.id = bpt.blog_post_id
    LEFT JOIN blog_tags bt ON bpt.blog_tag_id = bt.id
    LEFT JOIN media m ON bp.featured_image_id = m.id
    WHERE bp.slug = post_slug
        AND bp.status = 'published'
    GROUP BY bp.id, p.display_name, p.avatar_url, m.id, m.storage_path, m.alt_text;
$$ LANGUAGE SQL STABLE;

-- Usage: SELECT get_blog_post_full('building-modern-ecommerce-platforms');
