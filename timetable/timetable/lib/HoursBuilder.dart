import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'Lesson.dart';
import 'LessonBuilder.dart';
import 'LessonModifer.dart';
import 'TimeTable.dart';

class HoursBuilder extends StatefulWidget {
  @override
  _HoursBuilderState createState() => _HoursBuilderState();
}

class _HoursBuilderState extends State<HoursBuilder> {

  // this screen hours
  final List<Lesson> lessons = <Lesson>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Materie")
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: 0.2,
                  child: SvgPicture.asset(
                    'images/schedule.svg',),
                ),
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: lessons.length + 1,
                itemBuilder: (context, index) {
                  return index == lessons.length ?
                  ListTile(
                      onTap: () => waitForHour(context),
                      leading: Icon(Icons.add),
                      title: Text("Voce elenco")
                  ) :
                  ListTile(
                    onTap: () async =>
                        modifyHour(index, context),
                    trailing: Container(
                      color: lessons[index].color,
                      height: 24,
                      width: 24,
                      child: Icon(Icons.chevron_right_outlined),
                    ),
                    leading: Icon(Icons.access_time_outlined),
                    title: Text(lessons[index].name),
                    subtitle: Text(lessons[index].abbreviazione),
                  );

                  // hours[index];
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size(100, 50),
          backgroundColor: Colors.blue,
        ),
        child: Text("Termina", style: TextStyle(color: Colors.white),),
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => TimeTable(lessons: lessons)
              )
          );
        },
      ),
    );
  }

  waitForHour(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    Lesson lesson = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) =>
          LessonBuilder()),
    );
    if (lesson != null) {
      setState(() {
        lessons.add(lesson);
      });
    }
  }

  modifyHour(int index, BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    Lesson modifyLesson = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => LessonModifier(lesson: lessons[index])),
    );
    if (modifyLesson != null) {
      setState(() {
        lessons.removeAt(index);
        lessons.insert(index, modifyLesson);
      });
    }
  }

}
