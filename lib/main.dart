import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled1/db_helper.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _todoController=TextEditingController();
  List todo=[];

  Future<void> getData() async
  {
    List data=await DatabaseHelper.instance.queryAll();
    data.forEach((element)
    {
      setState((){

    todo.add(element);
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }




  Widget todoCard(Map data){
    return Card(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 25),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:<Widget> [
            Text('${data['task']}',style: TextStyle(fontSize: 18.0)),
            FlatButton(onPressed: ()async{
              await DatabaseHelper.instance.delete(data['id']);
              setState((){
                todo.remove(data);
              });
            },
                child: Icon(Icons.delete,color: Colors.brown,))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        backgroundColor: Colors.brown,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        String task=_todoController.text;
        //insert task
        await DatabaseHelper.instance.insert({
          DatabaseHelper.columntask:task,
        });
          todo.clear();
          await getData();
          _todoController.text='';
      },
        backgroundColor: Colors.brown,
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              TextField(
                style: TextStyle(color: Colors.brown),
                controller: _todoController,
                decoration: InputDecoration(
                  labelText: 'Add TODO task',
                  )
                 ),

            
            Column(
              children: todo.map((data) => todoCard(data)).toList(),
            )
           ]
        ),
      ),

    );
  }
}


