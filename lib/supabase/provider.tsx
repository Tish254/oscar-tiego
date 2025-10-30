'use client';

import { createContext, useContext, useEffect, useState } from 'react';
import { createClient } from './client';
import type { Session, User } from '@supabase/supabase-js';

type SupabaseContextType = {
  supabase: ReturnType<typeof createClient>;
  session: Session | null;
  user: User | null;
  isLoading: boolean;
};

const SupabaseContext = createContext<SupabaseContextType | undefined>(undefined);

export function SupabaseProvider({
  children,
  session: initialSession,
}: {
  children: React.ReactNode;
  session?: Session | null;
}) {
  const [supabase] = useState(() => createClient());
  const [session, setSession] = useState<Session | null>(initialSession || null);
  const [user, setUser] = useState<User | null>(initialSession?.user || null);
  const [isLoading, setIsLoading] = useState(!initialSession);

  useEffect(() => {
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event, currentSession) => {
      setSession(currentSession);
      setUser(currentSession?.user || null);
      setIsLoading(false);
    });

    if (!initialSession) {
      supabase.auth.getSession().then(({ data: { session: currentSession } }) => {
        setSession(currentSession);
        setUser(currentSession?.user || null);
        setIsLoading(false);
      });
    }

    return () => {
      subscription.unsubscribe();
    };
  }, [supabase, initialSession]);

  const value = {
    supabase,
    session,
    user,
    isLoading,
  };

  return <SupabaseContext.Provider value={value}>{children}</SupabaseContext.Provider>;
}

export function useSupabase() {
  const context = useContext(SupabaseContext);

  if (context === undefined) {
    throw new Error('useSupabase must be used within a SupabaseProvider');
  }

  return context;
}

export function useSession() {
  const { session, isLoading } = useSupabase();
  return { session, isLoading };
}

export function useUser() {
  const { user, isLoading } = useSupabase();
  return { user, isLoading };
}
