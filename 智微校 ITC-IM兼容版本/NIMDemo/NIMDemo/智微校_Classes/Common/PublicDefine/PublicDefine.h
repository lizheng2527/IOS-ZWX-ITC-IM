//
//  PublicDefine.h
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/10.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#ifndef TYHxiaoxin_PublicDefine_h
#define TYHxiaoxin_PublicDefine_h
#endif
//#define TabBarColorGreen colorWithRed:21 / 255.0 green:153 / 255.0 blue:63 / 255.0 alpha:0.8

#import "TYHIMHandler.h"

//24 171 142
//判定iPhoneX
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define AdjustHeight (kDevice_Is_iPhoneX ? 88 : 64 )

#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)


#define TabBarColorGreen colorWithRed:24 / 255.0 green:171 / 255.0 blue:142/ 255.0 alpha:1.0
#define TabBarColorYellow colorWithRed:237 / 255.0 green:194 / 255.0 blue:75 / 255.0 alpha:1.0

#define TabBarColorRed colorWithRed:175 / 255.0 green:109 / 255.0 blue:195 / 255.0 alpha:0.8

#define TabBarColorOrange colorWithRed:246.0/255 green:139.0/255 blue:64.0/255 alpha:1

#define TabBarColorGray colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1

#define TabBarColorAssetColor colorWithRed:19 / 255.0 green: 137/255.0 blue:218/255.0 alpha:1

#pragma mark - 设备型号识别
#define is_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#pragma mark - 硬件
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

//#define k_V3 @"http://223.202.3.214:8022/dc"

//#define k_V3  @"http://192.168.30.42:9999/dc"

//#define BaseURL @"http://223.202.3.214:9988/im/"

/*
 // 太阳花服务端地址
 public static final String SERVER_ADDRESS_DEFULT = "http://223.202.3.214:9966/im"; // 华为云测试(陈经纶)
 // V3服务端地址
 public static final String SERVER_ADDRESS_V3_DEFULT = "http://58.132.20.15:8088/dc"; //陈经纶V3
 */

#define BaseURL [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_BASEURL]

#define k_V3ServerURL [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3ServerURL]

#define k_MessageDetailURL [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_MessageDetailUrl]

#define ScreenWidth self.view.frame.size.width
#define ScreenHeight self.view.frame.size.height


#define TYHNoTitleAlert(s) {\
UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil  message:(s) delegate:nil \
cancelButtonTitle:@"确定"  otherButtonTitles:nil]; [alert show];}

#define NewNoticeSession @"消息提醒"

#define UserDefault_Connacts    @"UserDefault_Connacts"
#define UserDefault_LoginUser   @"UserDefault_LoginUser"
#define UserDefault_MyName   @"UserDefault_MyName"
#define UserDefault_MyGroup   @"UserDefault_MyGroup"

#define kNotification_registerSuccess @"kNotification_registerSuccess"
#define KNOTIFICATION_HistoryMessageCount @"KNOTIFICATION_HistoryMessageCount"

#define kIsLogin @"kIsLogin"
#define kBackgroundImage @"kBackgroundImage"
#define kNavHeight 64
#define kTabbarHeight 49

#define USER_DEFARLT_AutoLogin @"USER_DEFARLT_AutoLogin"
#define USER_DEFARLT_UserName @"loginName"
#define USER_DEFARLT_APPCODE [NSString stringWithFormat:@"appCode%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFARLT_UserName]]
#define USER_DEFAULT_USERID @"LoginID"
#define USER_DEFAULT_DeapartMentID @"USER_DEFAULT_DeapartMentID"
#define kSetting_serverAddress @"setting_serverAddress"
#define kSet_host @"set_host"
#define USER_DEFAULT_ORIGANIZATION_NAME @"USER_DEFAULT_ORIGANIZATION_NAME"
#define USER_DEFAULT_ORIGANIZATION_ID @"USER_DEFAULT_ORIGANIZATION_ID"
#define USER_DEFAULT_KIND @"USER_DEFAULT_KIND"
///** IM用户身份 **/
//public static final String USER_STUDENT = "0";	//学生
//public static final String USER_PARENT  = "1";	//家长
//public static final String USER_TEACHER = "2";  //教师
//public static final String USER_ADMIN   = "3";	//管理员
//public static final String USER_OTHER   = "4";	//其他

#define USER_DEFAULT_appCenterUrl @"USER_DEFAULT_appCenterUrl"

#define USER_DEFAULT_MessageDetailUrl @"USER_DEFAULT_MessageDetailUrl"

#define HTTPSURL @"https://www.pgyer.com/JLJY"

#define USER_DEFAULT_V3PWD   @"USER_DEFAULT_V3PWD"

#define USER_DEFAULT_PushRegID   @"USER_DEFAULT_PushRegID"

#define USER_DEFAULT_HEADIMAGE_DATA @"USER_DEFAULT_HEADIMAGE_DATA"

#define USER_DEFAULT_V3ID @"USER_DEFAULT_V3ID"

#define USER_DEFAULT_DataSourceName @"USER_DEFAULT_DataSourceName"

