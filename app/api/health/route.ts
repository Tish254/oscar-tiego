import { NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/route-handler';

export async function GET() {
  try {
    const supabase = await createClient();

    const { error } = await supabase.auth.getSession();

    if (error) {
      return NextResponse.json(
        {
          status: 'unhealthy',
          message: 'Supabase connection error',
          error: error.message,
        },
        { status: 500 }
      );
    }

    return NextResponse.json({
      status: 'healthy',
      message: 'Supabase client initialized successfully',
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    return NextResponse.json(
      {
        status: 'error',
        message: error instanceof Error ? error.message : 'Unknown error',
      },
      { status: 500 }
    );
  }
}
