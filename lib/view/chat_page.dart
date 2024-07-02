import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wanderlog/controller/chat_controller.dart';
import 'package:wanderlog/model/message_model.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/util/style.dart';
import 'package:wanderlog/view/widgets/no_data.dart';
import 'package:wanderlog/view/widgets/shimmer_effect.dart';

class ChatPage extends StatefulWidget {
  String anotherUid;
  String url;
  String name;
  ChatPage(
      {super.key,
      required this.anotherUid,
      required this.name,
      required this.url});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FlutterSoundRecorder? _recorder;

  @override
  void initState() {
    _recorder = FlutterSoundRecorder();
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _recorder!.openRecorder();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: WHITE,
            ),
          ),
          title: Row(
            children: [
              widget.url.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(widget.url),
                    )
                  : const SizedBox(),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.name,
                style: poppinStyle(color: WHITE),
              )
            ],
          ),
          backgroundColor: DARK_BLUE_COLOR,
        ),
        body: StreamBuilder(
            stream: CommunicationController().getMessage(
                FirebaseAuth.instance.currentUser!.uid, widget.anotherUid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              List<MessageModel> messages = [];
              messages = snapshot.data!.docs
                  .map((e) =>
                      MessageModel.fromjsone(e.data() as Map<String, dynamic>))
                  .toList();
              return messages.isEmpty
                  ? Center(
                      child: shimmerEffect(
                          child: const Text(
                        "No Messages",
                        style: TextStyle(fontSize: 22),
                      )),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return message(messages[index]);
                      },
                      itemCount: messages.length);
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.add,
              //       color: Colors.black,
              //     )),
              Expanded(
                child: TextFormField(
                  controller: meesaagecontroller,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    hintText: "       Message",
                    filled: true,
                    suffixIconConstraints:
                        BoxConstraints.tightFor(width: width * .25),
                    suffixIcon: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              openCamera().then((value) {
                                if (value != "") {
                                  CommunicationController().sendmessage(
                                      widget.anotherUid, value, "Image");
                                  setState(() {
                                    isImageIsLoading = false;
                                  });
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: DARK_BLUE_COLOR,
                              // size: 22,
                            )),
                        IconButton(
                            onPressed: () {
                              CommunicationController().sendmessage(
                                  widget.anotherUid,
                                  meesaagecontroller.text,
                                  "Text");
                              meesaagecontroller.clear();
                            },
                            icon: const Icon(
                              Icons.send_rounded,
                              color: DARK_BLUE_COLOR,
                            )),
                      ],
                    ),
                    fillColor: GREY.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              IconButton(
                  onPressed: () async {
                    if (isRecording == false) {
                      await _startRecording();
                    } else {
                      _stopRecording().then((value) {
                        if (value != "") {
                          log(value);
                          CommunicationController()
                              .sendmessage(widget.anotherUid, value, "Voice");
                        } else {
                          log("no data");
                        }
                      });
                    }
                  },
                  icon: CircleAvatar(
                    backgroundColor: DARK_BLUE_COLOR,
                    child: Icon(
                      isRecording ? Icons.stop : Icons.mic_rounded,
                      color: WHITE,
                      size: 33,
                    ),
                  ))
            ],
          ),
        ));
  }

  final meesaagecontroller = TextEditingController();

  message(MessageModel messageModel) {
    bool isMe = messageModel.senderID == FirebaseAuth.instance.currentUser!.uid;
    return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(children: [
          if (messageModel.messageType == "Image")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 250,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: isMe
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))
                        : const BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                    color: const Color.fromARGB(255, 146, 193, 202),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(messageModel.message))),
              ),
            ),
          if (messageModel.messageType == "Text")
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: isMe
                      ? const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                  color: GREY.shade300),
              child: Text(messageModel.message),
            ),
          if (messageModel.messageType == "Voice")
            VoiceMessage(
              url: messageModel.message,
              senderID: messageModel.senderID,
            )
        ]));
  }

  File? image;
  bool isImageIsLoading = false;
  Future<String> openCamera() async {
    final chatRoomId = [
      FirebaseAuth.instance.currentUser!.uid,
      widget.anotherUid
    ];
    chatRoomId.sort();
    final ids = chatRoomId.join('_');
    final Timestamp time = Timestamp.now();
    final storage = FirebaseStorage.instance;
    ImagePicker picker = ImagePicker();
    final pickeedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickeedFile == null) return "";

    image = File(pickeedFile.path);
    isImageIsLoading = true;
    setState(() {});
    SettableMetadata metadata = SettableMetadata(contentType: "image/jpeg");

    UploadTask uploadTask =
        storage.ref().child('Chat/$ids/$time').putFile(image!, metadata);

    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  bool isRecording = false;

  Future<void> _startRecording() async {
    if (await Permission.microphone.isGranted) {
      isRecording = true;
      final Timestamp time = Timestamp.now();
      setState(() {});
      try {
        await _recorder!.startRecorder(
          toFile: 'voice_message_$time.aac',
          codec: Codec.aacADTS, // Try a different codec if necessary
          // audioSource: aud,
        );
      } catch (e) {
        log(e.toString());
      }
    } else {
      // Handle microphone permission not granted scenario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is required for recording'),
        ),
      );
    }
  }

  Future<String> _stopRecording() async {
    isRecording = false;
    setState(() {});
    final chatRoomId = [
      FirebaseAuth.instance.currentUser!.uid,
      widget.anotherUid
    ];
    chatRoomId.sort();
    final ids = chatRoomId.join('_');
    final Timestamp time = Timestamp.now();
    final storage = FirebaseStorage.instance;
    return await _recorder!.stopRecorder().then((path) async {
      if (path == null) return "";

      final storageRef = storage.ref().child('$ids/Voice Note/$time');
      await storageRef.putFile(File(path));

      return await storageRef.getDownloadURL();
      // log("========================$value========ooo===============");
    });
  }
}

class VoiceMessage extends StatefulWidget {
  final String url;
  final String senderID;

  VoiceMessage({required this.url, required this.senderID});

  @override
  _VoiceMessageState createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage> {
  FlutterSoundPlayer? _player;

  @override
  void initState() {
    super.initState();
    _player = FlutterSoundPlayer();
    _player!.openPlayer();
  }

  @override
  void dispose() {
    _player!.closePlayer();
    _player = null;
    super.dispose();
  }

  bool isButtonPlaying = false;
  Future<void> _play() async {
    isButtonPlaying = true;
    setState(() {});
    await _player!.startPlayer(
      fromURI: widget.url,
      whenFinished: () {
        isButtonPlaying = false;
        setState(() {});
      },
    );
  }

  Future<void> _stop() async {
    isButtonPlaying = false;
    setState(() {});
    await _player!.stopPlayer();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool isMe = widget.senderID == FirebaseAuth.instance.currentUser!.uid;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: width / 2,
        decoration: BoxDecoration(
          color: GREY.shade300,
          borderRadius: isMe
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20))
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Voice Message'),
            IconButton(
              icon: Icon(isButtonPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                if (isButtonPlaying) {
                  _stop();
                } else {
                  _play();
                }
              },
            )
          ],
        ),

        // onTap: _stop,
      ),
    );
  }
}
