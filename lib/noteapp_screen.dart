import 'package:appwrite_noteapp/appwriteservices.dart';
import 'package:appwrite_noteapp/note.dart';
import 'package:flutter/material.dart';

class NoteappScreen extends StatefulWidget {
  @override
  _NoteappScreenState createState() => _NoteappScreenState();
}

class _NoteappScreenState extends State<NoteappScreen> {
  late AppwriteService _appwriteService;
  late List<Note> _notes;

  final titlecontroller = TextEditingController();
  final subtitlecontroller = TextEditingController();
  final categorycontroller = TextEditingController();
  final datecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _notes = [];
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final tasks = await _appwriteService.getNotes();
      setState(() {
        _notes = tasks.map((e) => Note.fromDocument(e)).toList();
      });
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> _addNote() async {
    final title = titlecontroller.text;
    final subtitle = subtitlecontroller.text;
    final category = categorycontroller.text;
    final date = datecontroller.text;

    if (title.isNotEmpty &&
        subtitle.isNotEmpty &&
        category.isNotEmpty &&
        date.isNotEmpty) {
      try {
        await _appwriteService.addNote(title, subtitle, category, date);
        titlecontroller.clear();
        subtitlecontroller.clear();
        categorycontroller.clear();
        datecontroller.clear();
        _loadNotes();
      } catch (e) {
        print('Error adding task: $e');
      }
    }
  }

  Future<void> _deleteNote(String taskId) async {
    try {
      await _appwriteService.deleteNote(taskId);
      _loadNotes();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Noteapp')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: titlecontroller,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: subtitlecontroller,
                decoration: InputDecoration(
                  labelText: 'Sub Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: categorycontroller,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: datecontroller,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _addNote, child: Text('Add Notes')),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final notes = _notes[index];
                  return ListTile(
                    title: Text(notes.title),
                    subtitle: Column(
                      children: [
                        Text(notes.subtitle),
                        Text(notes.category),
                        Text(notes.date),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteNote(notes.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
