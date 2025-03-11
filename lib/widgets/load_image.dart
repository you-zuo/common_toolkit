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

class LoadImage extends StatelessWidget {
  LoadImage(this.image, {
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

  int? cacheWidth;

  int? cacheHeight;
  ImageLoadType imageLoadType = ImageLoadType.loading;
  bool isSvg = false;

  void initCache() {
    if (width != null) {
      if (width! < 0) {
        width = 0;
      }
    }
    if (height != null) {
      if (height! < 0) {
        height = 0;
      }
    }
  }

  Future<void> initImageType() async {
    if (image == null || image!.isEmpty || image == 'null') {
      imageLoadType = ImageLoadType.loading;
    } else {
      if (_isNetworkImage(image!)) {
        imageLoadType = ImageLoadType.net;
      } else if (_isAssetImage(image!)) {
        imageLoadType = ImageLoadType.assets;
      } else if (_isFileImage(image!)) {
        imageLoadType = ImageLoadType.file;
      }
    }
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

  Widget _imgWidget() {
    switch (imageLoadType) {
      case ImageLoadType.file:
        if (isSvg) {
          File file = File(image!);

          return svg.SvgPicture.string(
            file.readAsStringSync(),
            width: width?.abs(),
            height: height?.abs(),
            fit: fit,
            alignment: alignment,
          );
        }

        if (kIsWeb) {
          return ExtendedImage.network(
            image!,
            width: width?.abs(),
            height: height?.abs(),
            fit: fit,
            shape: shape,
            color: color,
            cacheWidth: cacheWidth,
            border: border,
            cacheHeight: cacheHeight,
            alignment: alignment,
            borderRadius: borderRadius,
            gaplessPlayback: gaplessPlayback,
            clearMemoryCacheWhenDispose: enableMemoryCache,
            loadStateChanged: (ExtendedImageState state) => _loadStateChanged(state),
          );
        } else {
          return ExtendedImage.file(
            File(image!),
            width: width?.abs(),
            height: height?.abs(),
            fit: fit,
            shape: shape,
            border: border,
            color: color,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            alignment: alignment,
            borderRadius: borderRadius,
            gaplessPlayback: gaplessPlayback,
            clearMemoryCacheWhenDispose: enableMemoryCache,
            loadStateChanged: (ExtendedImageState state) => _loadStateChanged(state),
          );
        }
      case ImageLoadType.assets:
        if (isSvg) {
          return svg.SvgPicture.asset(
            image ?? '',
            width: width?.abs(),
            height: height?.abs(),
            fit: fit,
            alignment: alignment,
          );
        }
        return ExtendedImage.asset(
          image ?? '',
          width: width?.abs(),
          height: height?.abs(),
          fit: fit,
          border: border,
          shape: shape,
          color: color,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          alignment: alignment,
          borderRadius: borderRadius,
          gaplessPlayback: gaplessPlayback,
          clearMemoryCacheWhenDispose: enableMemoryCache,
          loadStateChanged: (ExtendedImageState state) => _loadStateChanged(state),
        );

      case ImageLoadType.net:
        if (isSvg) {
          return svg.SvgPicture.network(
            image ?? '',
            width: width?.abs(),
            height: height?.abs(),
            fit: fit,
            alignment: alignment,
          );
        }
        return ExtendedImage.network(
          '${image}',
          width: width,
          height: height,
          fit: fit,
          border: border,
          shape: shape,
          borderRadius: borderRadius,
          gaplessPlayback: gaplessPlayback,
          handleLoadingProgress: true,
          printError: false,
          clearMemoryCacheWhenDispose: enableMemoryCache,
          loadStateChanged: (ExtendedImageState state) => _loadStateChanged(state),
        );
      case ImageLoadType.loading:
        return ExtendedImage.asset(
          defaultIcon,
          fit: BoxFit.scaleDown,
          color: color,
          width: width,
          border: border,
          height: height,
          cacheWidth: cacheWidth,
          borderRadius: borderRadius,
          cacheHeight: cacheHeight,
          shape: shape,
          package: defaultIcon != 'assets/no-image.png' ? null : 'common_toolkit',
          gaplessPlayback: true,
          clearMemoryCacheWhenDispose: enableMemoryCache,
          loadStateChanged: (ExtendedImageState state) => _loadStateChanged(state),
        );

      default:
        return _buildDefaultImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    initImageType();
    return SizedBox(key: ValueKey(image), child: _imgWidget());
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
    if (defaultIcon.contains('http')) {
      return ExtendedImage.network(
        defaultIcon,
        fit: BoxFit.scaleDown,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        width: width,
        border: border,
        height: height,
        color: color,
        borderRadius: borderRadius,
        shape: shape,
        gaplessPlayback: gaplessPlayback,
        clearMemoryCacheWhenDispose: enableMemoryCache,
      );
    }
    return ExtendedImage.asset(
      defaultIcon ?? '',
      fit: BoxFit.scaleDown,
      color: color,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      width: width,
      height: height,
      borderRadius: borderRadius,
      shape: shape,
      border: border,
      gaplessPlayback: gaplessPlayback,
      clearMemoryCacheWhenDispose: enableMemoryCache,
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
              color: color,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
              width: width,
              border: border,
              height: height,
              package: 'common_toolkit',
              borderRadius: borderRadius,
              shape: shape,
              gaplessPlayback: gaplessPlayback,
              clearMemoryCacheWhenDispose: enableMemoryCache,
            );
        }
      },
    );
  } //nof
}
