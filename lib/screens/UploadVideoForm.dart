import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';

class VideoUploadForm extends StatefulWidget {
  final File videoFile;
  const VideoUploadForm({super.key, required this.videoFile});

  @override
  State<VideoUploadForm> createState() => _VideoUploadFormState();
}

class _VideoUploadFormState extends State<VideoUploadForm> {
  /// varibales
  bool isUploading = false;
  late String username;
  late String email;
  late VideoPlayerController playerController;
  late Future<void> _initializeVideoPlayerFuture;
  late TextEditingController description = TextEditingController();

  /// init state
  @override
  void initState() {
    super.initState();
    username = Provider.of<MyDataContainer>(context, listen: false).name;
    email = Provider.of<MyDataContainer>(context, listen: false).userEmail;
    playerController = VideoPlayerController.file(File(widget.videoFile.path))
      ..initialize().then((_) {
        setState(() {
          // Start playing the video once it is initialized
          playerController.play();
          playerController.setLooping(true);
        });
      });
  }

  /// when "upload video" button is pressed
  Future<void> _uploadFile() async {
    setState(() {
      isUploading = true;
    });

    /// file is empty
    if (widget.videoFile == null) {
      return;
    }
    var url = Uri.parse('${dotenv.env['BACKEND_URL']}/upload');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('Authorization');
      print("token ${token}");

      // if (token != null) {
      // request.headers['Authorization'] = token;
      // }

      // Created a multipart request
      var request = http.MultipartRequest('POST', url);

      // headers
      request.headers.addAll({"token": token!});

      // Attach the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'video',
        widget.videoFile!.path,
      ));

      request.fields['description'] = description.text;
      request.fields['author'] = username;
      request.fields['email'] = email;

      print(description.text);
      print(username);
      print(email);
      print("vidoe path ${widget.videoFile!.path}");

      // Send the request
      var response = await request.send();

      print(response.statusCode);
      // Read response stream as a string
      var responseBody = await response.stream.bytesToString();

      // Print the response body
      print('Response Body: $responseBody');

      // Handle the response
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.blue,
            content: Text("Video uploaded successfully"),
          ),
        );
        setState(() {
          Navigator.pushReplacementNamed(context, "/");
        });
      }
      if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.blue,
            content: Text("Failed to upload Video. Server Side Issue."),
          ),
        );
        setState(() {
          Navigator.pushReplacementNamed(context, "/");
        });
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.blue,
        //     content: Text("Failed to upload File."),
        //   ),
        // );
        setState(() {
          Navigator.pushReplacementNamed(context, "/");
        });
        print('Failed to upload video. Status code: ${response.statusCode}');
      }
      setState(() {
        isUploading = false;
      });
    } catch (error) {
      print("Inside Catch Block");
      print('Error uploading file: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.blue,
          content:
              Text("Failed to upload video. Check Your Internet Connection"),
        ),
      );
      setState(() {
        Navigator.pushReplacementNamed(context, "/");
      });
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Center(
            child: playerController.value.isInitialized
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: playerController.value.aspectRatio,
                          child: VideoPlayer(playerController),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  )
                : CircularProgressIndicator(),
          ),
          Positioned(
            bottom: kBottomNavigationBarHeight,
            left: 10,
            right: 10,
            height: 60,
            child: TextField(
              controller: description,
              decoration: const InputDecoration(
                labelText: 'Description',
              ).copyWith(
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
                // Apply the custom theme
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            ),
          ),
          Positioned(
            top: kToolbarHeight,
            right: 20,
            child: ElevatedButton(
              onPressed: _uploadFile,
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Change the button color as needed
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Adjust the border radius
                ),
              ),
              child: Text(
                'Upload Video',
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 16.0, // Font size
                  fontWeight: FontWeight.bold, // Font weight
                ),
              ),
            ),
          ),
          if (isUploading) // Show progress indicator when uploading
            Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "wait...your video is uploading",
                  style: TextStyle(color: Colors.blue),
                )
              ],
            )),
        ]),
      ),
    );
  }
}
