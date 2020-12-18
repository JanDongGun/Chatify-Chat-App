import 'package:image_picker/image_picker.dart';

class MediaService {
  static MediaService instance = MediaService();

  Future<PickedFile> getImageFromLibrary() async {
    return await ImagePicker().getImage(source: ImageSource.gallery);
  }
}
