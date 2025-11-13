import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLoadingNetworkImage extends StatelessWidget {
  const AppLoadingNetworkImage({
    super.key,
    required this.imageUrl,
    this.radius,
  });

  final String imageUrl;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      // child: Image.network(imageUrl!, fit: BoxFit.cover),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              // Image finished loading
              return child;
            }
            // While the image is loading
            return Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CupertinoActivityIndicator(radius: radius ?? 14),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
