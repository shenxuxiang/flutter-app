import 'package:get/get.dart';
import 'package:qm_agricultural_machinery_services/models/measure_land.dart';
import 'package:qm_agricultural_machinery_services/pages/main.dart';
import 'package:qm_agricultural_machinery_services/models/my_farm.dart';
import 'package:qm_agricultural_machinery_services/pages/about_us.dart';
import 'package:qm_agricultural_machinery_services/pages/login/login.dart';
import 'package:qm_agricultural_machinery_services/pages/webview_page.dart';
import 'package:qm_agricultural_machinery_services/pages/my_farm/index.dart';
import 'package:qm_agricultural_machinery_services/pages/update_record.dart';
import 'package:qm_agricultural_machinery_services/pages/my_order/index.dart';
import 'package:qm_agricultural_machinery_services/pages/user_agreement.dart';
import 'package:qm_agricultural_machinery_services/pages/my_demand/index.dart';
import 'package:qm_agricultural_machinery_services/pages/my_farm/add_farm.dart';
import 'package:qm_agricultural_machinery_services/pages/publish/republish.dart';
import 'package:qm_agricultural_machinery_services/pages/register/register.dart';
import 'package:qm_agricultural_machinery_services/pages/privacy_agreement.dart';
import 'package:qm_agricultural_machinery_services/pages/order_detail/index.dart';
import 'package:qm_agricultural_machinery_services/pages/submit_order/index.dart';
import 'package:qm_agricultural_machinery_services/pages/measure_land/index.dart';
import 'package:qm_agricultural_machinery_services/pages/personal_data/index.dart';
import 'package:qm_agricultural_machinery_services/pages/user_location/index.dart';
import 'package:qm_agricultural_machinery_services/pages/knowledge_base/index.dart';
import 'package:qm_agricultural_machinery_services/pages/address_manage/index.dart';
import 'package:qm_agricultural_machinery_services/pages/product_detail/index.dart';
import 'package:qm_agricultural_machinery_services/pages/modify_personal_data.dart';
import 'package:qm_agricultural_machinery_services/pages/knowledge_base/detail.dart';
import 'package:qm_agricultural_machinery_services/pages/service/demand_detail.dart';
import 'package:qm_agricultural_machinery_services/pages/service/land_transfer.dart';
import 'package:qm_agricultural_machinery_services/pages/service/labor_services.dart';
import 'package:qm_agricultural_machinery_services/pages/identity_auth/view_auth.dart';
import 'package:qm_agricultural_machinery_services/pages/service/plant_protection.dart';
import 'package:qm_agricultural_machinery_services/pages/policy_information/index.dart';
import 'package:qm_agricultural_machinery_services/pages/policy_information/detail.dart';
import 'package:qm_agricultural_machinery_services/pages/identity_auth/camera_page.dart';
import 'package:qm_agricultural_machinery_services/pages/identity_auth/farmer_auth.dart';
import 'package:qm_agricultural_machinery_services/pages/identity_auth/identity_auth.dart';
import 'package:qm_agricultural_machinery_services/pages/modify_receiving_address/index.dart';
import 'package:qm_agricultural_machinery_services/pages/my_farm/farm_field_setting_page.dart';
import 'package:qm_agricultural_machinery_services/pages/service/agricultural_material/index.dart';
import 'package:qm_agricultural_machinery_services/pages/service/agricultural_machinery/index.dart';
import 'package:qm_agricultural_machinery_services/pages/identity_auth/agricultural_machinery_driver_auth.dart';

