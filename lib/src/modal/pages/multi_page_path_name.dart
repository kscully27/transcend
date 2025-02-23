import 'package:flutter/cupertino.dart';
import 'package:trancend/src/modal/pages/root_sheet_page.dart';
import 'package:trancend/src/modal/pages/sheet_page_with_forced_max_height.dart';
import 'package:trancend/src/modal/pages/sheet_page_with_hero_image.dart';
import 'package:trancend/src/modal/pages/sheet_page_with_lazy_list.dart';
import 'package:trancend/src/modal/pages/sheet_page_with_text_field.dart';
import 'package:trancend/src/navigation/bottomsheet_declarative_routing.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

enum MultiPagePathName {
  forcedMaxHeight(pageCount: 2, queryParamName: "forcedMaxHeight"),
  heroImage(pageCount: 2, queryParamName: "heroImage"),
  lazyLoadingList(pageCount: 2, queryParamName: "lazyList"),
  textField(pageCount: 2, queryParamName: "textField"),
  allPagesPath(pageCount: 5, queryParamName: "all"),
  // Bottom sheet flows
  defaultIntention(pageCount: 1, queryParamName: "defaultIntention"),
  customIntention(pageCount: 1, queryParamName: "customIntention"),
  previousIntentions(pageCount: 1, queryParamName: "previousIntentions"),
  goals(pageCount: 1, queryParamName: "goals");

  static const defaultPath = MultiPagePathName.allPagesPath;

  final int pageCount;
  final String queryParamName;

  const MultiPagePathName({
    required this.pageCount,
    required this.queryParamName,
  });

  WoltModalSheetPageListBuilder get pageListBuilder {
    WoltModalSheetPage root(BuildContext context) =>
        RootSheetPage.build(context);

    WoltModalSheetPage forcedMaxHeight(
      BuildContext context, {
      bool isLastPage = true,
      required int currentPage,
    }) =>
        SheetPageWithForcedMaxHeight.build(
          context,
          isLastPage: isLastPage,
          currentPage: currentPage,
        );

    WoltModalSheetPage heroImage(
      BuildContext context, {
      bool isLastPage = true,
      required int currentPage,
    }) =>
        SheetPageWithHeroImage.build(
          context,
          isLastPage: isLastPage,
          currentPage: currentPage,
        );

    SliverWoltModalSheetPage lazyList(
      BuildContext context, {
      bool isLastPage = true,
      required int currentPage,
    }) =>
        SheetPageWithLazyList.build(
          context,
          isLastPage: isLastPage,
          currentPage: currentPage,
        );

    WoltModalSheetPage textField(
      BuildContext context, {
      bool isLastPage = true,
      required int currentPage,
    }) =>
        SheetPageWithTextField.build(
          context,
          isLastPage: isLastPage,
          currentPage: currentPage,
        );

    switch (this) {
      case MultiPagePathName.forcedMaxHeight:
        return (context) =>
            [root(context), forcedMaxHeight(context, currentPage: 1)];
      case MultiPagePathName.heroImage:
        return (context) => [root(context), heroImage(context, currentPage: 1)];
      case MultiPagePathName.lazyLoadingList:
        return (context) => [root(context), lazyList(context, currentPage: 1)];
      case MultiPagePathName.textField:
        return (context) => [root(context), textField(context, currentPage: 1)];
      case MultiPagePathName.allPagesPath:
        return (context) => [
              root(context),
              heroImage(context, isLastPage: false, currentPage: 1),
              lazyList(context, isLastPage: false, currentPage: 2),
              textField(context, isLastPage: false, currentPage: 3),
              forcedMaxHeight(context, isLastPage: true, currentPage: 4),
            ];
      // Bottom sheet flows
      case MultiPagePathName.defaultIntention:
        return (context) => buildFlowPages(context, BottomSheetFlowName.defaultIntentionFlow);
      case MultiPagePathName.customIntention:
        return (context) => buildFlowPages(context, BottomSheetFlowName.customIntentionFlow);
      case MultiPagePathName.previousIntentions:
        return (context) => buildFlowPages(context, BottomSheetFlowName.previousIntentionsFlow);
      case MultiPagePathName.goals:
        return (context) => buildFlowPages(context, BottomSheetFlowName.goalsFlow);
    }
  }

  static bool isValidQueryParam(String path, int pageIndex) {
    return MultiPagePathName.values.any(
      (element) =>
          element.queryParamName == path &&
          element.pageCount > pageIndex &&
          pageIndex >= 0,
    );
  }
}
