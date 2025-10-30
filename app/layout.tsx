import type { Metadata } from 'next';
import { Lora, Roboto_Slab } from 'next/font/google';
import './globals.css';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { SupabaseProvider } from '@/lib/supabase/provider';
import { createClient } from '@/lib/supabase/server';

const lora = Lora({
  weight: ['400', '700'],
  subsets: ['latin'],
  variable: '--font-lora',
  display: 'swap',
});

const robotoSlab = Roboto_Slab({
  weight: ['400', '700'],
  subsets: ['latin'],
  variable: '--font-roboto-slab',
  display: 'swap',
});

export const metadata: Metadata = {
  title: 'DevTish Portfolio Website',
  description:
    'Full-stack developer portfolio showcasing web design, development, and desktop application projects',
  icons: {
    icon: '/favicon.ico',
  },
};

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const supabase = await createClient();
  const {
    data: { session },
  } = await supabase.auth.getSession();

  return (
    <html lang="en">
      <body className={`${lora.variable} ${robotoSlab.variable}`}>
        <SupabaseProvider session={session}>
          <Header />
          {children}
          <Footer />
        </SupabaseProvider>
      </body>
    </html>
  );
}
