
import 'package:chatter_box/core/models/UserModal.dart';
import 'package:chatter_box/features/IndividualChat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final UserModel userModel;
  final User  firebaseUser;

  const MyHomePage({super.key, required this.userModel, required this.firebaseUser}); 
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _switchValue = false;  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 8,right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   const Text(
                      "Messages",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                      
                        PopupMenuButton<String>(itemBuilder: (context) => [
                          PopupMenuItem(child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             const Text("Theme Mode"),
                              Switch(
                                // This bool value toggles the switch.
                                value: _switchValue,
                                activeColor: Colors.red,
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.
                                  setState(() {
                                    _switchValue = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                       const  PopupMenuItem(child: Text("Help"),),
                       const   PopupMenuItem(child: Text("Logout"),),
                        ],
                        color: Colors.white,
                        )
                  ],
                ),
              ),
            const Padding(
               padding:  EdgeInsets.only(left: 8),
               child: Text("R E C E N T",style: TextStyle(color: Colors.white),),
             ),
              const SizedBox(height: 5,),

             Expanded(
               child: Padding(
                 padding: const EdgeInsets.only(left:8.0),
                 child: ListView(
                 scrollDirection: Axis.horizontal,
                 children: [
                  StatusCart(),
                 const SizedBox(width: 20,),
                  StatusCart(),
                 const SizedBox(width: 20,),
                  StatusCart(),
                 const SizedBox(width: 20,),
                  StatusCart(),
                 const SizedBox(width: 20,),
                  StatusCart(), 
                 const SizedBox(width: 20,),
                 StatusCart(),
                const SizedBox(width: 20,),
                  StatusCart(),
                const SizedBox(width: 20,),
                  StatusCart(),
                const SizedBox(width: 20,),
                  StatusCart(),
                const SizedBox(width: 20,),
               
                 ]
                 ),
               ),
             ),


             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextFormField(
               decoration: InputDecoration(
                prefixIcon:const Padding(
                  padding:  EdgeInsets.only(left: 8.0,right: 8.0,top: 2.0),
                  child: Icon(Icons.search_outlined),
                ),
                hintText: "Search",      
                fillColor: Colors.white,
                filled: true,
               border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide.none), 
               ),
               
               ),
             ),
               Container(
                width: MediaQuery.of(context).size.width,
                height: 380,
              
                decoration:const BoxDecoration(
                    color:Color.fromARGB(255, 55, 54, 54),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
                ),
    
    // list tile chat field is created 

              child: ListView(
                physics:const BouncingScrollPhysics(),
                children: [
                  Column(
                    children: [
                      chatList(),
                      chatList(),
                      chatList(),
                      chatList(),
                      chatList(),
                      chatList(),
                      chatList(),
                      chatList(),
                      chatList(),
                    ],
                  ),
                ],
              )
               )
            ]
          )
      
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      //   child: Icon(Icons.exit_to_app),
      // ),
    );
  }

  ListTile chatList() {
    return ListTile(
                  leading:const CircleAvatar(),
                  title:const Text("udit",style: TextStyle(color: Colors.white)),
                  subtitle:const Text("I am student ",style: TextStyle(color: Colors.white)),
                  trailing:const Text("time",style: TextStyle(color: Colors.white)),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>const IndividulaChatPage()));
                  },
                );
  }

  // ignore: non_constant_identifier_names
  Column StatusCart() {
    return const Column(
                mainAxisAlignment: MainAxisAlignment.start,
               // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                  ), 
                 SizedBox(height: 10,),
                  Text("Name",style: TextStyle(color: Colors.white,fontSize: 18),),
                ],
               );
  }
}



