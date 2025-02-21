import 'package:flutter/material.dart';
import 'package:trancend/src/ui/pond_effect.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  static const routeName = '/demo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pond Effect Demo2'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return PondEffect(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.purpleAccent, Colors.purple],
                ),
              ),
              child: const Center(
                child: Text(
                  'Tap anywhere to see the effect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 