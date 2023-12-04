import 'package:flutter/material.dart';
import '../utils/index.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getBottomNavigationBar(context, 1),
        body: Scaffold(
          backgroundColor: Colors.black,
        ),
        floatingActionButton: const FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: null,
            child: Icon(
              Icons.add,
              color: Colors.white,
            )));
  }
}