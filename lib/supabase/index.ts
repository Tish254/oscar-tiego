export { createClient as createBrowserClient } from './client';
export { createClient as createServerClient } from './server';
export { createClient as createRouteHandlerClient } from './route-handler';
export { createAdminClient } from './admin';
export { SupabaseProvider, useSupabase, useSession, useUser } from './provider';
export {
  fetchWithErrorHandling,
  fetchSingle,
  fetchMany,
  uploadFile,
  getPublicUrl,
  getSignedUrl,
  deleteFile,
} from './utils';
export { getSupabaseEnv, getSupabaseServerEnv } from './env';

export type { SupabaseClient } from './client';
export type { SupabaseServerClient } from './server';
export type { SupabaseRouteHandlerClient } from './route-handler';
export type { SupabaseAdminClient } from './admin';
export type { SupabaseResponse, StorageUploadOptions } from './utils';
export type {
  Database,
  Tables,
  Inserts,
  Updates,
  Profile,
  BlogPost,
  BlogTag,
  BlogPostTag,
  Media,
  PortfolioProject,
  ProjectImage,
  Service,
} from './types';
