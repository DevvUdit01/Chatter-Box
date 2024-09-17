
// ignore_for_file: use_build_context_synchronously

import 'package:chatter_box/core/models/ChatRoomModel.dart';
import 'package:chatter_box/core/models/UserModal.dart';
import 'package:chatter_box/features/ChatRoomPage.dart';
import 'package:chatter_box/features/SearchPage.dart';
import 'package:chatter_box/features/user_handling/signin.dart';
import 'package:chatter_box/helper/FirebaseHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseUser;

  const HomePage({super.key,required this.userModel,required this.firebaseUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const Text('Chat App'),
        backgroundColor: Colors.blue,

        actions: [
          IconButton(onPressed: ()async{
          await  FirebaseAuth.instance.signOut();
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const SignIn()));
          }, icon:const Icon(Icons.logout)),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("participants.${widget.userModel!.uid}", isEqualTo: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No Chats"),
              );
            } else {
              final chatRoomSnapshot = snapshot.data!;
              return ListView.builder(
                itemCount: chatRoomSnapshot.docs.length,
                itemBuilder: (context, index) {
                  final chatRoomModel = ChatRoomModel.fromMap(
                  chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);
                  final participants = chatRoomModel.participants;
                  final participantKeys = participants!.keys.toList();
                  participantKeys.remove(widget.userModel!.uid);
        
                  return FutureBuilder<UserModel?>(
                    future: FirebaseHelper.getUserModelById(participantKeys[0]), 
                    builder: (context, userData) {
                      if (userData.connectionState == ConnectionState.done) {
                        if (userData.hasData) {
                          final targetUser = userData.data!;
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatRoomPage(
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser,
                                    chatroom: chatRoomModel,
                                    targetUser: targetUser,
                                  ),
                                ),
                              );
                            },
                            leading:CircleAvatar(
                            backgroundImage: NetworkImage(targetUser.profilepic!),
                            ),
                            title: Text(targetUser.fullname.toString()),
                            subtitle: (chatRoomModel.lastMessage.toString() != "")?
                            Text(chatRoomModel.lastMessage.toString())
                            :const Text("Say hey to your new friend!"),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF27F32E),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser,
              ),
            ),
          );
        },
        tooltip: "Search for chat",
        child:const Icon(Icons.search),
      ),
    );
  }
}
