import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'Chat.dart';

class NormalCall extends StatefulWidget {
  const NormalCall({Key? key, required this.cameras, required this.interests})
      : super(key: key);
  final List<CameraDescription> cameras;
  final List<String> interests;

  @override
  State<NormalCall> createState() => _NormalCallState();
}

class _NormalCallState extends State<NormalCall> {
  MediaStream? _localStream;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peer;
  // 'https://netteam-backend-production.up.railway.app'
  IO.Socket socket = IO.io(dotenv.env['BACKEND_URL'], <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  final configuration = <String, dynamic>{
    'iceServers': [
      {'url': 'stun:stun3.l.google.com:19302'},
    ],
  };

  //For Camera
  // Future<void> accessCam() async {
  //   // final _cameras = await availableCameras();
  //   controller = CameraController(widget.cameras[cameraIndex], ResolutionPreset.max);
  //   controller.initialize().then((_) {
  //     if (!mounted) { return; }
  //     setState(() {});
  //   }).catchError((Object e) {
  //     if (e is CameraException) {
  //       switch (e.code) {
  //         case 'CameraAccessDenied':
  //           // Handle access errors here.
  //           break;
  //         default:
  //           // Handle other errors here.
  //           break;
  //       }
  //     }
  //   });
  // }

  Future<void> initRenderers(List<String> interests) async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await getUserMedia();
    socket.connect();
    socket.emit("reConnect", {'data': interests});
    rtcConnection().then((pc) {
      _peer = pc;
      getTokens();
    });
  }

  Future<void> getUserMedia() async {
    final videoConstraints = <String, dynamic>{
      'facingMode': 'user', // Select the front camera
    };
    final audioConstraints = <String, dynamic>{
      'echoCancellation': true,
    };
    final constraints = <String, dynamic>{
      'audio': audioConstraints,
      'video': videoConstraints,
    };
    try {
      final stream = await navigator.mediaDevices.getUserMedia(constraints);
      if (_localStream != null) {
        // Dispose previous stream and tracks
        _localStream!.getTracks().forEach((track) {
          track.stop();
        });
        _localStream!.dispose();
      }

      _localRenderer.srcObject = stream;
      if (!mounted) return;
      setState(() {
        _localStream = stream;
      });
      print(_localStream);
    } catch (e) {
      print(e.toString());
    }
  }

  Duration remainingDuration = Duration(seconds: 60);
  bool isConnected = false;
  int _imageIndex = 0;
  final List<String> _imagePaths = <String>[
    'assets/images/profile1.png',
    'assets/images/profile2.png',
    'assets/images/profile3.png',
    'assets/images/profile4.png',
    'assets/images/profile5.png',
    'assets/images/profile6.png',
    'assets/images/profile7.png',
    'assets/images/profile8.png',
    'assets/images/profile9.png',
    'assets/images/profile10.png',
  ];
  late Timer _timer;
  late Timer _timer1;
  late String otherSid;
  bool isButtonDisabled = false;
  bool isChatButtonDisabled = false;
  bool chatOpened = false;
  String connectedUserName = "";
  String connectedUserID = "";

  void handleChatClosed(bool isOpened) {
    // Handle the chat state here
    if (!isOpened) {
      chatOpened = false;
      connectedUserID = "";
      connectedUserName = "";
    }
  }

