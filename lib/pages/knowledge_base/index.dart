import '../../common/qm_icons.dart';
import '../../components/search_page.dart';
import 'knowledge_item.dart';
import 'page_item.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/keep_alive.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/components/category_widget.dart';
import 'package:qm_agricultural_machinery_services/api/technology.dart' show queryCategoryList;
import 'package:qm_agricultural_machinery_services/api/technology.dart' show queryKnowledgeList;

class KnowledgeBasePage extends BasePage {
  const KnowledgeBasePage({super.key, required super.title, required super.author});

  @override
  State<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends BasePageState<KnowledgeBasePage> {
  final List<Category> _categoryList = [];
  late final PageController _pageController;
  int _tabIndex = 0;

  @override
  void initState() {
    _tabIndex = int.parse(Get.parameters['tab'] ?? '0');
    _pageController = PageController(initialPage: _tabIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCategoryList();
    });
    super.initState();
  }

  loadCategoryList() async {
    final closeLoading = Loading.show(message: '');
    try {
      final resp = await queryCategoryList();
      setState(() {
        for (final item in resp.data) {
          debugPrint('$item');
          _categoryList.add(Category.fromJson(item));
        }
      });
    } finally {
      closeLoading();
    }
  }

  handlePageChange(int index) {
    if (_tabIndex == index) return;
    setState(() => _tabIndex = index);
  }

  handleCategoryChange(int index) {
    setState(() => _tabIndex = index);
    _pageController.jumpToPage(index);
  }

  Widget goodsItemBuilder(BuildContext context, dynamic data) {
    return KnowledgeItem(info: data);
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(
          title: widget.title,
          bottom:
              _categoryList.isEmpty
                  ? null
                  : PreferredSize(
                    preferredSize: Size(360.w, 36.w),
                    child: CategoryWidget(
                      index: _tabIndex,
                      categoryList: _categoryList,
                      onChanged: handleCategoryChange,
                    ),
                  ),
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(
                  fullscreenDialog: true,
                  SearchPage(
                    author: false,
                    title: widget.title,
                    itemBuilder: goodsItemBuilder,
                    sliverPadding: EdgeInsets.zero,
                    queryResourceList: queryKnowledgeList,
                  ),
                );
              },
              child: Icon(QmIcons.search, color: const Color(0xFF333333), size: 24.sp),
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: handlePageChange,
          children: [
            for (final item in _categoryList) KeepAliveWidget(child: PageItem(type: item.value)),
          ],
        ),
      ),
    );
  }
}
