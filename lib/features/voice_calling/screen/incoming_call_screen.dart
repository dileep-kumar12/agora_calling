import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_voice_calling/api/agora/agora_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../home/model/user_model.dart';

class IncomingCallScreen extends StatefulWidget {
  final User userData;
  const IncomingCallScreen({super.key, required this.userData});

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> with SingleTickerProviderStateMixin {
/// Agora variables ///
  late final RtcEngine _engine;
  String channelId = AgoraConfig.channerName;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;
  ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  late final RtcEngineEventHandler _rtcEngineEventHandler;

  /// Animation variables
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),)..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _init();

  }

  _init() async {
    await _initEngine();
   await _joinChannel();
  }



  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    _engine.unregisterEventHandler(_rtcEngineEventHandler);
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _initEngine() async {
   _engine = createAgoraRtcEngine();
    await _engine.initialize( const RtcEngineContext(
      appId: AgoraConfig.appID,
    ));
    _rtcEngineEventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        print('[onError] err: $err, msg: $msg');
      },

      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        print('[onJoinChannelSuccess] my end d connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int user3, int user1){
        print("this is connection: ${connection}");
        print("this is user3: ${user3}");
        print("this is user1: ${user1}");
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        print(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
          _leaveChannel();
        });
      },
    );

    _engine.registerEventHandler(_rtcEngineEventHandler);

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioMeeting,
    );
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }

    await _engine.joinChannel(
        token: AgoraConfig.appToken,
        channelId: channelId,
        uid: AgoraConfig.uid,
        options: ChannelMediaOptions(
          channelProfile: _channelProfileType,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      isJoined = false;
      openMicrophone = true;
      enableSpeakerphone = true;
      playEffect = false;
    });
  }


  _switchSpeakerphone() async {
    await _engine.setEnableSpeakerphone(!enableSpeakerphone);
    setState(() {
      enableSpeakerphone = !enableSpeakerphone;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Incoming Call'),
        backgroundColor: Colors.transparent,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {

          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.userData.username, style: TextStyle(fontSize: 25),),
            SizedBox(height: 100,),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const CircleAvatar(
                        backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKKTfv6f2AEOCK38R8zpLOP2QJAk-n2PFCKGrFM4hslErf6255MybYaZfJzgYSMG4bFJ0&usqp=CAU"),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 200),
            Row(
              mainAxisAlignment:  widget.userData.callStatus == CallStatus.incoming ? MainAxisAlignment.spaceEvenly
                  :MainAxisAlignment.center,
              children: [
                widget.userData.callStatus == CallStatus.incoming ? IconButton(
                  icon: Icon(Icons.call),
                  onPressed: () {
                    _joinChannel();
                  },
                  iconSize: 40,
                  color: Colors.green,
                ):const SizedBox(),
                IconButton(
                  icon: Icon(Icons.call_end),
                  onPressed: () {
                    _leaveChannel();
                    Navigator.pop(context);
                  },
                  iconSize: 40,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}