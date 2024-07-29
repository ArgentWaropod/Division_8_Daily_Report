import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter/services.dart';

class SpreadsheetClass extends StatefulWidget {
  const SpreadsheetClass({super.key, required this.title});
  final String title;

  @override
  State<SpreadsheetClass> createState() => SpreadsheetClassState();
}



class SpreadsheetClassState extends State<SpreadsheetClass> {
  late TextEditingController urlController;
  late TextEditingController nameController;
  @override
  void initState()
  {
    super.initState();
    refreshSpreadsheet();
    nameController = TextEditingController();
    urlController = TextEditingController();
  }
  @override
  void dispose()
  {
    nameController.dispose();
    urlController.dispose();

    super.dispose();
  }

  void refreshSpreadsheet() {
    final data = box.keys.map((key) {
      final item = box.get(key);
      return {"key": key, "Name": item["Name"], "URL": item["URL"]};}).toList();
    List<Map<String, dynamic>> newlist = new List<Map<String, dynamic>>.from(data);

    setState(() {
      spreadsheetList = newlist;
    });
  }
  @override


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.black,
        title: Image.asset(
          'Assets/Logo.png', fit: BoxFit.scaleDown, scale: 40,),
      ),
      body: ListView.builder(
          itemCount: spreadsheetList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child: Card(
                child: ListTile(
                  title: Text(spreadsheetList[index]["Name"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () => openDialog(spreadsheetList[index]["key"], context), icon: const Icon(Icons.edit)),
                      IconButton(onPressed: () => deleteSpreadsheetHive(spreadsheetList[index]["key"]), icon: const Icon(Icons.delete_forever)),
                    ],
                  ),
                ),
              ),
              onTap: () =>
                  {
                    setState(() {
                      selectedSpreadsheet = spreadsheetList[index]["URL"];
                    }),
                    print(selectedSpreadsheet),
                    Navigator.pop(context),}
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {openDialog(null, context);},
        child: const Icon(Icons.add),
      ),
    );
  }
  void openDialog(int? itemKey, BuildContext context)
  {
    if (itemKey != null) {
      final existingItem = spreadsheetList.firstWhere((element) => element['key'] == itemKey);
      nameController.text = existingItem['Name'];
      urlController.text = existingItem['URL'];
    }

    showModalBottomSheet(context: context, elevation: 5, isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 15, left: 15, right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(hintText: 'URL'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () async {
                if (itemKey != null)
                  {
                    updateSpreadsheetHive({"Name": nameController.text, "URL": urlController.text}, itemKey);
                  }
                if (itemKey == null)
                  {
                    createSpreadsheetHive({"Name": nameController.text, "URL": urlController.text});
                  }
                nameController.text = "";
                urlController.text = "";
                Navigator.of(context).pop();
              }, child: Text(itemKey == null ? "Create Spreadsheet" : "Update Spreadsheet"))
            ],
          ),
        ));
  }

  Future<void> createSpreadsheetHive(Map<String, dynamic> newItem) async {
    await box.add(newItem);
    refreshSpreadsheet();
    showCopyShareLink();
  }
  Future<void> updateSpreadsheetHive(Map<String, dynamic> newItem, int key) async {
    await box.put(key, newItem);
    refreshSpreadsheet();
  }
  Future<void> deleteSpreadsheetHive(int key) async {
    await box.delete(key);
    refreshSpreadsheet();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Spreadsheet deleted")));
  }

  Future<void> showCopyShareLink() async{
    return showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
      return AlertDialog(title: const Text ("Spreadsheet created"),
      content: Text("If you haven't already, please copy the following account and share it with the google sheet: $ShareAccount"),
      actions: [
        IconButton(onPressed: (){
          Clipboard.setData(ClipboardData(text: ShareAccount));
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied!")));
        }, icon: const Icon(Icons.copy)),
        TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text("Confirm"))
      ],);
    });
  }

}


