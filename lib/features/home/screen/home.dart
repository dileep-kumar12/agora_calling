import 'package:agora_voice_calling/features/auth/auth_screen.dart';
import 'package:agora_voice_calling/features/home/model/user_model.dart';
import 'package:agora_voice_calling/features/voice_calling/screen/incoming_call_screen.dart';
import 'package:agora_voice_calling/features/voice_calling/screen/voice_calling_screen.dart';
import 'package:agora_voice_calling/service/auth_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Calling App'),
        actions: [
          InkWell(
            onTap: () async {
             bool isLogout = await AuthService().signOut();
              if(isLogout){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>AuthScreen()));
              }
            },
            child: Text("Logout"),
          )
        ],
      ),
      body: SafeArea(
        top: true,
        child: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userList[index].photoUrl),
            ),
            title: Row(
              children: [
                Text(userList[index].username),
                SizedBox(width: 10),

                userList[index].callStatus == CallStatus.incoming ?
               Icon(Icons.call_received, color: Colors.green):
                userList[index].callStatus == CallStatus.missed? Icon(Icons.call_missed, color: Colors.red)
                    :Icon(Icons.call_made, color: Colors.blue),
              ],
            ),
            subtitle: Text(userList[index].time),
            onTap: () {
              // Handle tap event
            },
            trailing: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>IncomingCallScreen(userData: User(username: 'Dileep', photoUrl: '', time: '', callStatus: CallStatus.outgoing),)));
                  print("calling icon clicked....");
                },
                child: Icon(Icons.call, color: Colors.green)),
          );
        },
      ),
      ),
    );
  }
}

var userList = [
  User(
    username: 'User 1',
    photoUrl: 'https://via.placeholder.com/150',
    time: '10:00 AM',
    callStatus: CallStatus.incoming,
  ),
  User(
    username: 'User 2',
    photoUrl: 'https://via.placeholder.com/150',
    time: '11:00 AM',
    callStatus: CallStatus.missed,
  ),
  User(
    username: 'User 3',
    photoUrl: 'https://via.placeholder.com/150',
    time: '12:00 PM',
    callStatus: CallStatus.outgoing,
  ),
  User(
    username: 'User 1',
    photoUrl: 'https://via.placeholder.com/150',
    time: '10:00 AM',
    callStatus: CallStatus.outgoing,
  ),
  User(
    username: 'User 2',
    photoUrl: 'https://via.placeholder.com/150',
    time: '11:00 AM',
    callStatus: CallStatus.missed,
  ),
  User(
    username: 'User 3',
    photoUrl: 'https://via.placeholder.com/150',
    time: '12:00 PM',
    callStatus: CallStatus.incoming,
  ),
  User(
    username: 'User 1',
    photoUrl: 'https://via.placeholder.com/150',
    time: '10:00 AM',
    callStatus: CallStatus.incoming,
  ),
  User(
    username: 'User 2',
    photoUrl: 'https://via.placeholder.com/150',
    time: '11:00 AM',
    callStatus: CallStatus.missed,
  ),
  User(
    username: 'User 3',
    photoUrl: 'https://via.placeholder.com/150',
    time: '12:00 PM',
    callStatus: CallStatus.missed,
  ),
];