
import 'package:flutter/material.dart';

class IndividulaChatPage extends StatelessWidget{
  const IndividulaChatPage({super.key});

  @override
  Widget build(BuildContext context){
    return  Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.blueAccent,
      title:const Text("Udit Pal"),
          actions:const [
             CircleAvatar(
              radius: 25,
            )
          ],
      ),

     body: Column(
       children: [
       Expanded(child: SizedBox(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin:const EdgeInsets.symmetric(vertical: 2),
                    padding:const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:const BorderRadius.only(topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      ),
                       color: Colors.blue[300],
                    ),
                   
                    child:const Text('Hello'),
                  ),
                ),
              ],
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin:const EdgeInsets.symmetric(vertical: 2),
                    padding:const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:const BorderRadius.only(topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      ),
                       color: Colors.blue[300],
                    ),
                   
                    child:const Text('hey'),
                  ),
                ),
              ],
            )
          ],
        ),
       )),
         _chatInput(),
         
       ],
     ),


    );

  }

  Row _chatInput() {
    return Row(
         children: [
           Expanded(
             child: Padding(
               padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5,top: 10),
               child: Card(
                 child: Row(
                   children: [
                   IconButton(onPressed: (){}, icon: const Icon(Icons.emoji_emotions_outlined)),
                  const Expanded(
                    child: TextField(
                  minLines: 1,
                  maxLines: 6,
                    decoration:InputDecoration(
                      hintText:"Type Something ",
                      hintStyle: TextStyle(color: Colors.blue,fontSize: 18),
                      border: InputBorder.none,
                    ),
                   )),
                   IconButton(onPressed: (){}, icon:const Icon(Icons.image)),
                   ],
                 ),
               ),
             ),
           ),
           MaterialButton(onPressed: (){},
           minWidth: 0,
       shape:const CircleBorder(),
       color: Colors.green,
       child: const Padding(
         padding:  EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 5),
         child: Icon(Icons.send,color: Colors.white,),
       ),
       )
         ],
       );
  }
}