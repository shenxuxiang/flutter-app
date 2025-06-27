import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class UserAgreement extends BasePage {
  const UserAgreement({super.key, required super.title, super.author = false});

  @override
  State<UserAgreement> createState() => _UserAgreementState();
}

class _UserAgreementState extends BasePageState<UserAgreement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(leading: Icon(QmIcons.back), title: Text(widget.title)));
  }
}
