import { z } from 'zod';

const envSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(1),
});

const serverEnvSchema = envSchema.extend({
  SUPABASE_SERVICE_ROLE_KEY: z.string().min(1).optional(),
  SUPABASE_JWT_SECRET: z.string().min(1).optional(),
});

function validateEnv() {
  try {
    return envSchema.parse({
      NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
      NEXT_PUBLIC_SUPABASE_ANON_KEY: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      const issues = error.issues || [];
      throw new Error(
        `Missing or invalid environment variables:\n${issues
          .map((e) => `  - ${e.path.join('.')}: ${e.message}`)
          .join('\n')}`
      );
    }
    throw error;
  }
}

function validateServerEnv() {
  try {
    return serverEnvSchema.parse({
      NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
      NEXT_PUBLIC_SUPABASE_ANON_KEY: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
      SUPABASE_SERVICE_ROLE_KEY: process.env.SUPABASE_SERVICE_ROLE_KEY,
      SUPABASE_JWT_SECRET: process.env.SUPABASE_JWT_SECRET,
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      const issues = error.issues || [];
      throw new Error(
        `Missing or invalid server environment variables:\n${issues
          .map((e) => `  - ${e.path.join('.')}: ${e.message}`)
          .join('\n')}`
      );
    }
    throw error;
  }
}

export function getSupabaseEnv() {
  return validateEnv();
}

export function getSupabaseServerEnv() {
  return validateServerEnv();
}

export const supabaseEnv = {
  url: process.env.NEXT_PUBLIC_SUPABASE_URL || '',
  anonKey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '',
};

export const supabaseServerEnv = {
  ...supabaseEnv,
  serviceRoleKey: process.env.SUPABASE_SERVICE_ROLE_KEY || '',
  jwtSecret: process.env.SUPABASE_JWT_SECRET || '',
};
