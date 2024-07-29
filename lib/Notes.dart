import 'package:flutter/material.dart';
import 'main.dart';

class Notes extends StatefulWidget {
  const Notes({super.key, required this.title});
  final String title;

  @override
  State<Notes> createState() => NoteState();
}

class NoteState extends State<Notes> {
  late TextEditingController noteController;
  @override
  void initState()
  {
    super.initState();

    noteController = TextEditingController();
  }
  @override
  void dispose()
  {
    noteController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.black,
        title: Image.asset(
          'Assets/Logo.png', fit: BoxFit.scaleDown, scale: 40,),
      ),
      body: ListView.builder(
          itemCount: listedNotes.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child: Card(
                child: ListTile(
                  title: Text(listedNotes[index])
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {final noteToAdd = await openDialog();
        if(noteToAdd == null) return;

        setState(() => listedNotes.add(noteToAdd));},
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<String?> openDialog() => showDialog<String>(context: context, builder: (context) => AlertDialog(
    title: const Text("Add new note"),
    content: Column(children: [
      TextField(decoration: const InputDecoration(hintText: "Enter note here"), controller: noteController),
    ],),
    actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop(noteController.text);
      }, child: const Text("Submit"))
    ],
  ));
}


