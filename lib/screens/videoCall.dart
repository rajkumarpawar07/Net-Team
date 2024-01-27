import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'NormalCall.dart';

class VideoCall extends StatelessWidget {
  const VideoCall({Key? key, required this.cameras, required this.interests})
      : super(key: key);
  final List<CameraDescription> cameras;
  final List<String> interests;

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    // if (args.isLiked) {
    //   return EntrepreneurCall();
    // } else {
    //   return NormalCall();
    // }
    return NormalCall(cameras: cameras, interests: interests);
  }
}
