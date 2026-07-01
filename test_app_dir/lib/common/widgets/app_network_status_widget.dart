import 'package:flutter/material.dart';
import 'package:test_app_dir/core/utils/connectivity_helper.dart';

class AppNetworkStatusWidget extends StatelessWidget {
  final Widget child;

  const AppNetworkStatusWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityHelper().onConnectivityChanged,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;
        if (!isConnected) {
          return const Scaffold(
            body: Center(
              child: Text('No Internet Connection',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
            ),
          );
        }
        return child;
      },
    );
  }
}
