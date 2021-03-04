import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'Lesson.dart';


class LessonBuilder extends StatefulWidget {

  @override
  _LessonBuilderState createState() => _LessonBuilderState();
}

class _LessonBuilderState extends State<LessonBuilder> {
  TextEditingController lessonController;
  TextEditingController acronimoController;
  Color _lessonColor;

  @override
  void initState() {
    lessonController = TextEditingController();
    acronimoController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    lessonController.dispose();
    acronimoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Materia")
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildLessonName(),
            buildAcronimo(),
            Padding(
              padding: const EdgeInsets.only(top: 32.0, bottom: 8),
              child: Center(child: Text("Seleziona un colore per la materia")),
            ),
            buildLessonColor(),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: Builder(
          builder: (context) => _buildButton("Salva", context),
        ),
      ) ,
    );
  }

  _buildButton(String text, BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(100, 50),
        backgroundColor: Colors.blue,
      ),
        onPressed: ()  {
          if (acronimoController.text.isEmpty || lessonController.text.isEmpty
              || _lessonColor == null) {
            final snackBar = SnackBar(content: Text('Dimentichi qualcosa...'));
            // Find the Scaffold in the widget tree and use it to show a SnackBar.
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            Lesson lesson = Lesson(lessonController.text,
                acronimoController.text, _lessonColor);
            // The Yep button returns "Yep!" as the result.
            Navigator.pop(context, lesson);
          }
        },
        child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  buildLessonName() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24),
      child: TextFormField(
          maxLength: 30,
          onChanged: (value) {
            setState(() {
              if (value.length <= 1) {
                setState(() {
                  acronimoController.text = '';
                });
              } else {
                acronimoController.text = value.substring(0, 3).toUpperCase();
              }
            });
          },
          controller: lessonController,
          decoration: InputDecoration(
            errorText: lessonController.text.isEmpty ? '' : null,
            labelText: 'Materia',
          )
      ),
    );
  }

  buildAcronimo() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24),
      child: TextFormField(
          maxLength: 3,
          controller: acronimoController,
          decoration: InputDecoration(
              labelText: "Abbreviazione",
              helperText: "Un'abbreviazione facilita la visualizzazione nella tabella"
          )
      ),
    );
  }


  buildLessonColor() {
    List<Container> colors = [
      Container(height: 32, width: 32, color: Colors.red),
      Container(height: 32, width: 32, color: Colors.blue),
      Container(height: 32, width: 32, color: Colors.green),
      Container(height: 32, width: 32, color: Colors.yellow),
      Container(height: 32, width: 32, color: Colors.orange),
      Container(height: 32, width: 32, color: Colors.pink),
      Container(height: 32, width: 32, color: Colors.purpleAccent),
      Container(height: 32, width: 32, color: Colors.tealAccent),
      Container(height: 32, width: 32, color: Colors.blueGrey),
      Container(height: 32, width: 32, color: Colors.brown),
    ];
    return GridView.builder(
      physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 5),
        itemCount: colors.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(child: colors[index].color == _lessonColor ?
          Stack(
              fit: StackFit.expand,
              children: [
                Opacity(opacity: 0.6, child: colors[index]),
                Icon(Icons.verified)
              ])
              : colors[index],
              onTap: () =>
              {
                setState(() {
                  _lessonColor = colors[index].color;
                })
              });
        }
    );
  }
}
