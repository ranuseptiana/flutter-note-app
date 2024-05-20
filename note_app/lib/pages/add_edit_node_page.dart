import 'package:flutter/material.dart';
import 'package:note_app/database/node_database.dart';
import 'package:note_app/models/node.dart';
import 'package:note_app/widgets/node_form_widgets.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  final _formKey = GlobalKey<FormState>();
  var isUpdateForm = false;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    isUpdateForm = widget.note != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
        actions: [buildButtonSave()],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          isImportant: isImportant,
          number: number,
          title: title,
          description: description,
          onChangeIsImportant: (value) {
            setState(() {
              isImportant = value;
            });
          },
          onChangeNumber: (value) {
            setState(() {
              number = value;
            });
          },
          onChangeTitle: (value) {
            title = value;
          },
          onChangeDescription: (value) {
            description = value;
          },
        ),
      ),
    );
  }

  buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            if (isUpdateForm) {
              // Update Data
              await updateNote();
            } else {
              // Tambah Data
              await addNote();
            }
            // Tutup Halaman
            Navigator.pop(context);
          }
        },
        child: const Text('Save'),
      ),
    );
  }

  Future addNote() async {
    final note = Note(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );

    await NoteDatabase.instance.create(note);
  }

  Future updateNote() async {
    final updateNote = widget.note?.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );

    await NoteDatabase.instance.updateNote(updateNote!);
  }
}
