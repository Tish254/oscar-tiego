#!/bin/bash

# Script to create a new Supabase migration file
# Usage: ./new-migration.sh <migration_name>

set -e

# Color output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if migration name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Migration name is required${NC}"
    echo -e "${YELLOW}Usage: $0 <migration_name>${NC}"
    echo -e "${YELLOW}Example: $0 add_user_preferences_table${NC}"
    exit 1
fi

MIGRATION_NAME="$1"

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MIGRATIONS_DIR="$SCRIPT_DIR/migrations"

# Create migrations directory if it doesn't exist
mkdir -p "$MIGRATIONS_DIR"

# Generate timestamp (YYYYMMDDHHmmss format)
TIMESTAMP=$(date +"%Y%m%d%H%M%S")

# Create migration filename
FILENAME="${TIMESTAMP}_${MIGRATION_NAME}.sql"
FILEPATH="$MIGRATIONS_DIR/$FILENAME"

# Create migration file with template
cat > "$FILEPATH" << EOF
-- Migration: ${MIGRATION_NAME}
-- Created: $(date +"%Y-%m-%d %H:%M:%S")

-- ============================================================================
-- ADD YOUR MIGRATION SQL HERE
-- ============================================================================

-- Example: Create a new table
-- CREATE TABLE example_table (
--     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--     name TEXT NOT NULL,
--     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );

-- Example: Add a column to existing table
-- ALTER TABLE existing_table ADD COLUMN new_column TEXT;

-- Example: Create an index
-- CREATE INDEX idx_example_table_name ON example_table(name);

-- ============================================================================
-- ROW LEVEL SECURITY (if needed)
-- ============================================================================

-- Enable RLS on new tables
-- ALTER TABLE example_table ENABLE ROW LEVEL SECURITY;

-- Add RLS policies
-- CREATE POLICY "Example policy"
--     ON example_table FOR SELECT
--     USING (true);

-- ============================================================================
-- ROLLBACK (optional - document how to undo this migration)
-- ============================================================================

-- DROP TABLE IF EXISTS example_table;
EOF

echo -e "${GREEN}✓ Migration file created: ${NC}${FILENAME}"
echo -e "${YELLOW}Location: ${NC}${FILEPATH}"
echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Edit the migration file and add your SQL"
echo -e "2. Test the migration: ${GREEN}psql \$DATABASE_URL -f $FILEPATH${NC}"
echo -e "3. Apply to production: ${GREEN}./apply-migrations.sh${NC}\n"
