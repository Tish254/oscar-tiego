import { createServerClient } from '@supabase/ssr';
import { cookies } from 'next/headers';
import type { NextRequest, NextResponse } from 'next/server';
import { supabaseEnv } from './env';
import type { Database } from './types';

export async function createClient(request?: NextRequest, response?: NextResponse) {
  const cookieStore = await cookies();

  return createServerClient<Database>(supabaseEnv.url, supabaseEnv.anonKey, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        cookiesToSet.forEach(({ name, value, options }) => {
          cookieStore.set(name, value, options);
          if (response) {
            response.cookies.set(name, value, options);
          }
        });
      },
    },
  });
}

export type SupabaseRouteHandlerClient = Awaited<ReturnType<typeof createClient>>;
