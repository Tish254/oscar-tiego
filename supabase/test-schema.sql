-- ============================================================================
-- SCHEMA TEST SUITE
-- Run this after applying migrations to verify everything works correctly
-- ============================================================================

\echo '=== Testing Schema Structure ==='

-- Test 1: Verify all tables exist
\echo 'Test 1: Checking if all tables exist...'
SELECT 
    CASE 
        WHEN COUNT(*) = 9 THEN '✓ All 9 tables exist'
        ELSE '✗ Missing tables! Expected 9, found ' || COUNT(*)::text
    END as test_result
FROM information_schema.tables 
WHERE table_schema = 'public' 
    AND table_type = 'BASE TABLE'
    AND table_name IN (
        'profiles', 'blog_posts', 'blog_tags', 'blog_post_tags',
        'portfolio_projects', 'project_images', 'services', 
        'site_content', 'media'
    );

-- Test 2: Verify enums exist
\echo 'Test 2: Checking if enums exist...'
SELECT 
    CASE 
        WHEN COUNT(*) = 2 THEN '✓ Both enums exist (user_role, blog_status)'
        ELSE '✗ Missing enums! Expected 2, found ' || COUNT(*)::text
    END as test_result
FROM pg_type 
WHERE typname IN ('user_role', 'blog_status');

-- Test 3: Verify primary keys
\echo 'Test 3: Checking primary keys...'
SELECT 
    table_name,
    CASE 
        WHEN constraint_type = 'PRIMARY KEY' THEN '✓'
        ELSE '✗ Missing PK'
    END as has_primary_key
FROM information_schema.table_constraints
WHERE constraint_type = 'PRIMARY KEY'
    AND table_schema = 'public'
    AND table_name IN (
        'profiles', 'blog_posts', 'blog_tags', 'blog_post_tags',
        'portfolio_projects', 'project_images', 'services', 
        'site_content', 'media'
    )
ORDER BY table_name;

-- Test 4: Verify foreign keys
\echo 'Test 4: Checking foreign key relationships...'
SELECT 
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    '✓' as has_fk
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'public'
ORDER BY tc.table_name, kcu.column_name;

-- Test 5: Verify indexes
\echo 'Test 5: Checking important indexes...'
SELECT 
    tablename,
    indexname,
    '✓' as exists
FROM pg_indexes
WHERE schemaname = 'public'
    AND (
        indexname LIKE 'idx_%' OR
        indexname LIKE '%_pkey' OR
        indexname LIKE '%_key'
    )
ORDER BY tablename, indexname;

-- Test 6: Verify RLS is enabled
\echo 'Test 6: Checking Row Level Security...'
SELECT 
    tablename,
    CASE 
        WHEN rowsecurity THEN '✓ RLS Enabled'
        ELSE '✗ RLS NOT Enabled'
    END as rls_status
FROM pg_tables
WHERE schemaname = 'public'
    AND tablename IN (
        'profiles', 'blog_posts', 'blog_tags', 'blog_post_tags',
        'portfolio_projects', 'project_images', 'services', 
        'site_content', 'media'
    )
ORDER BY tablename;

-- Test 7: Count RLS policies
\echo 'Test 7: Checking RLS policies...'
SELECT 
    schemaname,
    tablename,
    COUNT(*) as policy_count
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY schemaname, tablename
ORDER BY tablename;

-- Test 8: Verify triggers
\echo 'Test 8: Checking triggers...'
SELECT 
    event_object_table as table_name,
    trigger_name,
    '✓' as exists
FROM information_schema.triggers
WHERE trigger_schema = 'public'
    AND trigger_name LIKE '%updated_at%'
ORDER BY event_object_table;

-- ============================================================================
-- DATA INTEGRITY TESTS
-- ============================================================================

\echo ''
\echo '=== Testing Data Integrity (After Seeding) ==='

-- Test 9: Check if seed data was loaded
\echo 'Test 9: Verifying seed data counts...'
SELECT 
    'profiles' as table_name, 
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 1 THEN '✓' ELSE '✗' END as status
FROM profiles
UNION ALL
SELECT 'services', COUNT(*), CASE WHEN COUNT(*) = 3 THEN '✓' ELSE '✗' END FROM services
UNION ALL
SELECT 'portfolio_projects', COUNT(*), CASE WHEN COUNT(*) = 3 THEN '✓' ELSE '✗' END FROM portfolio_projects
UNION ALL
SELECT 'project_images', COUNT(*), CASE WHEN COUNT(*) = 3 THEN '✓' ELSE '✗' END FROM project_images
UNION ALL
SELECT 'blog_posts', COUNT(*), CASE WHEN COUNT(*) = 4 THEN '✓' ELSE '✗' END FROM blog_posts
UNION ALL
SELECT 'blog_tags', COUNT(*), CASE WHEN COUNT(*) = 10 THEN '✓' ELSE '✗' END FROM blog_tags
UNION ALL
SELECT 'site_content', COUNT(*), CASE WHEN COUNT(*) >= 15 THEN '✓' ELSE '✗' END FROM site_content
UNION ALL
SELECT 'media', COUNT(*), CASE WHEN COUNT(*) = 6 THEN '✓' ELSE '✗' END FROM media;

