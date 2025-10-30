import type { SupabaseClient } from './client';
import type { PostgrestError } from '@supabase/supabase-js';

export type SupabaseResponse<T> = {
  data: T | null;
  error: PostgrestError | Error | null;
};

export async function fetchWithErrorHandling<T>(
  queryFn: () => Promise<{ data: T | null; error: PostgrestError | null }>
): Promise<SupabaseResponse<T>> {
  try {
    const { data, error } = await queryFn();

    if (error) {
      console.error('Supabase query error:', error);
      return { data: null, error };
    }

    return { data, error: null };
  } catch (error) {
    console.error('Unexpected error during Supabase query:', error);
    return {
      data: null,
      error: error instanceof Error ? error : new Error('Unknown error'),
    };
  }
}

export async function fetchSingle<T>(
  queryFn: () => Promise<{ data: T | null; error: PostgrestError | null }>
): Promise<SupabaseResponse<T>> {
  return fetchWithErrorHandling(queryFn);
}

export async function fetchMany<T>(
  queryFn: () => Promise<{ data: T[] | null; error: PostgrestError | null }>
): Promise<SupabaseResponse<T[]>> {
  return fetchWithErrorHandling(queryFn);
}

export type StorageUploadOptions = {
  bucket: string;
  path: string;
  file: File | Blob;
  contentType?: string;
  cacheControl?: string;
  upsert?: boolean;
};

export async function uploadFile(
  client: SupabaseClient,
  options: StorageUploadOptions
): Promise<SupabaseResponse<{ path: string }>> {
  try {
    const { bucket, path, file, contentType, cacheControl = '3600', upsert = false } = options;

    const { data, error } = await client.storage.from(bucket).upload(path, file, {
      contentType,
      cacheControl,
      upsert,
    });

    if (error) {
      console.error('Storage upload error:', error);
      return { data: null, error };
    }

    return { data, error: null };
  } catch (error) {
    console.error('Unexpected error during file upload:', error);
    return {
      data: null,
      error: error instanceof Error ? error : new Error('Unknown error'),
    };
  }
}

export function getPublicUrl(client: SupabaseClient, bucket: string, path: string): string {
  const { data } = client.storage.from(bucket).getPublicUrl(path);
  return data.publicUrl;
}

export async function getSignedUrl(
  client: SupabaseClient,
  bucket: string,
  path: string,
  expiresIn: number = 3600
): Promise<SupabaseResponse<{ signedUrl: string }>> {
  try {
    const { data, error } = await client.storage.from(bucket).createSignedUrl(path, expiresIn);

    if (error) {
      console.error('Error creating signed URL:', error);
      return { data: null, error };
    }

    return { data: { signedUrl: data.signedUrl }, error: null };
  } catch (error) {
    console.error('Unexpected error creating signed URL:', error);
    return {
      data: null,
      error: error instanceof Error ? error : new Error('Unknown error'),
    };
  }
}

export async function deleteFile(
  client: SupabaseClient,
  bucket: string,
  paths: string | string[]
): Promise<SupabaseResponse<{ paths: string[] }>> {
  try {
    const pathsArray = Array.isArray(paths) ? paths : [paths];

    const { data, error } = await client.storage.from(bucket).remove(pathsArray);

    if (error) {
      console.error('Storage delete error:', error);
      return { data: null, error };
    }

    return { data: { paths: data.map((file) => file.name) }, error: null };
  } catch (error) {
    console.error('Unexpected error during file deletion:', error);
    return {
      data: null,
      error: error instanceof Error ? error : new Error('Unknown error'),
    };
  }
}
