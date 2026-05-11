// import 'package:flutter/material.dart';
// import 'package:quiz_game/models/colors.dart';

// class QuizImageCard extends StatelessWidget {
//   final String imageUrl;

//   const QuizImageCard({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.outlineBorder, width: 2),
//         boxShadow: [
//           BoxShadow(color: AppColors.shadow, blurRadius: 16, spreadRadius: 2),
//         ],
//       ),
//       clipBehavior: Clip.hardEdge,
//       child: AspectRatio(
//         aspectRatio: 16 / 9,
//         child: Container(
//           color: AppColors.cardBg,
//           child: imageUrl.startsWith('http')
//               ? Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   alignment: Alignment.center,
//                   filterQuality: FilterQuality.high,
//                   loadingBuilder: (context, child, progress) {
//                     if (progress == null) return child;

//                     return Center(
//                       child: CircularProgressIndicator(
//                         color: AppColors.primary,
//                         value: progress.expectedTotalBytes != null
//                             ? progress.cumulativeBytesLoaded /
//                                   progress.expectedTotalBytes!
//                             : null,
//                       ),
//                     );
//                   },
//                   errorBuilder: (_, _, _) => _errorPlaceholder(),
//                 )
//               : Image.asset(
//                   imageUrl,
//                   fit: BoxFit.contain,
//                   errorBuilder: (_, _, _) => _errorPlaceholder(),
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _errorPlaceholder() {
//     return Container(
//       color: AppColors.cardBg,
//       child: const Center(
//         child: Icon(
//           Icons.image_not_supported,
//           color: AppColors.stext,
//           size: 60,
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class QuizImageCard extends StatelessWidget {
  final String imageUrl;

  const QuizImageCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 180, // Maintain a consistent minimum height
        maxHeight: 250, // Prevent it from taking too much vertical space
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineBorder, width: 2),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 16, spreadRadius: 2),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        color: AppColors.cardBg,
        child: imageUrl.startsWith('http')
            ? _SmartNetworkImage(imageUrl: imageUrl)
            : _SmartAssetImage(imageUrl: imageUrl),
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      color: AppColors.cardBg,
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: AppColors.stext,
          size: 60,
        ),
      ),
    );
  }
}

class _SmartNetworkImage extends StatefulWidget {
  final String imageUrl;
  const _SmartNetworkImage({required this.imageUrl});

  @override
  State<_SmartNetworkImage> createState() => _SmartNetworkImageState();
}

class _SmartNetworkImageState extends State<_SmartNetworkImage> {
  BoxFit _fit = BoxFit.cover; // Default guess
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _resolveFit();
  }

  void _resolveFit() async {
    try {
      final info = await _getImageInfo(NetworkImage(widget.imageUrl));
      if (!mounted) return;
      final aspectRatio = info.image.width / info.image.height;
      setState(() {
        _fit = aspectRatio >= 1.2 ? BoxFit.cover : BoxFit.contain;
        _resolved = true;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.imageUrl,
      fit: _fit,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
      loadingBuilder: (context, child, progress) {
        if (progress == null || _resolved) return child;
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primary.withValues(alpha: 0.5),
            value: progress.expectedTotalBytes != null
                ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (_, __, ___) => _errorBox(),
    );
  }
}

class _SmartAssetImage extends StatefulWidget {
  final String imageUrl;
  const _SmartAssetImage({required this.imageUrl});

  @override
  State<_SmartAssetImage> createState() => _SmartAssetImageState();
}

class _SmartAssetImageState extends State<_SmartAssetImage> {
  BoxFit _fit = BoxFit.cover;

  @override
  void initState() {
    super.initState();
    _resolveFit();
  }

  void _resolveFit() async {
    try {
      final info = await _getImageInfo(AssetImage(widget.imageUrl));
      if (!mounted) return;
      final aspectRatio = info.image.width / info.image.height;
      setState(() {
        _fit = aspectRatio >= 1.2 ? BoxFit.cover : BoxFit.contain;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.imageUrl,
      fit: _fit,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      errorBuilder: (_, __, ___) => _errorBox(),
    );
  }
}

Future<ImageInfo> _getImageInfo(ImageProvider provider) {
  final completer = Completer<ImageInfo>();
  final stream = provider.resolve(const ImageConfiguration());

  late ImageStreamListener listener;

  listener = ImageStreamListener(
    (info, _) {
      completer.complete(info);
      stream.removeListener(listener);
    },
    onError: (_, __) {
      completer.completeError('Image load failed');
      stream.removeListener(listener);
    },
  );

  stream.addListener(listener);

  return completer.future;
}

Widget _errorBox() {
  return Container(
    color: AppColors.cardBg,
    child: const Center(
      child: Icon(Icons.broken_image, color: AppColors.stext, size: 60),
    ),
  );
}
