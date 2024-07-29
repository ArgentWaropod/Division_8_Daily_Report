import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:division_8_daily_report/Spreadsheet.dart';
import 'package:division_8_daily_report/Notes.dart';
import 'package:division_8_daily_report/Projections.dart';
import 'package:division_8_daily_report/Accomplishments.dart';
import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "div8-daily-report-app",
  "private_key_id": "ae1846f8a09ff4720a44ce7ac2200066fa0d2522",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC45k5WRmkW/OQq\n5q31vCVAdTGpFCjZKHzLoUfWJR00vvE9PFhCixbmgLzs7v8btGKhgIDuFX1gycD4\n+z42jYZG3sT9dQiyBwy96DpRXsSiZUTYjN6ehfynvnURicyhbsjRpwwZMAPNwVuD\ngyThiU208WLKy23PHliOria/SwStGPkXYe3rupg2i/TQHNxIFdab5m/gaZCxr9jB\ntfENZQJABJpJV2VUTM3jvtzJA62H4bTbkl8D3EPTJGzCvb/H7BUknd6hwZiBKLzQ\nSeejupKLa0O0k/CZGQDN+iJRw9z+pk0VCZZNLEqBStkIUZFYnTTe+DajxD67R9X9\nH0T8a6klAgMBAAECggEAAY+lkazpLjyBtgBZ76fgWKRPVbIfNiuAAj12XHnWaUpD\nbH+Z7ys6zO9r/kQg+0bmnkkgzYx45ob4OMybldz+s+fQRKORqI8kAxEhjOupQAXC\n3baIGqaJn5DyxBckbH3W9uOGLUrufUo9+jpH5sTrVwptXxugmGMVNFSGweQMQg80\nNRO0fAFXuPtj2Ss/y+m+JqETuhQrj9Nb5l3jIVMpFQl+Fx1l+UdlSfifVL0ZU1nd\n8q1gbRHl6TnnLigu9cV2BLbMNMXVvf6ExvSLJr9rqz9MSUWP4jtzx+X8XjLkqzmC\ngP9cq4fBO0YTl25YIzyiEnyI+fXhI0jhvFSUFBcNgQKBgQD69j+PdySsE2FTQTWZ\n2vqlqI2yPqcqPL4ra1K6cEmhzsDdcbGWECIMFi4f/R+hALP3PUAG2CD+VVZVo8Pg\nWPcTVF0oww9T94i+XNR5MwMNdwnZGN4SS902sFawVstKjOEbhHuq8YZA0Ml2WWZE\nJU2n+6sYNX2UX4mKADVU36TtPQKBgQC8nIxdWxDOEbAbcHo+fuZrYYGZAqe7liMn\nS7Dc6mOrm975oZmV5Iku+Rh2dfKD/f2kEzjZ0Jf28ALz7omz9xcINaiJCYy1gN4/\nxh/yKTQ+I6nORvYa2ZHWIv1ieSdcafoPte/Yv2JyY7eT87rEwhFCCZMSyhoNIqyN\nbpSe/lW6CQKBgQC/5/wUtfP6DdvXsT7Oxy/x66FnExf7aXW2eBxL6z+zFwpOi/lT\nmkSe33soBQThtkroHhNO6IjaU+FwHYnUjdNqGZIfcIHRILGVeCEWCRclfcivFaAD\nd7XScyfnMofEG1SsGTQENSsHd2EHOjfElo36ja15FrZP9nqTZ7NgkqBotQKBgQCI\ndGIAsH+p9pYIZAms6TZe/b47Kvaa+nYYWeRtD45oe26H/+gTz7GIMGMIYTDBWaKF\nb/qzavxmhSI9xJgPgXZCVD/IVQZd0gv466f1FOZdBoQ1XpVyu3GNEOdstOZLL8jg\nUOpjT6Mzyvznp2+6JgVCV5b2Aw1x72ITOKuBk9QFsQKBgQCz5neY3H/aKcpjzlMN\neZ4PNfJcGaTd5GKpbvWTVphVqbvVb3DL1i1H9OrmPFX0Dxe/WZG0BmfdQNjwb2mV\nyrDZ5ilK4ErMmElPI2TG/Mgj21r/fdsKvihVAXklrIXjQOB3Bm6CWQN1hxJ/m65E\n6xotd2YuecnrOUyqC8XiEuKmRw==\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets-div8@div8-daily-report-app.iam.gserviceaccount.com",
  "client_id": "110709893700584571632",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets-div8%40div8-daily-report-app.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
@HiveType(typeId: 0)
class Sheets{
  @HiveField(0)
  String url;
  @HiveField(1)
  String name;

