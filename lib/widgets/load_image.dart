import 'dart:async';
import 'package:common_toolkit/widgets/loading_widget.dart';
import 'package:extended_image_library/extended_image_library.dart' show File;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' as svg;

import 'package:shimmer_animation/shimmer_animation.dart';

enum ImageLoadType { assets, net, loading, fail, file }

const String defaultImageIcon = 'assets/no-image.png'; // default image

class LoadImage extends StatefulWidget {
  LoadImage(
    this.image, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.shape = BoxShape.rectangle,
    this.color,
    this.border,
    this.gaplessPlayback = true,
    this.enableMemoryCache = true,
    this.alignment = Alignment.center,
    this.defaultIcon = defaultImageIcon,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
  });

  final String? image;
  final String defaultIcon;
  double? width;
  double? height;
  final BoxFit fit;
  final BoxShape shape;
  final Color? color;
  final BorderRadius borderRadius;
  final Border? border;
  final Alignment alignment;
  final bool gaplessPlayback;
  final bool enableMemoryCache;

  @override
  State<LoadImage> createState() => _LoadImageState();
}

class _LoadImageState extends State<LoadImage> {
  int? cacheWidth;

  int? cacheHeight;

  ImageLoadType imageLoadType = ImageLoadType.loading;

  bool isSvg = false;

  void initCache() {
    if (widget.width != null) {
      if (widget.width! < 0) {
        widget.width = 0;
      }
    }
    if (widget.height != null) {
      if (widget.height! < 0) {
        widget.height = 0;
      }
    }
  }

  Future<void> initImageType() async {
    if (widget.image == null || widget.image!.isEmpty || widget.image == 'null') {
      imageLoadType = ImageLoadType.loading;
    } else {
      if (_isNetworkImage(widget.image!)) {
        imageLoadType = ImageLoadType.net;
      } else if (_isAssetImage(widget.image!)) {
        imageLoadType = ImageLoadType.assets;
      } else if (_isFileImage(widget.image!)) {
        imageLoadType = ImageLoadType.file;
      }
    }
    setState(() {});
  }

  bool _isNetworkImage(String url) {
    return url.startsWith('http') || url.startsWith('https');
  }

  bool _isAssetImage(String url) {
    return !url.contains('/') || url.startsWith('assets/');
  }

  bool _isFileImage(String url) {
    return File(url).existsSync();
  }

  @override
  void initState() {
    super.initState();
    initImageType();
  }

