-- ============================================================================
-- SEED DATA FOR PORTFOLIO WEBSITE
-- This file populates the database with initial data from the static site
-- ============================================================================

-- ============================================================================
-- PROFILES (Initial Admin User)
-- ============================================================================
-- Note: In production, this should be created through Supabase Auth
-- This is a placeholder for seeding purposes

INSERT INTO profiles (id, email, display_name, avatar_url, role) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'tiegomseeraoscar295@gmail.com', 'Oscar Tiego', 'img/hero-bestt.png', 'admin')
ON CONFLICT (email) DO NOTHING;

-- ============================================================================
-- SITE CONTENT (Hero & About Sections)
-- ============================================================================

INSERT INTO site_content (key, content_type, value, description) VALUES
    -- Hero Section
    ('hero_name', 'text', 'Oscar Tiego', 'Main name displayed in hero section'),
    ('hero_title', 'text', 'full-stack dev', 'Subtitle/title in hero section'),
    ('hero_greeting', 'text', 'Hi, I am', 'Greeting text before name'),
    ('hero_image', 'image_url', 'img/hero-bestt.png', 'Hero section profile image'),
    
    -- About Section
    ('about_title', 'text', 'Who I am', 'About section main title'),
    ('about_subtitle', 'text', 'Designer & developer based out of Nairobi', 'About section subtitle'),
    ('about_paragraph_1', 'text', 'I am a web and desktop designer with extreme interests in block chain technologies, cyber security and database programming', 'First paragraph of about section'),
    ('about_paragraph_2', 'text', 'I enjoy learning new frameworks and languages like C# and React. On the side i enjoy playing chess and building things for fun.', 'Second paragraph of about section'),
    ('about_image', 'image_url', 'img/hero-right.png', 'About section image'),
    
    -- Work Section
    ('work_title', 'text', 'My work', 'Work/portfolio section title'),
    ('work_subtitle', 'text', 'A selection of my range of Work', 'Work section subtitle'),
    
    -- Services Section
    ('services_title', 'text', 'What I do', 'Services section title'),
    
    -- Contact/Footer
    ('contact_email', 'text', 'tiegomseeraoscar295@gmail.com', 'Contact email address'),
    ('social_facebook', 'text', 'https://www.facebook.com/oscar.tiego.92/', 'Facebook profile URL'),
    ('social_linkedin', 'text', 'https://www.linkedin.com/in/oscar-tiego-b1b190171', 'LinkedIn profile URL'),
    ('social_twitter', 'text', 'https://twitter.com/py12317', 'Twitter profile URL'),
    ('social_github', 'text', 'https://github.com/Tish254', 'GitHub profile URL')
ON CONFLICT (key) DO NOTHING;

-- ============================================================================
-- SERVICES
-- ============================================================================

INSERT INTO services (title, description, icon, display_order, is_published) VALUES
    (
        'Web Design',
        'I design websites sing productivity tools like Figma, Adobe Illustrator and Adobe XD to ensure the ultimate user expirience',
        'fa-solid fa-globe',
        1,
        true
    ),
    (
        'Web development',
        'I develop websites using Css, Html, Vanilla Javascript, React.js, with Express.js and Node.js',
        'fa-solid fa-wand-magic-sparkles',
        2,
        true
    ),
    (
        'Desktop Development',
        'I make desktop applications using the PyQt python framework for beautiful user interfaces',
        'fa-brands fa-windows',
        3,
        true
    )
ON CONFLICT DO NOTHING;

-- ============================================================================
-- PORTFOLIO PROJECTS
-- ============================================================================

INSERT INTO portfolio_projects (title, slug, description, technologies, live_url, github_url, display_order, is_featured, is_published) VALUES
    (
        'Dukas E-Commerce',
        'dukas-ecommerce',
        'A modern e-commerce platform with shopping cart functionality, product catalog, and responsive design.',
        ARRAY['HTML', 'CSS', 'JavaScript', 'E-Commerce'],
        'https://tish254.github.io/Dukas/',
        'https://tish254.github.io/Dukas/',
        1,
        true,
        true
    ),
    (
        'Zebraz E-learning',
        'zebraz-elearning',
        'An interactive e-learning platform designed for online education with course management and student tracking features.',
        ARRAY['HTML', 'CSS', 'JavaScript', 'Education'],
        'https://tish254.github.io/Zebraz/',
        'https://tish254.github.io/Zebraz/',
        2,
        true,
        true
    ),
    (
        'Akan Name Generator',
        'akan-name-generator',
        'A cultural web application that generates Akan names based on birthdate and gender, celebrating Ghanaian naming traditions.',
        ARRAY['HTML', 'CSS', 'JavaScript', 'Cultural'],
        'https://tish254.github.io/akan-name/',
        'https://tish254.github.io/akan-name/',
        3,
        true,
        true
    )
