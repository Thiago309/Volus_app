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

  /// Atualiza os dados de um projeto no banco de dados
  static Future<bool> updateProject({
    required String id,
    required String title,
    required String location,
    required String status,
  }) async {
    try {
      await _client.from('projects').update({
        'title': title,
        'location': location,
        'status': status,
      }).eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao atualizar projeto no Supabase: $e');
      return false;
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

  /// Cria um novo usuário no banco de dados
  static Future<Map<String, dynamic>?> createUser({
    required String name,
    required String email,
    String role = 'voluntario',
    String nucleus = 'Núcleo SP',
    String cpf = '',
    String birthDate = '',
    String emergencyContact = '',
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'email': email,
        'role': role,
        'nucleus': nucleus,
        'is_available': true,
      };
      if (cpf.isNotEmpty) data['cpf'] = cpf;
      if (birthDate.isNotEmpty) data['birth_date'] = birthDate;
      if (emergencyContact.isNotEmpty) data['emergency_contact'] = emergencyContact;

      final response = await _client.from('users').insert(data).select().single();
      return response;
    } catch (e) {
      print('Erro ao criar usuário no Supabase: $e');
      return null;
    }
  }

  /// Atualiza os dados de um usuário existente
  static Future<bool> updateUser({
    required String id,
    required String name,
    required String email,
    required String role,
    required String nucleus,
    String cpf = '',
    String birthDate = '',
    String emergencyContact = '',
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'email': email,
        'role': role,
        'nucleus': nucleus,
      };
      if (cpf.isNotEmpty) data['cpf'] = cpf;
      if (birthDate.isNotEmpty) data['birth_date'] = birthDate;
      if (emergencyContact.isNotEmpty) data['emergency_contact'] = emergencyContact;

      await _client.from('users').update(data).eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao atualizar usuário no Supabase: $e');
      return false;
    }
  }

  /// Remove um usuário do banco de dados
  static Future<bool> deleteUser(String id) async {
    try {
      await _client.from('users').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao deletar usuário no Supabase: $e');
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

  /// Cria um novo aviso urgente no banco
  static Future<Map<String, dynamic>?> createAnnouncement({
    required String title,
    required String description,
    required String priority,
  }) async {
    try {
      final response = await _client.from('announcements').insert({
        'title': title,
        'description': description,
        'priority': priority,
        'is_active': true,
      }).select().single();
      return response;
    } catch (e) {
      print('Erro ao criar aviso no Supabase: $e');
      return null;
    }
  }

  /// Remove ou desativa um aviso urgente do banco
  static Future<bool> deleteAnnouncement(String id) async {
    try {
      await _client.from('announcements').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao deletar aviso no Supabase: $e');
      return false;
    }
  }

  /// Atualiza os detalhes de um evento no banco
  static Future<bool> updateEvent({
    required String id,
    required String title,
    required String location,
    required String date,
    required String time,
  }) async {
    try {
      String dbDate = date;
      if (date.contains('/')) {
        final parts = date.split('/');
        if (parts.length == 3) {
          dbDate = '${parts[2]}-${parts[1]}-${parts[0]}';
        }
      }
      await _client.from('events').update({
        'title': title,
        'location': location,
        'event_date': dbDate,
        'start_time': time,
      }).eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao atualizar evento: $e');
      return false;
    }
  }

  /// Finaliza a escala mudando todos os status de pendente para confirmado
  static Future<bool> finalizeScale(String eventId) async {
    try {
      await _client
          .from('escalas')
          .update({'status': 'confirmado'})
          .eq('event_id', eventId)
          .eq('status', 'pendente');
      return true;
    } catch (e) {
      print('Erro ao finalizar escala no Supabase: $e');
      return false;
    }
  }

  /// Busca todos os voluntários cadastrados na tabela users
  static Future<List<Map<String, dynamic>>> getVolunteers() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('role', 'voluntario')
          .order('name', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar voluntários: $e');
      return [];
    }
  }

  /// Cria um evento novo no banco ou retorna o existente
  static Future<String?> createEvent({
    required String title,
    required String location,
    required String date,
    required String time,
  }) async {
    try {
      String dbDate = date;
      if (date.contains('/')) {
        final parts = date.split('/');
        if (parts.length == 3) {
          dbDate = '${parts[2]}-${parts[1]}-${parts[0]}';
        }
      }
      final response = await _client.from('events').insert({
        'title': title,
        'category': 'construcao',
        'location': location,
        'event_date': dbDate,
        'start_time': time,
        'end_time': '17:00',
        'description': 'Evento criado via escala de voluntários',
      }).select().single();
      return response['id'].toString();
    } catch (e) {
      print('Erro ao criar evento no Supabase: $e');
      return null;
    }
  }

  /// Insere os voluntários na tabela escalas vinculando ao evento
  static Future<bool> insertEscalas({
    required String eventId,
    required List<Map<String, dynamic>> volunteers,
  }) async {
    try {
      final rows = volunteers.map((v) {
        // Mapear status visual para status do banco
        String dbStatus = 'pendente';
        final status = v['status'];
        if (status != null) {
          final statusStr = status.toString();
          if (statusStr.contains('present')) {
            dbStatus = 'presente';
          } else if (statusStr.contains('confirmed')) {
            dbStatus = 'confirmado';
          } else if (statusStr.contains('unavailable')) {
            dbStatus = 'indisponivel';
          } else if (statusStr.contains('requestedSwap')) {
            dbStatus = 'troca_solicitada';
          }
        }

        return {
          'event_id': eventId,
          'volunteer_id': v['user_id'] ?? v['id'],
          'status': dbStatus,
          'swap_requested': dbStatus == 'troca_solicitada',
        };
      }).toList();

      await _client.from('escalas').insert(rows);
      return true;
    } catch (e) {
      print('Erro ao inserir escalas no Supabase: $e');
      return false;
    }
  }
}
