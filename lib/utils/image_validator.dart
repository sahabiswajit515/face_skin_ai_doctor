import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:math';

class ImageValidator {
  /// Validates an image for resolution, brightness, and blur.
  /// Returns an error message if invalid, or null if valid.
  static Future<String?> validateImage(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      return "Unable to process the image. Please try again.";
    }

    // 1. Resolution Check
    if (image.width < 300 || image.height < 300) {
      return "Image resolution too low. Please capture a clearer close-up photo.";
    }

    // 2. Brightness Check
    // Sample pixels and calculate average luminance (0.299R + 0.587G + 0.114B)
    double totalBrightness = 0;
    int sampleCount = 0;
    
    // Sample every 10th pixel for performance
    for (int y = 0; y < image.height; y += 10) {
      for (int x = 0; x < image.width; x += 10) {
        final pixel = image.getPixel(x, y);
        // Normalized values (0-1)
        final r = pixel.r / 255.0;
        final g = pixel.g / 255.0;
        final b = pixel.b / 255.0;
        
        final brightness = (0.299 * r + 0.587 * g + 0.114 * b) * 100;
        totalBrightness += brightness;
        sampleCount++;
      }
    }

    final avgBrightness = totalBrightness / sampleCount;
    if (avgBrightness < 40) {
      return "Image is too dark. Please take photo in better lighting.";
    }

    // 3. Blur Detection (Variance of Luminance Difference)
    // Simplified Laplacian variance equivalent
    double totalLuminance = 0;
    double totalLuminanceSq = 0;
    int blurSampleCount = 0;

    for (int y = 5; y < image.height - 5; y += 10) {
      for (int x = 5; x < image.width - 5; x += 10) {
        final p = image.getPixel(x, y);
        final lum = (0.299 * p.r + 0.587 * p.g + 0.114 * p.b);
        
        // Compare with neighbors
        final pRight = image.getPixel(x + 1, y);
        final lumRight = (0.299 * pRight.r + 0.587 * pRight.g + 0.114 * pRight.b);
        
        final diff = (lum - lumRight).abs();
        totalLuminance += diff;
        totalLuminanceSq += diff * diff;
        blurSampleCount++;
      }
    }

    final mean = totalLuminance / blurSampleCount;
    final variance = (totalLuminanceSq / blurSampleCount) - (mean * mean);

    if (variance < 20) {
      return "Image appears blurry. Please capture a sharper image.";
    }

    return null; // Valid
  }
}
