import 'package:cricket_score_app/bloc/cricket_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cricket_bloc.dart';
import '../bloc/cricket_state.dart';

class UserScoresScreen extends StatelessWidget {
  const UserScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live User Data'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserInitial || state is UserLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoadFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => BlocProvider.of<UserBloc>(context).add(StartUserStream()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is UserLoadSuccess) {
            return ListView.builder(
              itemCount: state.userData.users.length,
              itemBuilder: (context, index) {
                final user = state.userData.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(user.id.toString()),
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                  trailing: Text('Age: ${user.age}'),
                );
              },
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}