import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/main.dart';

class AvatarRepo {
  Future<String> imageUrlUser(dynamic imageBytes, String imageExtension) async {
    final userId = supabase.auth.currentUser!.id;
    final imagePath = '/$userId/profile';
    await supabase.storage.from('profiles').updateBinary(imagePath, imageBytes,
        fileOptions:
            FileOptions(upsert: true, contentType: 'image/$imageExtension'));
    String imageUrl = supabase.storage.from('profiles').getPublicUrl(imagePath);
    imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString()
    }).toString();
    await supabase
        .from('usuario')
        .update({'image_url': imageUrl}).eq('uid', userId);
    return imageUrl;
  }

  Future<String> imageUrlBusiness(
      dynamic imageBytes, String imageExtension, int idNegocio) async {
    final imagePath = '/$idNegocio/profile';
    await supabase.storage.from('business').updateBinary(imagePath, imageBytes,
        fileOptions:
            FileOptions(upsert: true, contentType: 'image/$imageExtension'));
    String imageUrl = supabase.storage.from('business').getPublicUrl(imagePath);
    imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString()
    }).toString();
    await supabase
        .from('negocio')
        .update({'image_url': imageUrl}).eq('id', idNegocio);
    return imageUrl;
  }
}
