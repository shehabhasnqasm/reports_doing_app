import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BackgroundImg extends StatelessWidget {
  final double animationValue;
  const BackgroundImg({super.key, required this.animationValue});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
      placeholder: (context, url) => Image.asset(
        'assets/images/auth/wallpaper.jpg', //assets/images/auth/wallpaper.jpg
        fit: BoxFit.fill,
      ),
      // placeholder: (context, url) => const Center(
      //   child: CircularProgressIndicator(),
      // ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      alignment: FractionalOffset(animationValue, 0),
    );
  }
}
