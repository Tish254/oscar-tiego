-- ============================================================================
-- ENABLE ROW LEVEL SECURITY ON ALL TABLES
-- ============================================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE media ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_post_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolio_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_content ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PROFILES POLICIES
-- ============================================================================

-- Public: Anyone can view published profiles (for author attribution)
CREATE POLICY "Public profiles are viewable by everyone"
    ON profiles FOR SELECT
    USING (true);

-- Admin: Can view all profiles
CREATE POLICY "Admins can view all profiles"
    ON profiles FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Admin: Can insert profiles
CREATE POLICY "Admins can insert profiles"
    ON profiles FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Admin: Can update profiles
CREATE POLICY "Admins can update profiles"
    ON profiles FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Admin: Can delete profiles
CREATE POLICY "Admins can delete profiles"
    ON profiles FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- ============================================================================
-- MEDIA POLICIES
-- ============================================================================

-- Public: Anyone can view media
CREATE POLICY "Public media is viewable by everyone"
    ON media FOR SELECT
    USING (true);

-- Admin: Full CRUD on media
CREATE POLICY "Admins can insert media"
    ON media FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can update media"
    ON media FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can delete media"
    ON media FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- ============================================================================
-- BLOG TAGS POLICIES
-- ============================================================================

-- Public: Anyone can view tags
CREATE POLICY "Blog tags are viewable by everyone"
    ON blog_tags FOR SELECT
    USING (true);

-- Admin: Full CRUD on tags
CREATE POLICY "Admins can insert blog tags"
    ON blog_tags FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can update blog tags"
    ON blog_tags FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can delete blog tags"
    ON blog_tags FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- ============================================================================
-- BLOG POSTS POLICIES
-- ============================================================================

-- Public: Anyone can view published blog posts
CREATE POLICY "Published blog posts are viewable by everyone"
    ON blog_posts FOR SELECT
    USING (status = 'published' AND published_at <= NOW());

-- Admin: Can view all blog posts regardless of status
CREATE POLICY "Admins can view all blog posts"
    ON blog_posts FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Admin: Full CRUD on blog posts
CREATE POLICY "Admins can insert blog posts"
    ON blog_posts FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can update blog posts"
    ON blog_posts FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can delete blog posts"
    ON blog_posts FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- ============================================================================
-- BLOG POST TAGS POLICIES
-- ============================================================================

-- Public: Anyone can view blog post tags
CREATE POLICY "Blog post tags are viewable by everyone"
    ON blog_post_tags FOR SELECT
    USING (true);

-- Admin: Full CRUD on blog post tags
CREATE POLICY "Admins can insert blog post tags"
    ON blog_post_tags FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can delete blog post tags"
    ON blog_post_tags FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- ============================================================================
-- PORTFOLIO PROJECTS POLICIES
-- ============================================================================

-- Public: Anyone can view published projects
CREATE POLICY "Published portfolio projects are viewable by everyone"
    ON portfolio_projects FOR SELECT
    USING (is_published = true);

-- Admin: Can view all projects
CREATE POLICY "Admins can view all portfolio projects"
    ON portfolio_projects FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Admin: Full CRUD on portfolio projects
CREATE POLICY "Admins can insert portfolio projects"
    ON portfolio_projects FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can update portfolio projects"
    ON portfolio_projects FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can delete portfolio projects"
    ON portfolio_projects FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- ============================================================================
-- PROJECT IMAGES POLICIES
-- ============================================================================

-- Public: Anyone can view project images
CREATE POLICY "Project images are viewable by everyone"
    ON project_images FOR SELECT
    USING (true);

-- Admin: Full CRUD on project images
CREATE POLICY "Admins can insert project images"
    ON project_images FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can update project images"
    ON project_images FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can delete project images"
    ON project_images FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- ============================================================================
-- SERVICES POLICIES
-- ============================================================================

-- Public: Anyone can view published services
CREATE POLICY "Published services are viewable by everyone"
    ON services FOR SELECT
    USING (is_published = true);

-- Admin: Can view all services
CREATE POLICY "Admins can view all services"
    ON services FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Admin: Full CRUD on services
CREATE POLICY "Admins can insert services"
    ON services FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can update services"
    ON services FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can delete services"
    ON services FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- ============================================================================
-- SITE CONTENT POLICIES
-- ============================================================================

-- Public: Anyone can view site content
CREATE POLICY "Site content is viewable by everyone"
    ON site_content FOR SELECT
    USING (true);

-- Admin: Full CRUD on site content
CREATE POLICY "Admins can insert site content"
    ON site_content FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can update site content"
    ON site_content FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Admins can delete site content"
    ON site_content FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- ============================================================================
-- POLICY NOTES
-- ============================================================================
-- 
-- RLS POLICY RATIONALE:
--
-- 1. PUBLIC READ ACCESS:
--    - All published content (blog posts, projects, services, site content) 
--      is readable by unauthenticated users to enable public portfolio display
--    - Blog posts require status='published' AND published_at <= NOW() to 
--      prevent future-dated posts from showing early
--
-- 2. ADMIN FULL CRUD:
--    - Users with role='admin' in the profiles table have full CRUD access
--    - This allows content management through admin interfaces
--    - Admin check uses EXISTS subquery against profiles table
--
-- 3. SERVICE ROLE:
--    - Service role (used by migrations, backend jobs) bypasses RLS entirely
--    - This allows server-side operations without user context
--
-- 4. SECURITY CONSIDERATIONS:
--    - All policies use the auth.uid() function to identify current user
--    - Policies are additive: multiple matching policies grant access
--    - No user can escalate privileges without admin role
--    - Deleted authors don't break content (CASCADE/SET NULL on foreign keys)
--
