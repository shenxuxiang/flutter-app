import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class PrivacyAgreement extends BasePage {
  const PrivacyAgreement({super.key, required super.title, super.author = false});

  @override
  State<PrivacyAgreement> createState() => _PrivacyAgreementState();
}

class _PrivacyAgreementState extends BasePageState<PrivacyAgreement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(leading: Icon(QmIcons.back), title: Text(widget.title)));
  }
}
