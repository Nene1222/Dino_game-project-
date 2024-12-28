class Sprite {
  late String imagePath;
  late int imageWidth;   
  late int imageHeight; 

  void initialize({
    required String path,
    required int width,
    required int height,
  }) {
    imagePath = path;
    imageWidth = width;
    imageHeight = height;
  }
}