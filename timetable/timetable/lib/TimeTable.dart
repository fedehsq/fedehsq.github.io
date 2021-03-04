import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Lesson.dart';

class TimeTable extends StatefulWidget {
  final List<Lesson> lessons;

  const TimeTable({Key key, this.lessons}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();

}

class _TimeTableState extends State<TimeTable> {
  static final List<bool> toShow = [];
  static final _emptyLesson = Lesson('', '', Colors.transparent);

  final Map<int, List<Lesson>> lessonMatrix = <int, List<Lesson>>{
    for (int i = 1; i <= 10; i++)
      i: [
        _emptyLesson, _emptyLesson, _emptyLesson, _emptyLesson, _emptyLesson,
      ],
  };


  final Map<int, String> hours = <int, String> {
    1 : "8:30/9:30",
    2 : "9:30/10:30",
    3 : "10:30/11:30",
    4 : "11:30/12:30",
    5 : "12:30/13:30",
    6 : "13:30/14:30",
    7 : "14:30/15:30",
    8 : "15:30/16:30",
    9 : "16:30/17:30",
    10 : "17:30/18:30"
  };



  @override
  void initState() {
    for (int i = 0; i < widget.lessons.length; i++) {
      toShow.add(true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orario'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            children: [
              for (int i = 0; i < widget.lessons.length; i++)
                getRowLegend(i),
              getTitle(),
              Table(
                columnWidths: {0: FractionColumnWidth(.1)},
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(color: Colors.black),
                children: [
                  TableRow(children: daysRow()),
                  for (int i = 1; i < 10; i++)
                    TableRow(children: buildRow(i)),
                ],
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Center getTitle() {
    return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0, bottom: 8),
            child: Text('Orario',
              style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        );
  }

  // AGGIUNGERE FLAG TOSHOW NELLA CòASSE TIMETABLE! COSI NON ITERI STRA TANTO!

  getRowLegend(int index) {
    Lesson lesson = widget.lessons[index];
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          Text(lesson.abbreviazione + " = " + lesson.name),
          Switch(
            activeColor: lesson.color,
            value: toShow[index],
            onChanged: (bool newValue) {
              setState(() {
                toShow[index] = newValue;
                Lesson lesson = widget.lessons[index];
                for (int i = 1; i <= 10; i++) {
                  List<Lesson> lessons = lessonMatrix[i];
                  for (int i = 0; i < lessons.length; i++) {
                    if (lessons[i].abbreviazione == lesson.abbreviazione) {
                      lessons[i].toShow = newValue;
                    }
                  }
                }
              });
            },
          )
        ],
      ),
    );
  }

  daysRow() {
    return <Widget>[
      Text(''),
      dayView('Lu'),
      dayView('Ma'),
      dayView('Me'),
      dayView('Gi'),
      dayView('Ve'),
    ];
  }

  dayView(String day) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(day,
              style: TextStyle(
                  fontWeight: FontWeight.bold)
          ),
        )
    );
  }


  Future<Lesson> _showClassDialog() async {
    return showDialog<Lesson>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Materia'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                for (var lesson in widget.lessons)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: lesson.color,
                      title: Text(lesson.name),
                      subtitle: Text(lesson.abbreviazione),
                      onTap: () => Navigator.of(context).pop(lesson),
                    ),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Elimina'),
              onPressed: () {
                Navigator.of(context).pop(_emptyLesson);
              },
            )

          ],
        );
      },
    );
  }

  Future<String> _showTimeDialog() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Modifica orario'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controller,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );
  }

  getColoredContainer(String text, Color color) {
    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Center(child: Text(text)),
      ),
    );
  }

  buildRow(int key) {
    List<Lesson> lessons = lessonMatrix[key];
    return <Widget>[
      InkWell(
        child: getColoredContainer(hours[key], Colors.transparent),
        onTap: () async {
          var h = await _showTimeDialog();
          setState(() {
            hours[key] = h;
          });
        },
      ),
      for (int i = 0; i < lessons.length; i++)
        InkWell(
          onTap: () async {
            Lesson lesson = await _showClassDialog();
            if (lesson != null) {
              setState(() {
                lessons[i] = lesson;
              });
            }
          },
          child: lessons[i].toShow ? getColoredContainer(
              lessons[i].abbreviazione, lessons[i].color)
          /*
    Container(
            color: lessons[i].color,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Center(child: Text(lessons[i].abbreviazione)),
            ),
          ) */
              : getColoredContainer('', Colors.transparent),
        ),

    ];
  }

  hourView(int key) {
    return InkWell(
      child: getColoredContainer(hours[key], Colors.transparent),
      onTap: _showClassDialog,
    );
  }
}
