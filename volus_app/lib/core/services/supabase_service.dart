import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço responsável por todas as operações de banco de dados no Supabase
class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  // ==========================================
  // PROJETOS ATIVOS
  // ==========================================
  
  /// Busca a lista de projetos ativos do banco de dados
  static Future<List<Map<String, dynamic>>> getProjects() async {
    try {
      final response = await _client
          .from('projects')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar projetos: $e');
      return [];
    }
  }

  // ==========================================
  // DEPOIMENTOS (MODERAÇÃO)
  // ==========================================

  /// Busca os depoimentos pendentes de moderação do administrador
  static Future<List<Map<String, dynamic>>> getPendingTestimonials() async {
    try {
      final response = await _client
          .from('testimonials')
          .select()
          .eq('status', 'pendente')
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar depoimentos pendentes: $e');
      return [];
    }
  }

  /// Aprova ou rejeita um depoimento
  static Future<bool> updateTestimonialStatus(String id, String status) async {
    try {
      await _client
          .from('testimonials')
          .update({'status': status})
          .eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao atualizar depoimento: $e');
      return false;
    }
  }

  // ==========================================
  // ESCALAS DE VOLUNTÁRIOS
  // ==========================================

  /// Busca os dados de eventos e voluntários em escala
  static Future<List<Map<String, dynamic>>> getEscalas() async {
    try {
      final response = await _client
          .from('escalas')
          .select('*, events(*), users(*)');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar escalas: $e');
      return [];
    }
  }

  /// Atualiza o status da escala de um voluntário (ex: confirmado, ausente, troca_solicitada)
  static Future<bool> updateEscalaStatus(String escalaId, String newStatus) async {
    try {
      await _client
          .from('escalas')
          .update({'status': newStatus})
          .eq('id', escalaId);
      return true;
    } catch (e) {
      print('Erro ao atualizar status da escala: $e');
      return false;
    }
  }

  // ==========================================
  // USUÁRIOS & DISPONIBILIDADE
  // ==========================================

  /// Atualiza a disponibilidade de um voluntário
  static Future<bool> updateUserAvailability(String userId, bool isAvailable, {String? reason}) async {
    try {
      await _client.from('users').update({
        'is_available': isAvailable,
        'unavailable_reason': isAvailable ? null : reason,
      }).eq('id', userId);
      return true;
    } catch (e) {
      print('Erro ao atualizar disponibilidade: $e');
      return false;
    }
  }

  // ==========================================
  // AVISOS URGENTES
  // ==========================================

  /// Busca os avisos urgentes ativos
  static Future<List<Map<String, dynamic>>> getAnnouncements() async {
    try {
      final response = await _client
          .from('announcements')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar avisos: $e');
      return [];
    }
  }
}