#define USER_DEFAULT_BASEURL @"USER_DEFAULT_BASEURL"

#define USER_DEFAULT_V3ServerURL @"USER_DEFAULT_V3ServerURL"

#define USER_DEFAULT_LOGINNAME @"USER_DEFAULT_LOGINNAME"

#define USER_DEFAULT_USERNAME @"USER_DEFAULT_USERNAME"

#define USER_DEFAULT_Item @"USER_DEFAULT_Item"

#define USER_DEFAULT_Content @"USER_DEFAULT_Content"

#define USER_DEFAULT_MOBIENUM @"USER_DEFAULT_MOBIENUM"

#define USER_DEFAULT_PASSWORD @"USER_DEFAULT_PASSWORD"

#define USER_DEFAULT_VOIP @"USER_DEFAULT_VOIP"

#define USER_DEFAULT_TOKEN @"USER_DEFAULT_TOKEN"

#define USER_DEFAULT_FIRST_LOGIN @"USER_DEFAULT_FIRST_LOGIN"

#define NODE_SERVER_URL @"NODE_SERVER_URL"

#define NODE_SERVER_PARAM @"NODE_SERVER_PARAM"

#define USER_DEFAULT_QCXT_URL @"USER_DEFAULT_QCXT_URL"

#define USER_DEFAULT_ID @"USER_DEFAULT_ID"

#define USER_DEFAULT_BIRTHDAY @"USER_DEFAULT_BIRTHDAY"

#define USER_DEFAULT_EMAIL @"USER_DEFAULT_EMAIL"

#define USER_DEFAULT_SEX @"USER_DEFAULT_SEX"

#define USER_DEFAULT_SIGNATURE @"USER_DEFAULT_SIGNATURE"

#define USER_DEFAULT_HeadPortraitUrl @"USER_DEFAULT_HeadPortraitUrl"


#define USER_DEFAULT_DATASOURCE @"USER_DEFAULT_DATASOURCE"
#define DATA_TOTALWEEKNUM @"TOTALWEEKNUM"
#define DATA_USERID @"USERID"
#define DATA_USERDISPLAYNAME @"USERDISPLAYNAME"
#define DATA_USERTYPE @"USERTYPE"
#define USER_DEFAULT_TREEorNot @"USER_DEFAULT_TREEorNot"

#define NewCommentOrReplyNotifion @"NewCommentOrReplyNotifion"

#define NewV3PushMessage @"NewV3PushMessage"
#define NewV3PushMessageTime @"NewV3PushMessageTime"
#define NewV3PushMessageContent @"NewV3PushMessageContent"


//经纶教育
static NSString * const appIdJL = @"f1172ee20fdad4c9cd3f000ba9d0bebf";
//static NSString * const appUrlJL = @"http://58.132.20.16:9966/im";
static NSString * const appUrlJL = @"http://im.bjcjl.net/im";

//太阳花校信
static NSString * const appIdXX = @"e7663ce19a200c649bcf7761dea9fc30";
static NSString * const appUrlXX = @"http://223.202.3.214:9988/im";

//智微校测试
//221f512265109ee9d2dc8b2ae254b635
static NSString * const appIdZWX = @"221f512265109ee9d2dc8b2ae254b635";
//static NSString * const appUrlZWX = @"http://202.108.31.101:9999/im";
static NSString * const appUrlZWX = @"http://www.zdhx-edu.com/im";

//智微校正式
//221f512265109ee9d2dc8b2ae254b635
static NSString * const appIdZWX_ZS = @"221f512265109ee9d2dc8b2ae254b635";
static NSString * const appUrlZWX_ZS = @"http://im.zdhx-edu.com/im";

//智微校-北京汇文中学
static NSString * const appUrlZWX_HWZX = @"http://hwzx.zdhx-edu.com/im";

//智微校-北京天津东提头中学
static NSString * const appUrlZWX_TJ = @"http://tj.zdhx-edu.com/im";

//智微校-马池口
static NSString * const appUrlZWX_MCK = @"http://mck.zdhx-edu.com/im";
//https://oa.zdhx-edu.com/mobile/index-mck.html

//智微校-化大附
static NSString * const appUrlZWX_HDF = @"http://hdfz.zdhx-edu.com/im";
//https://oa.zdhx-edu.com/mobile/index-hdfz.html

//智微校-lyhim龙游湖外语学校
static NSString * const appUrlZWX_LYHIM = @"http://lyhim.zdhx-edu.com/im";
//https://oa.zdhx-edu.com/mobile/index-lyh.html

//智微校-密云六中
static NSString * const appUrlZWX_MYLZ = @"http://mylzim.zdhx-edu.com/im";
//https://oa.zdhx-edu.com/mobile/index-mylz.html

//智微校-CZ龙游湖外语学校
static NSString * const appUrlZWX_CZ = @"http://cz.zdhx-edu.com/im";
//https://oa.zdhx-edu.com/mobile/index-cz.html


////太阳花校信－牛栏山 9999
//static NSString * const appIdXX = @"9e2c7f71ce0c3ab54847a40a964b54a3";
//static NSString * const appUrlXX = @"http://223.202.3.214:9999/im";
