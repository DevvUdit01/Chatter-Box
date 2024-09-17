
import 'package:chatter_box/core/models/ChatRoomModel.dart';
import 'package:chatter_box/core/models/MessageModel.dart';
import 'package:chatter_box/core/models/UserModal.dart';
import 'package:chatter_box/features/SearchPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatRoomPage extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseUser;
  final ChatRoomModel? chatroom;
  final UserModel? targetUser;
  const ChatRoomPage({super.key, required this.userModel, required this.firebaseUser, required this.chatroom, required this.targetUser});
  
  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() {
    String msg = _messageController.text.trim();
    _messageController.clear();
    if (msg != "") {
     // print("Message send");
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel!.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
      );

      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom!.chatroomid)
      .collection("messages").doc(newMessage.messageid).set(newMessage.toMap());

      widget.chatroom!.lastMessage=msg;
       FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom!.chatroomid).
       set(widget.chatroom!.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            CircleAvatar(        
             backgroundImage: NetworkImage(widget.targetUser!.profilepic!),
            ),
            const SizedBox(width: 10,),
            Text(widget.targetUser!.fullname.toString()),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("chatrooms")
                    .doc(widget.chatroom!.chatroomid).collection("messages").orderBy("createdon",descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot = snapshot.data as
                         QuerySnapshot;
        
                        return ListView.builder(
                        reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                          
                            return Row(
                              mainAxisAlignment: (currMessage.sender == widget.userModel!.uid)?
                              MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        
                                  decoration: BoxDecoration(
                                borderRadius: (currMessage.sender == widget.userModel!.uid)?
                                const BorderRadius.only(topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                )
                                :const BorderRadius.only(bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                ),
                                color:(currMessage.sender == widget.userModel!.uid)?
                                 Colors.grey : Theme.of(context).colorScheme.secondary,
                              ),
                                  child: Text(currMessage.text.toString(),
                                  style: const TextStyle(color: Colors.white),
                                  )),
                              ],
                            );
                          },
                        );
                      }
                      else if (snapshot.hasError) {
                        return const Center(child: Text("An error occurred! Please check your internet connection"));
                      }
                      else {
                        return const Center(child: Text("Say hi to your new friend"));
                      }
                    }
                    else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(bottom: 5, left: 3, right: 3),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      maxLines: 6,
                      minLines: 1,
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type Something here...",
                        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    }, 
                    icon: const CircleAvatar(backgroundColor: Color(0xFF27F32E),child: Icon(Icons.send),),
                    iconSize: 35,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
