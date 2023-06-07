import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ults/New_Routes.dart';
import 'ults/error.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  var search = TextEditingController();
  var UpdatedValue = TextEditingController();
  void signout()
  {
    _auth.signOut().then((value) { Navigator.pushNamed(context, Routes.Login);}).onError((error, stackTrace) {
      errorMessage().loadError(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,title: Text("Home Screen"),
        actions: [
          IconButton(onPressed: signout, icon: Icon(Icons.logout_outlined)),
          SizedBox(width: 10,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(

              decoration: InputDecoration(
                hintText: 'Search Data',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value)
              {
                setState(() {
                  search.text=value;
                  controller: search;

                });
              },

            ),
           Expanded(
             child:StreamBuilder(
               stream: ref.onValue,
              builder: (context,AsyncSnapshot<DatabaseEvent>  snapshot){
                 if(!snapshot.hasData)
                   {
                       return Text("Nothing FOUND");
                   }else
                     {
                       Map<dynamic,dynamic> map=snapshot.data!.snapshot.value as dynamic;
                       List<dynamic> list =[];
                       list.clear();
                       list=map.values.toList();

                       return ListView.builder(
                           itemCount:snapshot.data!.snapshot.children.length ,
                           itemBuilder: (context,index){
                             String title = list[index]['data'].toString();
                              if(search.text.isEmpty)
                                {
                                  print(title);
                                  return Card(
                                    child: ListTile(
                                      title: Text(list[index]['data'].toString()),
                                      subtitle: Text(list[index]['date'].toString()+" "+ list[index]['time'].toString()),
                                      trailing: PopupMenuButton(
                                        icon: Icon(Icons.more_vert),
                                          itemBuilder: (context)=>[
                                            PopupMenuItem(
                                              value:1,
                                                child: ListTile(
                                                  leading: Icon(Icons.edit),
                                                  title: Text("Edit"),

                                            ),onTap: (){
                                                print("pop Hi");
                                                Navigator.pop(context);
                                                showMyDialog(list[index]['data'].toString(),list[index]['id'].toString() );
                                                print("pop Hi 1");
                                            },),
                                            PopupMenuItem(
                                                value:2,
                                                child: ListTile(
                                                  leading: Icon(Icons.delete),
                                                  title: Text("Delete"),

                                                ),onTap: (){
                                            Navigator.pop(context);

                                            },

                                            )

                                      ]),
                                      leading: ClipOval( child: list[index]['Image'].toString()=="" ? Image.asset('lib/Asserts/Images/NO.jpg',height: 60,width: 60,fit: BoxFit.cover,) : Image.network(list[index]['Image'].toString(),height: 60,width: 60,)),
                                    ),
                                  );
                                }
                              else if(title.toLowerCase().contains(search.text.toLowerCase().toLowerCase()))
                                {
                                  print(title);
                                  return Card(
                                    child: ListTile(
                                      title: Text(list[index]['data'].toString()),
                                      subtitle: Text(list[index]['time'].toString()),
                                      trailing: Text(list[index]['date'].toString()),
                                      leading: ClipOval( child: list[index]['Image'].toString()=="" ? Image.asset('lib/Asserts/Images/NO.jpg',height: 60,width: 60,fit: BoxFit.cover,) : Image.network(list[index]['Image'].toString(),height: 60,width: 60,)),
                                    ),
                                  );
                                }
                              else
                                {
                                  return Container();
                                }


                           });
                     }

              },

            ),
           ),
          ],


        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context,Routes.Post);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.playlist_add_circle_sharp),
      ),
      drawer: Drawer(

      ),
    );

  }
  Future<void> showMyDialog(String title, String id) async {

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        print("Hi show" + id);
        return AlertDialog(
          title: Text("Update"),
          content: Container(
            child: TextField(
              controller: UpdatedValue,
              decoration: InputDecoration(
                hintText: "Update",
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Add your logic to update the value
                String updatedValue = UpdatedValue.text;
                print("Updated value: $updatedValue");
                // Call the update method or perform the necessary actions here

                Navigator.of(context).pop();
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }


}
