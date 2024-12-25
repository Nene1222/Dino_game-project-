class Sprite {
  late String imagePath; // Marked as late
  late int imageWidth;   // Marked as late
  late int imageHeight;  // Marked as late

  // You can have a method to initialize them
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