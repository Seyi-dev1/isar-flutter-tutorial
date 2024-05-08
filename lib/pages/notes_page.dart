import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_isar_crud/models/note.dart';
import 'package:flutter_isar_crud/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //text controller to access what was typed by the user
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    readNotes();
  }

  // create a note
  void createNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              titlePadding: const EdgeInsets.symmetric(vertical: 10),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              actionsPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(
                    labelText: 'New note...',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
              ),
              title: const Center(
                  child: Text(
                'Add a new note',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              )),
              actions: [
                //creat button
                MaterialButton(
                  onPressed: () {
                    //add to db
                    context.read<NoteDatabase>().addNote(textController.text);

                    //clear controller
                    textController.clear();

                    //pop dilog box
                    Navigator.pop(context);
                  },
                  child: const Text('Create'),
                )
              ],
            ));
  }

  //read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  //update note
  void updateNote(Note note) {
    note.text = textController.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              titlePadding: const EdgeInsets.symmetric(vertical: 10),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              actionsPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(
                    labelText: 'New note...',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
              ),
              title: const Center(
                  child: Text(
                'Edit Note',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              )),
              actions: [
                //creat button
                MaterialButton(
                  onPressed: () {
                    //update note in to db
                    context
                        .read<NoteDatabase>()
                        .updateNote(note.id, textController.text);

                    //clear controller
                    textController.clear();

                    //pop dilog box
                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                )
              ],
            ));
  }

  //delete note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    //notes database
    final noteDatabase = context.watch<NoteDatabase>();

    //current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.shade500,
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Colors.blue.shade500,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
          itemCount: currentNotes.length,
          itemBuilder: (context, index) {
            //get individual note
            final note = currentNotes[index];

            //list tile ui
            return ListTile(
              title: Text(note.text),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //edit button
                  IconButton(
                      onPressed: () => updateNote(note),
                      icon: const Icon(Icons.edit)),

                  //delete button
                  IconButton(
                      onPressed: () => deleteNote(index),
                      icon: const Icon(Icons.delete))
                ],
              ),
            );
          }),
    );
  }
}