-- Test 10: Verify foreign key relationships work
\echo 'Test 10: Testing foreign key relationships...'
SELECT 
    'blog_posts → profiles' as relationship,
    CASE 
        WHEN COUNT(*) = (SELECT COUNT(*) FROM blog_posts) THEN '✓ All blog posts have valid authors'
        ELSE '✗ Some blog posts have invalid authors'
    END as status
FROM blog_posts bp
JOIN profiles p ON bp.author_id = p.id
UNION ALL
SELECT 
    'project_images → projects',
    CASE 
        WHEN COUNT(*) = (SELECT COUNT(*) FROM project_images) THEN '✓ All images linked to projects'
        ELSE '✗ Some images have invalid project_id'
    END
FROM project_images pi
JOIN portfolio_projects pp ON pi.project_id = pp.id
UNION ALL
SELECT 
    'blog_post_tags → posts',
    CASE 
        WHEN COUNT(*) = (SELECT COUNT(*) FROM blog_post_tags) THEN '✓ All tag links valid'
        ELSE '✗ Some tag links invalid'
    END
FROM blog_post_tags bpt
JOIN blog_posts bp ON bpt.blog_post_id = bp.id;

-- Test 11: Verify unique constraints
\echo 'Test 11: Testing unique constraints...'
SELECT 
    'blog_posts.slug' as constraint_name,
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT slug) THEN '✓ All slugs unique'
        ELSE '✗ Duplicate slugs found'
    END as status
FROM blog_posts
UNION ALL
SELECT 
    'portfolio_projects.slug',
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT slug) THEN '✓ All slugs unique'
        ELSE '✗ Duplicate slugs found'
    END
FROM portfolio_projects
UNION ALL
SELECT 
    'profiles.email',
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT email) THEN '✓ All emails unique'
        ELSE '✗ Duplicate emails found'
    END
FROM profiles
UNION ALL
SELECT 
    'site_content.key',
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT key) THEN '✓ All keys unique'
        ELSE '✗ Duplicate keys found'
    END
FROM site_content;

-- Test 12: Check array columns
\echo 'Test 12: Testing array columns...'
SELECT 
    title,
    array_length(technologies, 1) as tech_count,
    CASE 
        WHEN array_length(technologies, 1) > 0 THEN '✓'
        ELSE '✗ Empty array'
    END as status
FROM portfolio_projects
ORDER BY display_order;

-- Test 13: Verify timestamps
\echo 'Test 13: Checking timestamp columns...'
SELECT 
    'blog_posts' as table_name,
    CASE 
        WHEN COUNT(*) = (SELECT COUNT(*) FROM blog_posts WHERE created_at IS NOT NULL) 
        THEN '✓ All created_at populated'
        ELSE '✗ Missing created_at values'
    END as status
FROM blog_posts
UNION ALL
SELECT 
    'portfolio_projects',
    CASE 
        WHEN COUNT(*) = (SELECT COUNT(*) FROM portfolio_projects WHERE created_at IS NOT NULL) 
        THEN '✓ All created_at populated'
        ELSE '✗ Missing created_at values'
    END
FROM portfolio_projects;

-- Test 14: Verify ordering works
\echo 'Test 14: Testing display_order...'
SELECT 
    'services' as table_name,
    STRING_AGG(title, ' → ' ORDER BY display_order) as ordered_items,
    '✓' as status
FROM services
UNION ALL
SELECT 
    'portfolio_projects',
    STRING_AGG(title, ' → ' ORDER BY display_order),
    '✓'
FROM portfolio_projects;

-- ============================================================================
-- QUERY PERFORMANCE TESTS
-- ============================================================================

\echo ''
\echo '=== Testing Query Performance ==='

-- Test 15: Test index usage (simulated)
\echo 'Test 15: Checking if indexes are being used...'
EXPLAIN (FORMAT TEXT) 
SELECT * FROM blog_posts WHERE slug = 'building-modern-ecommerce-platforms';

EXPLAIN (FORMAT TEXT)
SELECT * FROM blog_posts WHERE status = 'published' ORDER BY published_at DESC;

-- ============================================================================
-- RLS POLICY TESTS
-- ============================================================================

\echo ''
\echo '=== Testing RLS Policies ==='

-- Test 16: Test public read access (simulated)
\echo 'Test 16: Testing public read access...'
SET ROLE anon;

SELECT 
    'Public can read published posts' as test,
    CASE 
        WHEN COUNT(*) >= 3 THEN '✓ Can read published posts'
        ELSE '✗ Cannot read published posts'
    END as status
FROM blog_posts
WHERE status = 'published';

SELECT 
    'Public cannot see draft posts' as test,
    CASE 
        WHEN COUNT(*) = 0 THEN '✓ Drafts are hidden'
        ELSE '✗ Drafts are visible!'
    END as status
FROM blog_posts
WHERE status = 'draft';

RESET ROLE;

-- ============================================================================
-- SUMMARY
-- ============================================================================

\echo ''
\echo '=== Test Summary ==='
\echo 'If all tests show ✓, your schema is correctly set up!'
\echo 'Any ✗ indicates an issue that needs attention.'
\echo ''
\echo 'Next steps:'
\echo '1. Review any failing tests'
\echo '2. Check migration logs for errors'
\echo '3. Verify seed data was applied'
\echo '4. Test with actual application queries'
