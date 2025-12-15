import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AppLoadingNetworkImage extends StatefulWidget {
  const AppLoadingNetworkImage({
    super.key,
    required this.imageUrl,
    this.radius,
  });

  final String imageUrl;
  final double? radius;

  @override
  State<AppLoadingNetworkImage> createState() => _AppLoadingNetworkImageState();
}

class _AppLoadingNetworkImageState extends State<AppLoadingNetworkImage> {
  File? cachedFile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCachedOrDownload();
  }

  Future<void> _loadCachedOrDownload() async {
    if (widget.imageUrl.isEmpty) {
      setState(() => loading = false);
      return;
    }

    try {
      final file = await _getCachedImageFile(widget.imageUrl);

      if (await file.exists()) {
        setState(() {
          cachedFile = file;
          loading = false;
        });
        return;
      }

      // Download, cache, and set image
      final response = await http.get(Uri.parse(widget.imageUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          cachedFile = file;
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<File> _getCachedImageFile(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    final hashedName = url.hashCode.toString(); // unique filename per URL
    return File("${dir.path}/img_$hashedName.jpg");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isEmpty || widget.imageUrl == " ") {
      return Image.asset('assets/logo/tripora.JPG', fit: BoxFit.cover);
    }

    if (loading) {
      return Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CupertinoActivityIndicator(radius: widget.radius ?? 14),
        ),
      );
    }

    // Cached file exists
    if (cachedFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(cachedFile!, fit: BoxFit.cover),
      );
    }

    // Fallback network image (should be rare)
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      ),
    );
  }
}
