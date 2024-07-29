import 'package:flutter/material.dart';
import 'main.dart';

const List<String> status = <String>['Completed', 'Began', 'Continued'];
const List<String> tasks = <String>['Installation', 'Programming', 'Stripping', 'Prepping', 'Cleaning'];

String statusValue = status.first;
String taskValue = tasks.first;
class Accomplishments extends StatefulWidget {
  const Accomplishments({super.key, required this.title});
  final String title;

  @override
  State<Accomplishments> createState() => AccomplishmentsSate();
}

class AccomplishmentsSate extends State<Accomplishments> {
  late TextEditingController objectController;
  late TextEditingController locationController;
  @override
  void initState()
  {
    super.initState();

    locationController = TextEditingController();
    objectController = TextEditingController();
  }
  @override
  void dispose()
  {
    locationController.dispose();
    objectController.dispose();

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
          itemCount: setUpAccomplishments.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child: Card(
                child: ListTile(
                    title: Text(setUpAccomplishments[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {
                        setState(() {setUpProjections.removeAt(index);});
                      }, icon: const Icon(Icons.delete_forever)),
                    ],
                  )
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {final projectionToAdd = await openDialog();
        if(projectionToAdd == null) return;

        setState(() => setUpAccomplishments.add(projectionToAdd));},
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<String?> openDialog() => showDialog<String>(context: context, builder: (context) => AlertDialog(
    title: const Text("Add new Accomplishment"),
    content: Column(children: [
      TaskDropdown(),
      StatusDropdown(),
      TextField(decoration: const InputDecoration(hintText: "What was completed?"), controller: objectController),
      TextField(decoration: const InputDecoration(hintText: "What building?"), controller: locationController)
    ],),
    actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop("$statusValue $taskValue of ${objectController.text} at ${locationController.text}");
      }, child: const Text("Submit"))
    ],
  ));
}

class TaskDropdown extends StatefulWidget {
  const TaskDropdown({super.key});

  @override
  State<TaskDropdown> createState() => _TaskDropdownState();
}

class _TaskDropdownState extends State<TaskDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        value: statusValue,
        items: status.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onSaved: (String? value) {
          setState(() {
            statusValue = value!;
            print(value);
          });
        }, onChanged: (String? value) {
      setState(() {
        taskValue = value!;
      });
    });
  }
}
class StatusDropdown extends StatefulWidget {
  const StatusDropdown({super.key});

  @override
  State<StatusDropdown> createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<StatusDropdown> {

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        value: taskValue,
        items: tasks.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onSaved: (String? value) {
          setState(() {
            taskValue = value!;
          });
        }, onChanged: (String? value) {
      setState(() {
        taskValue = value!;
      });
    });
  }
}