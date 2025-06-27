import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _sourceList = [
  {
    'question': '水稻秧苗发黄是什么原因？应该如何处理？',
    'answer':
        '水稻秧苗发黄可能是由于养分不足、光照不足或病虫害引起。建议及时补充氮肥，调整灌溉量，必要时可使用叶面肥。具体而言：（1）若叶片呈现均匀黄化且生长迟缓，多因氮素缺乏，可亩施尿素5-8公斤；（2）若老叶叶尖先黄伴有褐斑，需警惕缺钾症状，应追施氯化钾3-5公斤；（3）对长期阴雨导致的光照不足，需及时开沟排水，确保日均光照4小时以上；（4）如发现叶鞘有褐色病斑或叶片出现白色菌丝，可能是立枯病或稻瘟病，可用25%三环唑可湿性粉剂800倍液喷雾防治；（5）对于虫害导致的黄叶，需检查叶背是否有稻飞虱或二化螟幼虫，建议使用5%甲维盐悬浮剂2000倍液进行叶面喷施。建议结合土壤检测调整施肥方案，并在处理后3-5天观察植株恢复情况。',
  },
  {
    'question': '葡萄开花期遇到连续阴雨天气怎么办？',
    'answer':
        '阴雨天气会影响葡萄授粉，建议采取以下措施：（1）及时采用人工辅助授粉；（2）喷施保花保果剂；（3）雨后立即疏通田间排水沟渠，确保畦面不留积水，降低园内湿度，可每亩撒施草木灰30-50公斤调节墒情；（4）阴雨间歇期抓紧喷施0.2%磷酸二氢钾+0.1%硼砂混合液，增强花器抗逆性，配药时每15升药液添加有机硅助剂10毫升以提高附着力；（5）对于设施栽培葡萄，需及时开启补光灯每日增光2-3小时，保持棚内温度白天不低于18℃、夜间不低于12℃；（6）雨后三天内巡查花序，发现灰霉病初期症状（花穗出现浅褐色水渍状斑点）立即使用50%异菌脲悬浮剂1500倍液进行重点防控，同时摘除受损严重的副穗；（7）天气转晴后暂缓摘心修剪，保留50%以上的新梢生长点以调节树势，待坐果稳定后再进行常规夏季修剪。特别提醒需在花后10-15天增施高钙型水溶肥，每亩追施5-8公斤促进幼果发育。',
  },
];

class ReplyModule extends StatelessWidget {
  const ReplyModule({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _sourceList.length; i++)
          Container(
            height: 102.w,
            padding: EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 9.w),
            margin: EdgeInsets.fromLTRB(12.w, i != 0 ? 12.w : 0, 12.w, 0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '问',
                      style: TextStyle(
                        height: 1,
                        fontSize: 14.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _sourceList[i]['question']!,
                        style: TextStyle(
                          height: 1,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 9.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '答',
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 12.sp,
                        color: const Color(0xFFFF4D4F),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _sourceList[i]['answer']!,
                        maxLines: 3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 12.sp,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
