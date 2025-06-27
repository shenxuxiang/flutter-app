import 'dart:async';
import 'header.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/models/home.dart';
import 'package:qm_agricultural_machinery_services/api/technology.dart' as api;
import 'package:qm_agricultural_machinery_services/components/module_title.dart';
import 'package:qm_agricultural_machinery_services/pages/technology/reply_module.dart';
import 'package:qm_agricultural_machinery_services/pages/technology/knowledge_module.dart';
import 'package:qm_agricultural_machinery_services/pages/technology/specialist_module.dart';

class TechnologyPage extends StatefulWidget {
  const TechnologyPage({super.key});

  @override
  State<TechnologyPage> createState() => _TechnologyPageState();
}

class _TechnologyPageState extends State<TechnologyPage> {
  List<dynamic> _knowledgeList = [];
  final homeModel = Get.find<HomeModel>();
  late final StreamSubscription<int> subscriptionHomeTabKey;

  @override
  void initState() {
    handleQueryKnowledgeList();
    subscriptionHomeTabKey = homeModel.tabKey.listen(listenHomeTabKeyChange);
    super.initState();
  }

  @override
  dispose() {
    subscriptionHomeTabKey.cancel();
    super.dispose();
  }

  listenHomeTabKeyChange(int homeTabKey) {
    if (homeTabKey == 3) handleQueryKnowledgeList();
  }

  handleQueryKnowledgeList() async {
    final resp = await api.queryKnowledgeList({'pageSize': 3, 'pageNum': 1});
    setState(() {
      _knowledgeList = resp.data['list'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('农技'), scrolledUnderElevation: 0),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Header()),
          const SliverToBoxAdapter(child: ModuleTitle(title: '专家门诊')),
          const SliverToBoxAdapter(child: SpecialistModule()),
          const SliverToBoxAdapter(child: ModuleTitle(title: '热门知识', link: '/knowledge_base')),
          SliverToBoxAdapter(child: KnowledgeModule(sourceList: _knowledgeList)),
          const SliverToBoxAdapter(child: ModuleTitle(title: '热门回答')),
          const SliverToBoxAdapter(child: ReplyModule()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
