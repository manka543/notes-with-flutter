import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_bloc.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_events.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_states.dart';

class AddOrEditNoteView extends StatefulWidget {
  const AddOrEditNoteView({Key? key}) : super(key: key);

  @override
  State<AddOrEditNoteView> createState() => _AddOrEditNoteViewState();
}

class _AddOrEditNoteViewState extends State<AddOrEditNoteView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddOrEditNoteBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Note"),
        ),
        body: BlocConsumer<AddOrEditNoteBloc, AddOrEditNoteState>(
          listener: (context, state) {
            context.read<AddOrEditNoteBloc>().add(const CreateEmptyNoteEvent());
          },
          builder: (context, state) {
            if (state is AddOrEditNoteInitialState) {
              context.read<AddOrEditNoteBloc>().add(const CreateEmptyNoteEvent());
              return const Center(child: CircularProgressIndicator());
            } else if (state is AddOrEditNoteStateValid) {
              return const Text("add or edit state valid");
            } else if (state is AddOrEditNoteStateLoading) {
              return const Text("loading text");
            } else if (state is AddOrEditNoteStateError) {
              return const Text("Error");
            } else {
              return const Text("invalid state");
            }
          },
        ),
      ),
    );
  }
}
