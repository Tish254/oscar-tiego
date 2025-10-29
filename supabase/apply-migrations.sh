#!/bin/bash

# Script to apply Supabase migrations and seed data
# Usage: ./apply-migrations.sh [database-connection-string]

set -e  # Exit on error

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Supabase Migration & Seeding Script ===${NC}\n"

# Check if connection string is provided
if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: $0 <database-connection-string>${NC}"
    echo -e "${YELLOW}Example: $0 'postgresql://postgres:password@db.xxxxx.supabase.co:5432/postgres'${NC}"
    echo -e "\nAlternatively, set DATABASE_URL environment variable:"
    echo -e "${YELLOW}export DATABASE_URL='postgresql://...'${NC}"
    echo -e "${YELLOW}$0${NC}\n"
    
    if [ -z "$DATABASE_URL" ]; then
        echo -e "${RED}Error: No database connection string provided${NC}"
        exit 1
    else
        DB_URL="$DATABASE_URL"
        echo -e "${GREEN}Using DATABASE_URL from environment${NC}\n"
    fi
else
    DB_URL="$1"
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Migration files
SCHEMA_MIGRATION="$SCRIPT_DIR/migrations/20240101000000_initial_schema.sql"
RLS_MIGRATION="$SCRIPT_DIR/migrations/20240101000001_row_level_security.sql"
SEED_FILE="$SCRIPT_DIR/seed.sql"

# Check if files exist
if [ ! -f "$SCHEMA_MIGRATION" ]; then
    echo -e "${RED}Error: Schema migration file not found: $SCHEMA_MIGRATION${NC}"
    exit 1
fi

if [ ! -f "$RLS_MIGRATION" ]; then
    echo -e "${RED}Error: RLS migration file not found: $RLS_MIGRATION${NC}"
    exit 1
fi

if [ ! -f "$SEED_FILE" ]; then
    echo -e "${RED}Error: Seed file not found: $SEED_FILE${NC}"
    exit 1
fi

# Check if psql is installed
if ! command -v psql &> /dev/null; then
    echo -e "${RED}Error: psql is not installed. Please install PostgreSQL client.${NC}"
    exit 1
fi

# Apply schema migration
echo -e "${GREEN}Step 1/3: Applying initial schema migration...${NC}"
psql "$DB_URL" -f "$SCHEMA_MIGRATION" -v ON_ERROR_STOP=1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Schema migration applied successfully${NC}\n"
else
    echo -e "${RED}✗ Schema migration failed${NC}"
    exit 1
fi

# Apply RLS policies
echo -e "${GREEN}Step 2/3: Applying Row Level Security policies...${NC}"
psql "$DB_URL" -f "$RLS_MIGRATION" -v ON_ERROR_STOP=1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ RLS policies applied successfully${NC}\n"
else
    echo -e "${RED}✗ RLS migration failed${NC}"
    exit 1
fi

# Apply seed data
echo -e "${GREEN}Step 3/3: Seeding database with initial data...${NC}"
psql "$DB_URL" -f "$SEED_FILE" -v ON_ERROR_STOP=1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database seeded successfully${NC}\n"
else
    echo -e "${RED}✗ Seeding failed${NC}"
    exit 1
fi

# Verify setup
echo -e "${GREEN}=== Verifying Setup ===${NC}\n"
psql "$DB_URL" -c "
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
"

echo -e "\n${GREEN}=== Migration Complete! ===${NC}"
echo -e "${GREEN}Your Supabase database is now set up and seeded with initial data.${NC}\n"
