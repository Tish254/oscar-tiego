export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string;
          email: string;
          display_name: string | null;
          avatar_url: string | null;
          role: 'admin' | 'editor' | 'viewer';
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id: string;
          email: string;
          display_name?: string | null;
          avatar_url?: string | null;
          role?: 'admin' | 'editor' | 'viewer';
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          email?: string;
          display_name?: string | null;
          avatar_url?: string | null;
          role?: 'admin' | 'editor' | 'viewer';
          created_at?: string;
          updated_at?: string;
        };
      };
      blog_posts: {
        Row: {
          id: string;
          title: string;
          slug: string;
          excerpt: string | null;
          content: string;
          status: 'draft' | 'published' | 'archived';
          published_at: string | null;
          author_id: string;
          featured_img_id: string | null;
          view_count: number;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          title: string;
          slug: string;
          excerpt?: string | null;
          content: string;
          status?: 'draft' | 'published' | 'archived';
          published_at?: string | null;
          author_id: string;
          featured_img_id?: string | null;
          view_count?: number;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          title?: string;
          slug?: string;
          excerpt?: string | null;
          content?: string;
          status?: 'draft' | 'published' | 'archived';
          published_at?: string | null;
          author_id?: string;
          featured_img_id?: string | null;
          view_count?: number;
          created_at?: string;
          updated_at?: string;
        };
      };
      blog_tags: {
        Row: {
          id: string;
          name: string;
          slug: string;
          description: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          name: string;
          slug: string;
          description?: string | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          slug?: string;
          description?: string | null;
          created_at?: string;
        };
      };
      blog_post_tags: {
        Row: {
          blog_post_id: string;
          blog_tag_id: string;
          created_at: string;
        };
        Insert: {
          blog_post_id: string;
          blog_tag_id: string;
          created_at?: string;
        };
        Update: {
          blog_post_id?: string;
          blog_tag_id?: string;
          created_at?: string;
        };
      };
      media: {
        Row: {
          id: string;
          storage_path: string;
          file_name: string;
          mime_type: string;
          file_size: number;
          alt_text: string | null;
          caption: string | null;
          uploaded_by: string;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          storage_path: string;
          file_name: string;
          mime_type: string;
          file_size: number;
          alt_text?: string | null;
          caption?: string | null;
          uploaded_by: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          storage_path?: string;
          file_name?: string;
          mime_type?: string;
          file_size?: number;
          alt_text?: string | null;
          caption?: string | null;
          uploaded_by?: string;
          created_at?: string;
          updated_at?: string;
        };
      };
      portfolio_projects: {
        Row: {
          id: string;
          title: string;
          slug: string;
          description: string;
          technologies: string[];
          live_url: string | null;
          github_url: string | null;
          display_order: number;
          is_featured: boolean;
          is_published: boolean;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          title: string;
          slug: string;
          description: string;
          technologies?: string[];
          live_url?: string | null;
          github_url?: string | null;
          display_order?: number;
          is_featured?: boolean;
          is_published?: boolean;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          title?: string;
          slug?: string;
          description?: string;
          technologies?: string[];
          live_url?: string | null;
          github_url?: string | null;
          display_order?: number;
          is_featured?: boolean;
          is_published?: boolean;
          created_at?: string;
          updated_at?: string;
        };
      };
      project_images: {
        Row: {
          id: string;
          project_id: string;
          media_id: string;
          is_primary: boolean;
          display_order: number;
          created_at: string;
        };
        Insert: {
          id?: string;
          project_id: string;
          media_id: string;
          is_primary?: boolean;
          display_order?: number;
          created_at?: string;
        };
        Update: {
          id?: string;
          project_id?: string;
          media_id?: string;
          is_primary?: boolean;
          display_order?: number;
          created_at?: string;
        };
      };
      services: {
        Row: {
          id: string;
          title: string;
          description: string;
          icon: string;
          display_order: number;
          is_active: boolean;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          title: string;
          description: string;
          icon: string;
          display_order?: number;
          is_active?: boolean;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          title?: string;
          description?: string;
          icon?: string;
          display_order?: number;
          is_active?: boolean;
          created_at?: string;
          updated_at?: string;
        };
      };
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      [_ in never]: never;
    };
    Enums: {
      user_role: 'admin' | 'editor' | 'viewer';
      post_status: 'draft' | 'published' | 'archived';
    };
  };
}

export type Tables<T extends keyof Database['public']['Tables']> =
  Database['public']['Tables'][T]['Row'];
export type Inserts<T extends keyof Database['public']['Tables']> =
  Database['public']['Tables'][T]['Insert'];
export type Updates<T extends keyof Database['public']['Tables']> =
  Database['public']['Tables'][T]['Update'];

export type Profile = Tables<'profiles'>;
export type BlogPost = Tables<'blog_posts'>;
export type BlogTag = Tables<'blog_tags'>;
export type BlogPostTag = Tables<'blog_post_tags'>;
export type Media = Tables<'media'>;
export type PortfolioProject = Tables<'portfolio_projects'>;
export type ProjectImage = Tables<'project_images'>;
export type Service = Tables<'services'>;
