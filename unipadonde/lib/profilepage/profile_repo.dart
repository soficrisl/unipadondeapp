import 'package:unipadonde/main.dart';
import 'package:unipadonde/modeldata/user_model.dart';

class ProfileRepo {
  // Método para obtener los datos del usuario desde la tabla "usuario"
  Future<User?> getUserData(int userId) async {
    try {
      final response =
          await supabase.from('usuario').select().eq('id', userId).single();
      final estudiante =
          await supabase.from('estudiante').select().eq('id', userId).single();
      final user = User.fromMap(response);
      user.updateUniversity(estudiante['universidad']);
      return user;
    } catch (e) {
      throw Exception('Error fetching user data');
    }
  }

  // Método para actualizar los datos del usuario en la tabla "usuario"
  Future<User?> updateUserData(int userId, Map<String, dynamic> data) async {
    try {
      await supabase.from('usuario').update(data).eq('id', userId);
      final userData =
          await supabase.from('usuario').select().eq('id', userId).single();
      final estudiante =
          await supabase.from('estudiante').select().eq('id', userId).single();
      final user = User.fromMap(userData);
      user.updateUniversity(estudiante['universidad']);
      return user;
    } catch (e) {
      throw Exception('Error updating user data: $e');
    }
  }
}
