import 'package:flutter/material.dart';
import 'package:mobile_android/domain/entities/user.dart';

class UserInfoCard extends StatelessWidget {
  final User user;

  const UserInfoCard({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
          ],
        ),
      ),
    );
  }
}