ON CONFLICT (slug) DO NOTHING;

-- ============================================================================
-- PROJECT IMAGES
-- ============================================================================

-- Get project IDs for image association
DO $$
DECLARE
    dukas_id UUID;
    zebraz_id UUID;
    akan_id UUID;
BEGIN
    -- Get project IDs
    SELECT id INTO dukas_id FROM portfolio_projects WHERE slug = 'dukas-ecommerce';
    SELECT id INTO zebraz_id FROM portfolio_projects WHERE slug = 'zebraz-elearning';
    SELECT id INTO akan_id FROM portfolio_projects WHERE slug = 'akan-name-generator';
    
    -- Insert project images
    INSERT INTO project_images (project_id, storage_path, alt_text, is_primary, display_order) VALUES
        (dukas_id, 'img/item1.svg', 'Dukas E-Commerce platform screenshot', true, 1),
        (zebraz_id, 'img/item2.svg', 'Zebraz E-learning platform screenshot', true, 1),
        (akan_id, 'img/item3.svg', 'Akan Name Generator application screenshot', true, 1)
    ON CONFLICT DO NOTHING;
END $$;

-- ============================================================================
-- BLOG TAGS (Sample tags for future blog posts)
-- ============================================================================

INSERT INTO blog_tags (name, slug, description) VALUES
    ('Web Development', 'web-development', 'Articles about web development techniques and best practices'),
    ('JavaScript', 'javascript', 'JavaScript programming tips and tutorials'),
    ('React', 'react', 'React.js framework tutorials and guides'),
    ('Node.js', 'nodejs', 'Backend development with Node.js'),
    ('CSS', 'css', 'CSS styling techniques and modern approaches'),
    ('Python', 'python', 'Python programming and desktop development'),
    ('Database', 'database', 'Database design and management'),
    ('Blockchain', 'blockchain', 'Blockchain technologies and applications'),
    ('Cybersecurity', 'cybersecurity', 'Security best practices and tips'),
    ('Tutorial', 'tutorial', 'Step-by-step guides and tutorials')
ON CONFLICT (slug) DO NOTHING;

-- ============================================================================
-- SAMPLE BLOG POSTS (Placeholder content)
-- ============================================================================

-- Get admin user ID for blog posts
DO $$
DECLARE
    admin_id UUID;