  Widget _imgWidget() {
    switch (imageLoadType) {
      case ImageLoadType.file:
        if (isSvg) {
          File file = File(widget.image!);

          return svg.SvgPicture.string(
            file.readAsStringSync(),
            width: widget.width?.abs(),
            height: widget.height?.abs(),
            fit: widget.fit,
            alignment: widget.alignment,
          );
        }

        if (kIsWeb) {
          return ExtendedImage.network(
            widget.image!,
            width: widget.width?.abs(),
            height: widget.height?.abs(),
            fit: widget.fit,
            shape: widget.shape,
            color: widget.color,
            cacheWidth: cacheWidth,
            border: widget.border,
            cacheHeight: cacheHeight,
            alignment: widget.alignment,
            borderRadius: widget.borderRadius,
            gaplessPlayback: widget.gaplessPlayback,
            clearMemoryCacheWhenDispose: widget.enableMemoryCache,
            loadStateChanged: (ExtendedImageState state) => _loadStateChanged(state),
          );
        } else {
          return ExtendedImage.file(
            File(widget.image!),
            width: widget.width?.abs(),
            height: widget.height?.abs(),
            fit: widget.fit,
            shape: widget.shape,
            border: widget.border,
            color: widget.color,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            alignment: widget.alignment,
            borderRadius: widget.borderRadius,
            gaplessPlayback: widget.gaplessPlayback,
            clearMemoryCacheWhenDispose: widget.enableMemoryCache,
            loadStateChanged: (ExtendedImageState state) => _loadStateChanged(state),
          );
        }
      case ImageLoadType.assets:
        if (isSvg) {
          return svg.SvgPicture.asset(
            widget.image ?? '',
            width: widget.width?.abs(),
            height: widget.height?.abs(),
            fit: widget.fit,
            alignment: widget.alignment,
          );
        }
        return ExtendedImage.asset(
          widget.image ?? '',
          width: widget.width?.abs(),
          height: widget.height?.abs(),
          fit: widget.fit,
          border: widget.border,
          shape: widget.shape,
          color: widget.color,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          alignment: widget.alignment,
          borderRadius: widget.borderRadius,
          gaplessPlayback: widget.gaplessPlayback,
          clearMemoryCacheWhenDispose: widget.enableMemoryCache,
          loadStateChanged: (ExtendedImageState state) => _loadStateChanged(state),
        );

      case ImageLoadType.net:
        if (isSvg) {
          return svg.SvgPicture.network(
            widget.image ?? '',
            width: widget.width?.abs(),
            height: widget.height?.abs(),
            fit: widget.fit,
            alignment: widget.alignment,
          );
        }
        return ExtendedImage.network(
          '${widget.image}',
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          border: widget.border,
          shape: widget.shape,
          borderRadius: widget.borderRadius,
          gaplessPlayback: widget.gaplessPlayback,
          handleLoadingProgress: true,
          printError: false,
          clearMemoryCacheWhenDispose: widget.enableMemoryCache,
          loadStateChanged: (ExtendedImageState state) => _loadStateChanged(state),
        );
      case ImageLoadType.loading:
        return ExtendedImage.asset(
          widget.defaultIcon,
          fit: BoxFit.scaleDown,
          color: widget.color,
          width: widget.width,
          border: widget.border,
          height: widget.height,
          cacheWidth: cacheWidth,
          borderRadius: widget.borderRadius,
          cacheHeight: cacheHeight,
          shape: widget.shape,
          package: widget.defaultIcon != 'assets/no-image.png' ? null : 'common_toolkit',
          gaplessPlayback: true,
          clearMemoryCacheWhenDispose: widget.enableMemoryCache,
          loadStateChanged: (ExtendedImageState state) => _loadStateChanged(state),
        );

      default:
        return _buildDefaultImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(key: ValueKey(widget.image), child: _imgWidget());
  }

  Widget _loadStateChanged(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return const LoadingWidget();
      case LoadState.completed:
        return state.completedWidget;
      case LoadState.failed:
        return _buildDefaultImage();
    }
  }

  Widget _buildDefaultImage() {
    if (widget.defaultIcon.contains('http')) {
      return ExtendedImage.network(
        widget.defaultIcon,
        fit: BoxFit.scaleDown,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        width: widget.width,
        border: widget.border,
        height: widget.height,
        color: widget.color,
        borderRadius: widget.borderRadius,
        shape: widget.shape,
        gaplessPlayback: widget.gaplessPlayback,
        clearMemoryCacheWhenDispose: widget.enableMemoryCache,
      );
    }
    return ExtendedImage.asset(
      widget.defaultIcon ?? '',
      fit: BoxFit.scaleDown,
      color: widget.color,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      width: widget.width,
      height: widget.height,
      borderRadius: widget.borderRadius,
      shape: widget.shape,
      border: widget.border,
      gaplessPlayback: widget.gaplessPlayback,
      clearMemoryCacheWhenDispose: widget.enableMemoryCache,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return const LoadingWidget();
          case LoadState.completed:
            return state.completedWidget;
          case LoadState.failed:
            return ExtendedImage.asset(
              defaultImageIcon,
              fit: BoxFit.scaleDown,
              color: widget.color,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
              width: widget.width,
              border: widget.border,
              height: widget.height,
              package: 'common_toolkit',
              borderRadius: widget.borderRadius,
              shape: widget.shape,
              gaplessPlayback: widget.gaplessPlayback,
              clearMemoryCacheWhenDispose: widget.enableMemoryCache,
            );
        }
      },
    );
  }
}
