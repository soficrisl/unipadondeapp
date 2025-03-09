import 'package:supabase_flutter/supabase_flutter.dart';

class BuspageModel {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchDiscounts(int idNegocio) async {
    try {
      final response = await client
          .from('descuento')
          .select('*')
          .eq('id_negocio', idNegocio);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching discounts: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchAddress(int idNegocio) async {
    try {
      final response = await client
          .from('direccion')
          .select('*')
          .eq('id_negocio', idNegocio)
          .single();
      return response;
    } catch (e) {
      print('Error fetching address: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchComments(int idNegocio) async {
    try {
      final response = await client
          .from('comenta')
          .select('''*, estudiante:estudiante(id, usuario:usuario(id, name, lastname))''')
          .eq('id_negocio', idNegocio);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  Future<void> submitComment(int idNegocio, int estudianteId, String content, int rating) async {
    try {
      await client.from('comenta').insert({
        'id_usuario': estudianteId,
        'id_negocio': idNegocio,
        'date': DateTime.now().toIso8601String(),
        'content': content,
        'calificacion': rating,
      });
    } catch (e) {
      print('Error submitting comment: $e');
      throw e;
    }
  }
}