BEGIN
    SELECT id INTO admin_id FROM profiles WHERE role = 'admin' LIMIT 1;
    
    -- Insert sample blog posts
    INSERT INTO blog_posts (title, slug, excerpt, content, status, published_at, author_id) VALUES
        (
            'Building Modern E-Commerce Platforms',
            'building-modern-ecommerce-platforms',
            'A comprehensive guide to creating scalable e-commerce solutions using modern web technologies.',
            '<p>Building an e-commerce platform requires careful consideration of user experience, performance, and security. In this article, I''ll share my experience building the Dukas E-Commerce platform.</p><h2>Key Features</h2><p>A modern e-commerce platform should include product catalogs, shopping cart functionality, secure checkout processes, and responsive design for mobile users.</p><h2>Technologies Used</h2><p>I utilized HTML5, CSS3, and JavaScript to create an intuitive shopping experience. The platform features dynamic product filtering, real-time cart updates, and smooth animations.</p><h2>Lessons Learned</h2><p>Performance optimization is crucial for e-commerce sites. Users expect fast loading times and smooth interactions, especially on mobile devices.</p>',
            'published',
            NOW() - INTERVAL '30 days',
            admin_id
        ),
        (
            'Creating Interactive E-Learning Experiences',
            'creating-interactive-elearning-experiences',
            'Discover how to build engaging online education platforms that keep students motivated and learning.',
            '<p>E-learning platforms are transforming education by making quality content accessible to everyone. The Zebraz E-learning platform demonstrates how interactive design can enhance the learning experience.</p><h2>Design Principles</h2><p>Effective e-learning requires clear navigation, engaging content presentation, and progress tracking features. Students need to feel accomplished as they advance through courses.</p><h2>Interactive Elements</h2><p>I incorporated interactive quizzes, progress bars, and achievement badges to keep learners engaged. Visual feedback is crucial for maintaining motivation.</p><h2>Future Enhancements</h2><p>Future versions could include video lessons, real-time collaboration features, and adaptive learning paths based on student performance.</p>',
            'published',
            NOW() - INTERVAL '15 days',
            admin_id
        ),
        (
            'Exploring Cultural Heritage Through Code',
            'exploring-cultural-heritage-through-code',
            'How the Akan Name Generator project combines programming with cultural appreciation.',
            '<p>The Akan Name Generator celebrates Ghanaian naming traditions by allowing users to discover their Akan name based on their birthdate and gender.</p><h2>Cultural Background</h2><p>The Akan people of Ghana have a rich tradition of naming children based on the day of the week they were born. Each day has specific names for males and females, reflecting the spiritual significance of birth timing.</p><h2>Technical Implementation</h2><p>The application uses JavaScript to calculate the day of the week from a given date and matches it with the corresponding Akan name. The interface features colorful, culturally-inspired design elements.</p><h2>Impact</h2><p>This project demonstrates how technology can preserve and share cultural traditions with a global audience.</p>',
            'published',
            NOW() - INTERVAL '7 days',
            admin_id
        ),
        (
            'Getting Started with React and Node.js',
            'getting-started-react-nodejs',
            'A beginner-friendly introduction to building full-stack applications with React and Node.js.',
            '<p>React and Node.js together form a powerful stack for building modern web applications. This guide will help you get started with full-stack JavaScript development.</p><h2>Why React?</h2><p>React''s component-based architecture makes it easy to build reusable UI elements and manage application state effectively.</p><h2>Why Node.js?</h2><p>Node.js allows you to use JavaScript on the backend, enabling true full-stack JavaScript development and code sharing between frontend and backend.</p><h2>Next Steps</h2><p>Start with simple projects and gradually increase complexity. Practice is key to mastering these technologies.</p>',
            'draft',
            NULL,
            admin_id
        )
    ON CONFLICT (slug) DO NOTHING;
    
    -- Associate tags with blog posts
    INSERT INTO blog_post_tags (blog_post_id, blog_tag_id)
    SELECT 
        bp.id,
        bt.id
    FROM blog_posts bp
    CROSS JOIN blog_tags bt
    WHERE 
        (bp.slug = 'building-modern-ecommerce-platforms' AND bt.slug IN ('web-development', 'javascript', 'tutorial')) OR
        (bp.slug = 'creating-interactive-elearning-experiences' AND bt.slug IN ('web-development', 'javascript', 'tutorial')) OR
        (bp.slug = 'exploring-cultural-heritage-through-code' AND bt.slug IN ('javascript', 'tutorial')) OR
        (bp.slug = 'getting-started-react-nodejs' AND bt.slug IN ('web-development', 'javascript', 'react', 'nodejs', 'tutorial'))
    ON CONFLICT DO NOTHING;
    
END $$;

-- ============================================================================
-- MEDIA ENTRIES (Reference existing static assets)
-- ============================================================================

DO $$
DECLARE
    admin_id UUID;
BEGIN
    SELECT id INTO admin_id FROM profiles WHERE role = 'admin' LIMIT 1;
    
    INSERT INTO media (storage_path, file_name, mime_type, alt_text, uploaded_by) VALUES
        ('img/hero-bestt.png', 'hero-bestt.png', 'image/png', 'Oscar Tiego profile photo', admin_id),
        ('img/hero-right.png', 'hero-right.png', 'image/png', 'Oscar Tiego about section photo', admin_id),
        ('img/dev-tish.png', 'dev-tish.png', 'image/png', 'DevTish logo', admin_id),
        ('img/item1.svg', 'item1.svg', 'image/svg+xml', 'Dukas E-Commerce project thumbnail', admin_id),
        ('img/item2.svg', 'item2.svg', 'image/svg+xml', 'Zebraz E-learning project thumbnail', admin_id),
        ('img/item3.svg', 'item3.svg', 'image/svg+xml', 'Akan Name Generator project thumbnail', admin_id)
    ON CONFLICT DO NOTHING;
END $$;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================
-- Uncomment these to verify the seed data after running:
--
-- SELECT COUNT(*) as profile_count FROM profiles;
-- SELECT COUNT(*) as services_count FROM services;
-- SELECT COUNT(*) as projects_count FROM portfolio_projects;
-- SELECT COUNT(*) as blog_posts_count FROM blog_posts;
-- SELECT COUNT(*) as blog_tags_count FROM blog_tags;
-- SELECT COUNT(*) as site_content_count FROM site_content;
-- SELECT COUNT(*) as media_count FROM media;
