import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/task_service.dart';
import 'package:todo_app/widgets/add_task.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData=Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child:const Icon(Icons.add),
        onPressed:(){
          Navigator.pushNamed(context, '/addtask');
        }
      ),
      body: Container(
        padding:const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child:Row(
                  children: [
                    Text('hi',style:ThemeData.textTheme.displayMedium),
                    const SizedBox(width: 10,),
                    Text('Jalal',style:ThemeData.textTheme.displayMedium),
                  ],
                  ),
                ),
                CircleAvatar(
                  child: IconButton(
                    onPressed: (){
                      final user=FirebaseAuth.instance.currentUser;
                      AuthService().logout().then((value){
                      Navigator.pushNamedAndRemoveUntil(context,"/", (route) => false);
                    });
                    }, 
                    icon:const Icon(Icons.logout)
                  ),
                 ) 
              ],
            ),
            const SizedBox(height: 15),
            StreamBuilder(
              
              stream:FirebaseFirestore.instance.collection('tasks').snapshots() , 
              builder: (context,snapshot){

                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Center(
                    child:CircularProgressIndicator(),
                  );
                }

                if(snapshot.hasError){
                  return Center(
                    child: Text('some error occured',style: ThemeData.textTheme.displaySmall,),
                  );
                }

                if(snapshot.hasData&&snapshot.data!.docs.isEmpty){
                  return Center(
                    child: Text('no task added',style: ThemeData.textTheme.displaySmall,),
                  );
                }


                if(snapshot.hasData&&snapshot.data!.docs.isNotEmpty){

                  return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      final _taskService=TaskService();
                      final _task=TaskModel.fromJson(snapshot.data!.docs[index]);
                      print(_task);


                      return Card(
                        elevation: 5,
                        color: ThemeData.scaffoldBackgroundColor.withOpacity(0.2),
                        child: ListTile(
                          leading:const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.circle_outlined,color: Colors.white,),
                          ),
                          title: Text(_task.title!,style: ThemeData.textTheme.displaySmall),
                          subtitle: Text(_task.body!,style: ThemeData.textTheme.displaySmall),
                          trailing: Container(
                            width: 100,
                            child: Row(children: [
                              IconButton(
                                onPressed: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>AddTaskView(task: _task,)));
                                },
                                 icon:const Icon(Icons.edit,color: Colors.green,)
                              ),
                              IconButton(
                                onPressed: (){
                                  _taskService.deleteTask(_task.id!);
                                }, 
                                icon:const Icon(Icons.delete,color: Colors.red,)
                              )
                            ],),
                          ),
        
                        ),
                      );
                    }
                  ),
                );

                }

                return const Center(
                  child: CircularProgressIndicator(),
                );

              }


            )  
          ],
        ),
      ),
    );
  }
}


