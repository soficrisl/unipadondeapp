import 'package:unipadonde/main.dart';
import 'package:unipadonde/modeldata/adress_model.dart';
import 'package:unipadonde/modeldata/comment_model.dart';
import 'package:unipadonde/modeldata/discount_model.dart';
import 'package:unipadonde/modeldata/business_model.dart';

class BuspageRepository {
  Future<Business?> fechtBusiness(int id) async {
    try {
      final response =
          await supabase.from('negocio').select().eq('id', id).limit(1);
      final Map<String, dynamic> item = response[0];
      return Business.fromMap(item);
    } on Exception catch (error) {
      print('Error fetching business: $error');
      return null;
    }
  }

  Future<List<Discount>> fetchDiscounts(int id, Business business) async {
    try {
      final descuentos = await supabase
          .from('descuento')
          .select('*')
          .eq('id_negocio', id)
          .eq('state', true);

      final pertenece = await supabase.from('pertenece').select();
      final perteneceMap = {
        for (var n in pertenece) n['id_negocio']: n["id_categoria"]
      };
      List<Discount> descuentoslistos = [];
      for (var descuento in descuentos) {
        descuento['business'] = business;
        descuento['idcategory'] = perteneceMap[business.id];
        final item = Discount.fromMap(descuento);
        descuentoslistos.add(item);
      }
      return descuentoslistos;
    } catch (e) {
      throw Exception('Error fetching discounts: $e');
    }
  }

  Future<Address?> fetchAddress(int id) async {
    try {
      final response =
          await supabase.from('direccion').select('*').eq('id_negocio', id);
      final Map<String, dynamic> item = response[0];
      final address = Address.fromMap(item);
      return address;
    } catch (e) {
      print('Error fetching address: $e');
      return null;
    }
  }

  Future<List<Comment>?> fetchComments(int id) async {
    try {
      final response =
          await supabase.from('comentario').select().eq('id_negocio', id);
      final comments = response.map<Comment>((item) {
        return Comment.fromMap(item);
      }).toList();
      for (var comment in comments) {
        final userResponse = await supabase
            .from('usuario')
            .select('name, lastname')
            .eq('id', comment.iduser)
            .single(); // Use .single() to get one record
        comment.setNames(userResponse['name'], userResponse['lastname']);
      }
      return comments;
    } catch (e) {
      print('Error fetching comments: $e');
      return null;
    }
  }

  Future<bool> submitComment(String content, int rating, int id) async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final userResponse = await supabase
            .from('usuario')
            .select('id')
            .eq('uid', user.id)
            .single();

        final int idstudent = userResponse['id'];
        await supabase.from('comentario').insert({
          'id_usuario': idstudent,
          'id_negocio': id,
          'date': DateTime.now().toIso8601String(),
          'content': content,
          'calificacion': rating,
        });
      }
      fetchComments(id);
      return true;
    } catch (e) {
      print('Error submitting comment: $e');
      return false;
    }
  }
}
