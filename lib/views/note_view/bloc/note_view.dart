import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/views/note_view/bloc/note_view_bloc.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  int? id;
  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context)!.settings.arguments as int;
    return BlocProvider(
      create: (context) => NoteViewBloc(),
      child: BlocBuilder<NoteViewBloc, NoteViewState>(
        builder: (context, state) {
          if (state is NoteViewInitial) {
            context.read<NoteViewBloc>().add(GetNoteEvent(id!));
            return Scaffold(
              appBar: AppBar(title: const Text("Loading")),
              body: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is NoteViewValid) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.note.title),
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_vert)),
                ],
              ),
              body: Column(
                children: [
                  Text(state.note.title),
                  Text(state.note.text),
                  Text("date: ${state.note.date}"),
                  Text("rememberdate: ${state.note.rememberdate}"),
                ],
              ),
            );
          } else if (state is NoteViewError) {
            return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: const Center(child: Text("An error occured note loading")),
            );
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: const Center(child: Text("An error occured state loading")),
            );
          }
        },
      ),
    );
  }
}
