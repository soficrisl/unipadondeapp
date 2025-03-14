import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/main.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.imageUrl, required this.onUpload});

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: 150,
        height: 150,
        child: imageUrl != ""
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFFFA500), width: 5),
                    borderRadius: BorderRadius.circular(100)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF8CB1F1), // Fondo azul
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Colors.white, // Cámara blanca
                ),
              ),
      ),
      const SizedBox(height: 12),
      ElevatedButton(
        onPressed: () async {
          final ImagePicker picker = ImagePicker();
          final XFile? image =
              await picker.pickImage(source: ImageSource.gallery);
          if (image == null) {
            return;
          }
          final imageExtension = image.path.split('.').last.toLowerCase();
          final imageBytes = await image.readAsBytes();
          final userId = supabase.auth.currentUser!.id;
          final imagePath = '/$userId/profile';
          await supabase.storage.from('profiles').updateBinary(
              imagePath, imageBytes,
              fileOptions: FileOptions(
                  upsert: true, contentType: 'image/$imageExtension'));
          String imageUrl =
              supabase.storage.from('profiles').getPublicUrl(imagePath);
          imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
            't': DateTime.now().millisecondsSinceEpoch.toString()
          }).toString();
          onUpload(imageUrl);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFFA500),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          textStyle: TextStyle(fontSize: 16, fontFamily: 'San Francisco'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Cambiar Foto',
          style: TextStyle(
              fontFamily: 'San Francisco',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      )
    ]);
  }
}
