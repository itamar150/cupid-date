import 'dart:async';

/// Completes when Supabase.initialize() finishes.
/// Providers that need the Supabase client await this before first access.
final supabaseReadyCompleter = Completer<void>();
