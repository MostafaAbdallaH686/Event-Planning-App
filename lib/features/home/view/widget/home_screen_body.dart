import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cache = CacheHelper();
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              cache.removeData(key: 'isLogin');
              // ignore: use_build_context_synchronously
              context.pushReplacement('/login');
            },
            child: Text("logout")),
      ),
    );
  }
}