  @override
  void initState() {
    super.initState();
    initRenderers(widget.interests);
    socket.on('create', (userID) async {
      print('Connected as $userID');
      socket.emit('startChat');
    });
    socket.on('chatMatched', (data) {
      otherSid = data['to'];
      sendOffer(data['to']);
    });
    socket.on('chatError', (data) {
      print(data);
    });
    socket.on("ice-candidate", (data) async {
      // print(data);
      final Map<String, dynamic> msg = jsonDecode(data['candidate']);
      // print(msg);
      final sid = data['sourceSocketID'];
      // data.remove('sourceSocketID');
      print('heard an ice');
      await _peer!.addCandidate(RTCIceCandidate(
          msg['candidate'], msg['sdpMid'], msg['sdpMLineIndex']));
    });
    socket.on("call-made", (data) async {
      final Map<String, dynamic> msg = jsonDecode(data['offer']);
      final sid = data['sourceSocketID'];
      otherSid = sid;
      print("source socket $sid");
      // data.remove('sourceSocketID');
      // _peer = await rtcConnection();
      await _peer!
          .setRemoteDescription(RTCSessionDescription(msg['sdp'], msg['type']));
      sendAnswer(sid);
      isConnected = true;
    });
    socket.on("answer-made", (data) async {
      final Map<String, dynamic> msg = jsonDecode(data['answer']);
      final sid = data['sourceSocketID'];
      // data.remove('sourceSocketID');
      try {
        await _peer!.setRemoteDescription(
            RTCSessionDescription(msg['sdp'], msg['type']));
      } catch (e) {
        print(e.toString());
      }
      isConnected = true;
    });
    socket.on('ask-increment', (_) async {
      bool? data = await showConfirmationDialog(context,
          'Connection is offering a 5 min extension. \nDo you confirm?');
      if (data!) {
        remainingDuration =
            Duration(seconds: 300 + remainingDuration.inSeconds);
      }
      showAlertDialog(context, 'Response Sent Successfully!');
      socket.emit('reply-increment', data);
    });
    socket.on('reply-increment', (data) {
      if (data) {
        remainingDuration =
            Duration(seconds: 300 + remainingDuration.inSeconds);
        updateTokens();
      }
      String message = data ? 'Offer accepted!' : 'Offer rejected!';
      showAlertDialog(context, message);
      isButtonDisabled = false;
    });
    socket.on('ask-chat', (data) {
      showConfirmationDialog(context, 'Connection wants to chat. Confirm?')
          .then((reply) {
        if (reply!) {
          socket.emit(
              'reply-chat',
              json.encode(<String, dynamic>{
                "req": reply,
                "id": id,
                "name": name,
              }));
          connectedUserName = data['name'];
          connectedUserID = data['id'];
          chatOpened = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        socket: socket,
                        handleChatClosed: handleChatClosed,
                        name: connectedUserName,
                        userID: connectedUserID,
                      )));
        } else {
          socket.emit(
              'reply-chat',
              json.encode(<String, dynamic>{
                "req": reply,
              }));
          showAlertDialog(context, "Response sent successfully!");
        }
      });
    });
    socket.on('reply-chat', (data) {
      isChatButtonDisabled = false;
      if (data['req']) {
        connectedUserName = data['name'];
        connectedUserID = data['id'];
        chatOpened = true;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      socket: socket,
                      handleChatClosed: handleChatClosed,
                      name: connectedUserName,
                      userID: connectedUserID,
                    )));
      } else {
        showAlertDialog(context, "Offer Rejected!");
      }
    });
    socket.on("hangup", (_) {
      print('disconnected');
      isConnected = false;
      _timer1.cancel();
      beforeConnection();
      socket.emit("reConnect", {'data': widget.interests});
      socket.emit("startChat");
      // Navigator.pop(context, "/videoset");
    });
    // CameraPreview(controller);
    beforeConnection();
  }

  Future<void> updateTokens() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/updateTokens";

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "_id": id,
            "tokens": tokens - 1,
          }));

      if (response.statusCode == 200) {
        // Login successful, process the response data
        // print(myData.id);
        getTokens();
        // Handle the response data according to your needs
        // e.g., store user data in shared preferences, navigate to home screen, etc.
      } else if (response.statusCode == 404) {
        // User not found
        // Handle the error accordingly
      } else {
        // Other error occurred
        // Handle the error accordingly
      }
    } catch (error) {
      // Error occurred during the API call
      // Handle the error accordingly
    }
  }

  void beforeConnection() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (Timer timer) {
      if (!isConnected) {
        if (!mounted) {
          return;
        }
        setState(() {
          if (_imageIndex == _imagePaths.length - 1) {
            _imageIndex = 0;
          }
          _imageIndex++;
        });
      } else {
        if (!mounted) {
          return;
        }
        setState(() {
          _timer.cancel();
          startTimer();
        });
      }
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer1 = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (remainingDuration.inSeconds < 1) {
            _timer1.cancel();
            if (chatOpened) {
              Navigator.pop(context);
              socket.emit("close-chat");
              chatOpened = false;
            }
            Navigator.pop(context, "/videoset");
          } else {
            remainingDuration = remainingDuration - oneSec;
          }
        },
      ),
    );
  }

  String getRemainingSeconds(Duration d) {
    if (d.inSeconds % 60 == 60) {
      return "00";
    } else if (d.inSeconds % 60 < 10) {
      return "0${d.inSeconds % 60}";
    } else {
      return "${d.inSeconds % 60}";
    }
  }

  String getRemainingMinutes(Duration d) {
    if (d.inMinutes < 10) {
      return "0${d.inMinutes}";
    } else {
      return "${d.inMinutes}";
    }
  }

  void _toggleCamera() async {
    if (widget.cameras.length < 2) {
      return; // No other camera available
    }

    final currentCamera =
        _localStream?.getVideoTracks()[0].getSettings()['facingMode'];
    final newCamera = (currentCamera == 'user') ? 'environment' : 'user';

    final videoConstraints = <String, dynamic>{
      'facingMode': newCamera,
    };
    final audioConstraints = <String, dynamic>{
      'echoCancellation': false,
    };

    try {
      final stream = await navigator.mediaDevices.getUserMedia({
        'audio': audioConstraints,
        'video': videoConstraints,
      });
      if (_localStream != null) {
        // Dispose previous stream and tracks
        _localStream!.getTracks().forEach((track) {
          track.stop();
        });
        _localStream!.dispose();
      }
      _localRenderer.srcObject = stream;
      if (!mounted) {
        return;
      }
      setState(() {
        _localStream = stream;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void sendOffer(String sid) async {
    print('Send offer');
    try {
      final offerConstraints = <String, dynamic>{
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true
      };
      final offer = await _peer?.createOffer(offerConstraints);
      await _peer?.setLocalDescription(offer!);
      print('offer Local description set');

      socket.emit(
          "call-user",
          jsonEncode(<String, dynamic>{
            "offer": jsonEncode(<String, dynamic>{
              'type': offer?.type,
              'sdp': offer?.sdp,
            }),
            "targetSocketID": sid,
          }));
    } catch (e) {
      print('Send offer failed: $e');
    }
  }

  void sendAnswer(String sid) async {
    print('Send answer');
    try {
      final answerConstraints = <String, dynamic>{
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      };
      final answer = await _peer?.createAnswer(answerConstraints);
      await _peer?.setLocalDescription(answer!);
      print('answer Local description set');

      socket.emit(
          "make-answer",
          jsonEncode(<String, dynamic>{
            "answer": jsonEncode(<String, dynamic>{
              'type': answer?.type,
              'sdp': answer?.sdp,
            }),
            "targetSocketID": sid,
          }));
    } catch (e) {
      print('Send answer failed: $e');
    }
  }

  Future<bool?> showConfirmationDialog(
      BuildContext context, String message) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmation',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return "No"
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return "Yes"
              },
            ),
          ],
        );
      },
    );
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'System Response',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<RTCPeerConnection> rtcConnection() async {
    final constraints = <String, dynamic>{
      'mandatory': {
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      },
      'optional': [
        {'DtlsSrtpKeyAgreement': true}
      ],
    };
    RTCPeerConnection pc =
        await createPeerConnection(configuration, constraints);

    pc.onIceCandidate = (candidate) {
      print('hello');
      socket.emit(
          "ice-candidate",
          jsonEncode(<String, dynamic>{
            "targetSocketID": otherSid,
            "candidate": jsonEncode(<String, dynamic>{
              'candidate': candidate.candidate,
              'sdpMid': candidate.sdpMid,
              'sdpMLineIndex': candidate.sdpMLineIndex,
            }),
          }));
    };

    pc.onAddStream = (stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
      print("remote stream added");
    };

    _localStream?.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
    });

    print('PeerConnection created');
    return pc;
  }

  @override
  void dispose() async {
    if (isConnected) {
      _timer1.cancel();
    }
    isConnected = false;
    socket.dispose();
    _remoteRenderer.dispose();
    _localRenderer.dispose();
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        track.stop();
      });
    }
    _localStream!.dispose();
    _peer?.dispose();
    _timer.cancel();
    super.dispose();
  }

  late int tokens = 0;
  late String id;
  late String name;
  Future<void> getTokens() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/getTokens";

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "_id": id,
          }));

      if (response.statusCode == 200) {
        // Login successful, process the response data
        // print(myData.id);
        setState(() {
          tokens = json.decode(response.body);
        });
        // print(tokens);
        // Handle the response data according to your needs
        // e.g., store user data in shared preferences, navigate to home screen, etc.
      } else if (response.statusCode == 404) {
        // User not found
        // Handle the error accordingly
      } else {
        // Other error occurred
        // Handle the error accordingly
      }
    } catch (error) {
      // Error occurred during the API call
      // Handle the error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    id = Provider.of<MyDataContainer>(context).id;
    name = Provider.of<MyDataContainer>(context).name;
    // print(id);

    getTokens();

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onDoubleTap: () async {
          _toggleCamera();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    alignment: isConnected ? null : Alignment.center,
                    height: 375.h,
                    width: 390.w,
                    color: const Color(0xFF616161),
                    child: isConnected
                        ? RTCVideoView(
                            _remoteRenderer,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover,
                          )
                        : SizedBox(
                            height: 100.h,
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundImage: AssetImage(
                                _imagePaths[_imageIndex],
                              ),
                            ),
                          ),
                  ),
                  Container(
                    height: 375.h,
                    width: 390.w,
                    color: const Color(0xFF616161),
                    child: RTCVideoView(
                      _localRenderer,
                      mirror: true,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 35.h, left: 13.w),
                height: 30.h,
                width: 60.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xFF212E36).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20.r)),
                child: SizedBox(
                  width: 60.w,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.videocam,
                        color: const Color(0xFFE91C43),
                        size: 15.h,
                      ),
                      Flexible(
                        child: Text(
                            "${getRemainingMinutes(remainingDuration)}:${getRemainingSeconds(remainingDuration)}"),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25.w, 5.h, 25.w, 10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r)),
                      color: const Color(0xFF212E36),
                    ),
                    height: 100.h,
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.keyboard_arrow_up_outlined,
                            color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: isButtonDisabled
                                  ? null
                                  : () {
                                      // Handle extend 5 mins
                                      if (isConnected) {
                                        if (tokens != 0) {
                                          socket.emit('ask-increment');
                                          isButtonDisabled = true;
                                          showAlertDialog(context,
                                              'Offer Sent Successfully!');
                                        } else {
                                          showAlertDialog(
                                              context, 'Not enough tokens!');
                                        }
                                      }
                                    },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Opacity(
                                    opacity: isButtonDisabled ? 0.5 : 1.0,
                                    child: SvgPicture.asset(
                                      "assets/images/extends.svg",
                                      height: 55.h,
                                      width: 55.h,
                                    ),
                                  ),
                                  Positioned(
                                    top: -2,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$tokens',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                //Handle Chat Request
                                if (isConnected) {
                                  isChatButtonDisabled = true;
                                  socket.emit(
                                      'ask-chat',
                                      json.encode(<String, dynamic>{
                                        "id": id,
                                        "name": name,
                                      }));
                                  showAlertDialog(
                                      context, "Request sent successfully!");
                                }
                              },
                              child: SvgPicture.asset(
                                "assets/images/chatRequest.svg",
                                height: 55.h,
                                width: 55.h,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                //Handle End Call
                                // socket.disconnect();
                                Navigator.pop(context, "/videoset");
                              },
                              child: SvgPicture.asset(
                                "assets/images/endCall.svg",
                                height: 55.h,
                                width: 55.h,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
