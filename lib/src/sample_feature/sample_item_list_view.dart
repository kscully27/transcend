import 'package:flutter/material.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/services/firestore.service.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';

class TopicsViewModel extends ChangeNotifier {
  late List<Topic> topics;
  late String errorMessage;
  TopicsViewModel();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Future<void> init() async {
    try {
      topics = await _firestoreService.getTopics();
    } catch (e) {
      errorMessage = 'Could not initialize counter';
    }
    notifyListeners();
  }
}

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  final TopicsViewModel viewModel = TopicsViewModel();
  SampleItemListView({
    super.key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  });

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sample Items'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),

        // To work with lists that may contain a large number of items, it’s best
        // to use the ListView.builder constructor.
        //
        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              return ListView.builder(
                itemCount: viewModel.topics.length,
                itemBuilder: (context, index) {
                  final topic = viewModel.topics[index];
                  return ListTile(
                    title: Text('SampleItem ${topic.title}'),
                    leading: const CircleAvatar(
                      foregroundImage:
                          AssetImage('assets/images/flutter_logo.png'),
                    ),
                  );
                },
              );
            })

        // ListView.builder(
        //   // Providing a restorationId allows the ListView to restore the
        //   // scroll position when a user leaves and returns to the app after it
        //   // has been killed while running in the background.
        //   restorationId: 'sampleItemListView',
        //   itemCount: items.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     final topic = items[index];

        //     return ListTile(
        //       title: Text('SampleItem ${topic.id}'),
        //       leading: const CircleAvatar(
        //         // Display the Flutter Logo image asset.
        //         foregroundImage: AssetImage('assets/images/flutter_logo.png'),
        //       ),
        //       onTap: () {
        //         // Navigate to the details page. If the user leaves and returns to
        //         // the app after it has been killed while running in the
        //         // background, the navigation stack is restored.
        //         Navigator.restorablePushNamed(
        //           context,
        //           SampleItemDetailsView.routeName,
        //         );
        //       }
        //     );
        //   },
        // ),
        );
  }
}
