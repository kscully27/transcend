import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/modal/pages/multi_page_path_name.dart';
import 'package:trancend/src/router/playground_router_delegate.dart';
import 'package:trancend/src/ui/wolt/button/wolt_elevated_button.dart';
import 'package:trancend/src/ui/wolt/button/wolt_modal_sheet_close_button.dart';
import 'package:trancend/src/ui/wolt/selection_list/wolt_selection_list.dart';
import 'package:trancend/src/ui/wolt/text/modal_sheet_title.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RootSheetPage {
  const RootSheetPage._();

  static final ValueNotifier<bool> _isButtonEnabledNotifier =
      ValueNotifier(false);

  static WoltModalSheetPage build(BuildContext context) {
    const title = 'Choose a use case';
    final container = ProviderScope.containerOf(context);
    
    return WoltModalSheetPage(
      stickyActionBar: ValueListenableBuilder<bool>(
        valueListenable: _isButtonEnabledNotifier,
        builder: (_, value, __) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: WoltElevatedButton(
              onPressed: () => container.read(routerProvider.notifier).goToPage(1),
              enabled: value,
              child: const Text("Let's start!"),
            ),
          );
        },
      ),
      backgroundColor: Colors.transparent,
      pageTitle: const ModalSheetTitle(title),
      hasTopBarLayer: false,
      trailingNavBarWidget: WoltModalSheetCloseButton(
        onClosed: container.read(routerProvider.notifier).closeSheet,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          children: [
            WoltSelectionList<MultiPagePathName>.singleSelect(
              itemTileDataGroup: const WoltSelectionListItemDataGroup(
                group: [
                  WoltSelectionListItemData(
                    title: 'Page with forced max height',
                    value: MultiPagePathName.forcedMaxHeight,
                    isSelected: false,
                  ),
                  WoltSelectionListItemData(
                    title: 'Page with hero image',
                    value: MultiPagePathName.heroImage,
                    isSelected: false,
                  ),
                  WoltSelectionListItemData(
                    title: 'Page with lazy loading list',
                    value: MultiPagePathName.lazyLoadingList,
                    isSelected: false,
                  ),
                  WoltSelectionListItemData(
                    title: 'Page with auto-focus text field',
                    value: MultiPagePathName.textField,
                    isSelected: false,
                  ),
                  WoltSelectionListItemData(
                    title: 'All the pages in one flow',
                    value: MultiPagePathName.allPagesPath,
                    isSelected: false,
                  ),
                ],
              ),
              onSelectionUpdateInSingleSelectionList: (selectedItemData) {
                container
                    .read(routerProvider.notifier)
                    .onPathUpdated(selectedItemData.value);
                _isButtonEnabledNotifier.value = selectedItemData.isSelected;
              },
            ),
            const _AllPagesPushWidget(),
          ],
        ),
      ),
    );
  }
}

class _AllPagesPushWidget extends ConsumerWidget {
  const _AllPagesPushWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          trailing: const Icon(Icons.arrow_forward_ios),
          title: const Text('Alllllll the pages in one flow'),
          subtitle: const Text(
            'Pressing this tile will append the page list and show the next page',
          ),
          onTap: () {
            ref.read(routerProvider.notifier).onPathAndPageIndexUpdated(
                  MultiPagePathName.allPagesPath,
                  1,
                );
          },
        ),
      ],
    );
  }
}
