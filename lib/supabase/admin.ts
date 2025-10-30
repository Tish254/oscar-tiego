import { createClient } from '@supabase/supabase-js';
import { supabaseServerEnv } from './env';
import type { Database } from './types';

export function createAdminClient() {
  if (!supabaseServerEnv.serviceRoleKey) {
    throw new Error(
      'SUPABASE_SERVICE_ROLE_KEY is required for admin operations. ' +
        'This should only be used in server-side code.'
    );
  }

  return createClient<Database>(supabaseServerEnv.url, supabaseServerEnv.serviceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });
}

export type SupabaseAdminClient = ReturnType<typeof createAdminClient>;
