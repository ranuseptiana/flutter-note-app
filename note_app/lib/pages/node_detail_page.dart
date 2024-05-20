import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database/node_database.dart';
import 'package:note_app/models/node.dart';
import 'package:note_app/pages/add_edit_node_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int id;
  const NoteDetailPage({super.key, required this.id});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  var isLoading = false;

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });
    note = await NoteDatabase.instance.getNoteById(widget.id);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  DateFormat.yMMMMd().format(note.createdTime),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  note.description,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
    );
  }

  Widget editButton() => IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () async {
          if (isLoading) return;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditNotePage(note: note),
            ),
          );
          refreshNote();
        },
      );

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          if (isLoading) return;
          await NoteDatabase.instance.deleteNoteById(widget.id);
          Navigator.pop(context);
        },
      );
}

