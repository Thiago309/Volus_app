/// Configurações globais da aplicação Voluts TETO
class AppConfig {
  /// URL do Projeto no Supabase
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://gmlctjmxazpxwetiqqer.supabase.co',
  );

  /// Chave pública de API Publishable (Anon) do Supabase
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_xPU7MVTtasNlfa9gf0M2Lg_bgPmvDWU',
  );
}