  Sheets({required this.url, required this.name});


}
List<String> setUpProjections = [];
List<String> setUpAccomplishments = [];
List<String> listedNotes = [];
List<Map<String, dynamic>> spreadsheetList = [];
String selectedSpreadsheet = "";
var ShareAccount = "gsheets-div8@div8-daily-report-app.iam.gserviceaccount.com";
var regex = RegExp(r'(?<=\/d\/)[^\/]+');
var rightURLType = RegExp(r'https:\/\/docs.google.com\/spreadsheets\/d\/');
var spreadsheet = 'https://docs.google.com/spreadsheets/d/1Q9azJwJFdq2ddWLUxtf6pErWqzwU8l0CrsSesWYzq4k/edit?gid=0#gid=0';
late var box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  box = await Hive.openBox("SavedSpreadsheets");
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Division 8 Daily Report App',
      home: MyHomePage(title: 'Division 8 Daily Report App'),
    );
  }
}

void UpdateGoogleSheet(BuildContext context) async {
  var testedURL = rightURLType.firstMatch(selectedSpreadsheet);
  if(testedURL == null)
  {
    print("URL failed");
    await showError("URL is not in correct file format type. Please use a Google Sheets URL for the spreadsheet", context);
    return;
  }
  RegExpMatch? match = regex.firstMatch(spreadsheet);
  final gsheets = GSheets(_credentials);
  try{
    final ss = await gsheets.spreadsheet(match![0]!);
    print(ss);
    var sheet = ss.worksheetByTitle("Sheet1");
    //Find first empty row
    var firstEmptyAcc = 1;
    while (await sheet?.values.value(column: 2, row: firstEmptyAcc) != '')
    {
      firstEmptyAcc += 1;
    }
    var firstEmptyProj = 1;
    while (await sheet?.values.value(column: 3, row: firstEmptyProj) != '')
    {
      firstEmptyProj += 1;
    }
    var firstEmptyNot = 1;
    while (await sheet?.values.value(column: 4, row: firstEmptyNot) != '')
    {
      firstEmptyNot += 1;
    }
    var values = [firstEmptyNot, firstEmptyProj, firstEmptyAcc];
    var firstEmptyRow = values.max;
    sheet!.values.insertValue("--------------------------------------------", column: 1, row: firstEmptyRow);
    sheet.values.insertValue("--------------------------------------------", column: 2, row: firstEmptyRow);
    sheet.values.insertValue("--------------------------------------------", column: 3, row: firstEmptyRow);
    sheet.values.insertValue("--------------------------------------------", column: 4, row: firstEmptyRow);
    sheet.values.insertValue(DateFormat.yMd().format(DateTime.now()), column: 1, row: firstEmptyRow + 1);
    for (var i = 0; i < setUpProjections.length; i++)
    {
      sheet.values.insertValue(setUpProjections[i], column: 2, row: firstEmptyRow + 1 + i);
    }
    for (var i = 0; i < setUpAccomplishments.length; i++)
    {
      sheet.values.insertValue(setUpAccomplishments[i], column: 3, row: firstEmptyRow + 1 + i);
    }
    for (var i = 0; i < listedNotes.length; i++)
    {
      sheet.values.insertValue(listedNotes[i], column: 4, row: firstEmptyRow + 1 + i);
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Spreadsheet updated!")));
  } catch (e) {
    print("File not accessible");
    return;
  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


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
        title: Image.asset('Assets/Logo.png', fit: BoxFit.scaleDown, scale: 40,),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text("Daily Report"),
            Text("Today's date: ${DateFormat.yMd().format(DateTime.now())}"),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.all(20),
                color: Colors.grey,
                child: const Center(child: Text("Spreadsheet"),),
              ),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const SpreadsheetClass(title: "Title"))).then((_) => setState(() {
              }));},
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.all(20),
                color: Colors.grey,
                child: const Center(child: Text("Accomplishments"),),
              ),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Accomplishments(title: "Title")));},
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.all(20),
                color: Colors.grey,
                child: const Center(child: Text("Projections"),),
              ),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Projections(title: "Title")));},
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.all(20),
                color: Colors.grey,
                child: const Center(child: Text("Notes/Issues"),),
              ),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Notes(title: "Title")));},
            ),
            ElevatedButton(
                onPressed: (selectedSpreadsheet == "")
                    ? null
                    : () async {
                  // Show the confirmation dialog
                  final result = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Ready to Submit?"),
                      content: const Text("Are you sure everything is ready to submit your daily report?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel')
                        ),
                        TextButton(
                            onPressed: () => Navigator.pop(context, 'Submit'),
                            child: const Text('Submit')
                        ),
                      ],
                    ),
                  );

                  // Check the result of the dialog
                  if (result == 'Submit') {
                    // Call UpdateGoogleSheet after dialog result
                    UpdateGoogleSheet(context);
                  }
                },
                child: const Text("Send Report")
            )

          ],
        ),
      ),
    );
  }

}


Future<void> showError(String errorMessage, BuildContext context) async{
  return showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
    return AlertDialog(title: const Text ("ERROR"),
      content: Text(errorMessage),
      actions: [
        TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text("Confirm"))
      ],);
  });
}
