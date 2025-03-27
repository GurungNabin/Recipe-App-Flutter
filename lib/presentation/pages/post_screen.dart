import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/bloc/post/bloc/post_bloc.dart';
import 'package:recipe_book/bloc/post/bloc/post_event.dart';
import 'package:recipe_book/bloc/post/bloc/post_state.dart';
import 'package:syntech_nepali_calendar/material/pickers.dart';
import 'package:syntech_nepali_calendar/syntech_nepali_calendar.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(LoadPosts());
  }

  void _showAddPostDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    NepaliDateTime? selectedDate = NepaliDateTime.now();
    NepaliDateTime? startDate = NepaliDateTime.now();
    NepaliDateTime? endDate = NepaliDateTime.now();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Post'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Select Date:'),
                          Text(
                            selectedDate != null
                                ? NepaliDateFormat("MMMM d, y")
                                    .format(selectedDate!)
                                : 'No date selected',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final date = await showMaterialDatePicker(
                                context: context,
                                initialDate:
                                    selectedDate ?? NepaliDateTime.now(),
                                firstDate: NepaliDateTime(1970, 1, 1),
                                lastDate: NepaliDateTime(2250, 12, 31),
                              );
                              if (date != null) {
                                setState(() {
                                  selectedDate = date;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (selectedDate != null) {
                        final newPost = {
                          'title': titleController.text,
                          'description': descriptionController.text,
                          'selectedDate': selectedDate!.toIso8601String(),
                          'startDate': startDate.toIso8601String(),
                          'endDate': endDate.toIso8601String(),
                          'isDone': false,
                        };
                        context.read<PostBloc>().add(AddPost(newPost));
                        Navigator.of(context).pop();
                        print('Adding post: $newPost');
                      } else {
                        // Optionally, show a message if the date is not selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a date')),
                        );
                      }
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showUpdatePostDialog(
      BuildContext context, int index, Map<String, dynamic> currentPost) {
    final TextEditingController titleController =
        TextEditingController(text: currentPost['title']);
    final TextEditingController descriptionController =
        TextEditingController(text: currentPost['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Post'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  final updatedPost = {
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'selectedDate': currentPost['selectedDate'],
                    'startDate': currentPost['startDate'],
                    'endDate': currentPost['endDate'],
                    'isDone': currentPost['isDone'],
                  };
                  context.read<PostBloc>().add(UpdatePost(index, updatedPost));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Manager'),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoaded) {
            final posts = state.posts;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: post['isDone'] ?? false,
                      onChanged: (value) {
                        setState(() {
                          context
                              .read<PostBloc>()
                              .add(TogglePostDone(index, value ?? false));
                        });
                      },
                    ),
                    title: Text(
                      post['title'] ?? 'No Title',
                      style: TextStyle(
                        decoration: (post['isDone'] ?? false)
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['description'] ?? 'No Description'),
                        const SizedBox(height: 5),
                        Text(
                          'Date: ${post['selectedDate'] ?? 'No Date'}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showUpdatePostDialog(context, index, post);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<PostBloc>().add(RemovePost(index));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No post available.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPostDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