final routes = [
  GetPage(name: '/', page: () => const MainPage(title: '首页', author: false)),
  GetPage(
    name: '/login',
    // 关闭右滑返回上一页
    popGesture: false,
    page: () => const LoginPage(title: '登录', author: false),
  ),
  GetPage(name: '/register', page: () => const Register(title: '注册', author: false)),
  GetPage(name: '/user_agreement', page: () => const UserAgreement(title: '用户协议', author: false)),
  GetPage(
    name: '/privacy_agreement',
    page: () => const PrivacyAgreement(title: '隐私协议', author: false),
  ),
  GetPage(
    name: '/service/agricultural_material',
    page: () => const AgriculturalMaterialPage(title: '农资服务', author: false),
  ),
  GetPage(
    name: '/service/agricultural_machinery',
    page: () => const AgriculturalMachineryPage(title: '农机服务', author: false),
  ),
  GetPage(
    name: '/service/plant_production',
    page: () => const PlantProtectionPage(title: '植保服务', author: false),
  ),
  GetPage(
    name: '/service/labor_services',
    page: () => const LaborServicesPage(title: '劳务服务', author: false),
  ),
  GetPage(
    name: '/service/land_transfer',
    page: () => const LandTransferPage(title: '土地流转', author: false),
  ),
  GetPage(
    name: '/service/demand_detail',
    page: () => const ServiceDemandDetail(title: '需求详情', author: true),
  ),
  GetPage(name: '/product_detail', page: () => const ProductDetailPage(title: '详情', author: false)),
  GetPage(name: '/submit_order', page: () => const SubmitOrderPage(title: '提交订单', author: true)),
  GetPage(
    name: '/modify_receiving_address',
    page: () => const ModifyReceivingAddressPage(title: '添加/修改地址', author: true),
  ),
  GetPage(name: '/user_location', page: () => const UserLocationPage(title: '用户定位', author: true)),
  GetPage(
    name: '/address_manage',
    page: () => const AddressManagePage(title: '地址管理', author: true),
  ),
  GetPage(name: '/update_record', page: () => const UpdateRecordPage(title: '更新记录', author: true)),
  GetPage(name: '/personal_data', page: () => const PersonalDataPage(title: '个人资料', author: true)),
  GetPage(
    name: '/modify_personal_data',
    page: () => const ModifyPersonalDataPage(title: '修改个人资料', author: true),
  ),
  GetPage(name: '/about_us', page: () => const AboutUsPage(title: '关于我们', author: true)),
  GetPage(name: '/my_order', page: () => const MyOrderPage(title: '我的订单', author: true)),
  GetPage(name: '/order_detail', page: () => const OrderDetailPage(title: '订单详情', author: true)),
  GetPage(name: '/identity_auth', page: () => const IdentityAuthPage(title: '认证新身份', author: true)),
  GetPage(
    name: '/identity_auth/farmer_auth',
    page: () => const FarmerAuthPage(title: '农户认证', author: true),
  ),
  GetPage(
    name: '/identity_auth/agricultural_machinery_driver_auth',
    page: () => const AgriculturalMachineryDriver(title: '农机手认证', author: true),
  ),
  GetPage(
    name: '/identity_auth/view_auth',
    page: () => const ViewAuthPage(title: '查看农户认证', author: true),
  ),
  GetPage(
    name: '/identity_auth/camera_page',
    page: () => const CameraPage(title: '相机', author: true),
  ),
  GetPage(name: '/knowledge_base', page: () => const KnowledgeBasePage(title: '知识库', author: true)),
  GetPage(
    name: '/knowledge_base/detail',
    page: () => const KnowledgeBaseDetailPage(title: '知识库详情', author: true),
  ),
  GetPage(
    name: '/policy_information',
    page: () => const PolicyInformationPage(title: '政策资讯', author: true),
  ),
  GetPage(
    name: '/policy_information/detail',
    page: () => const PolicyInformationDetailPage(title: '资讯详情', author: true),
  ),
  GetPage(
    name: '/my_farm',
    page: () => const MyFarmPage(title: '我的农场', author: true),
    binding: BindingsBuilder(() {
      Get.put(MyFarmModel());
    }),
  ),
  GetPage(name: '/my_farm/add_farm', page: () => const AddFarmPage(title: '添加农场', author: true)),
  GetPage(
    name: '/my_farm/farm_field_setting',
    page: () => const FarmFieldSettingPage(title: '地块设置', author: true),
  ),
  GetPage(name: '/webview_page', page: () => const WebViewPage(title: 'web view', author: true)),
  GetPage(name: '/my_demand', page: () => const MyDemandPage(title: '我的需求', author: true)),
  GetPage(name: '/republish', page: () => const RepublishPage(title: '重新发布', author: true)),
  GetPage(
    name: '/measure_land',
    page: () => const MeasureLandPage(title: '测量宝', author: true),
    binding: BindingsBuilder(() {
      Get.put(MeasureLandModel());
    }),
  ),
];
