 //
//  AppDelegate.m
//  NIMDemo
//
//  Created by ght on 15-1-21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESAppDelegate.h"
#import "NTESLoginViewController.h"
#import "UIView+Toast.h"
#import "NTESService.h"
#import "NTESNotificationCenter.h"
#import "NTESLogManager.h"
#import "NTESDemoConfig.h"
#import "NTESSessionUtil.h"
#import "NTESMainTabController.h"
#import "NTESLoginManager.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESClientUtil.h"
#import "NTESNotificationCenter.h"
#import "NIMKit.h"
#import "NTESSDKConfigDelegate.h"
#import "NTESCellLayoutConfig.h"
#import "NTESSubscribeManager.h"

#import "NTESBundleSetting.h"
#import <UserNotifications/UserNotifications.h>
#import "TBCityIconFont.h"

#import "NSString+NTES.h"
#import <UIView+Toast.h>
#import <SDWebImageManager.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//集成蒲公英
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
//导入JSpatch
#import <JSPatchPlatform/JSPatch.h>

// iOS10注册APNs所需头 件
#import <UserNotifications/UserNotifications.h>
#import "TYHLoginAjaxHandler.h"
#import "TYHAppLoadSharedInstance.h"
#import "TYHLoginInfoModel.h"

#import "TYHAppLoadSharedInstance.h"
#import "SSChatHandler.h"


//#jpush
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@import PushKit;

NSString *NTESNotificationLogout = @"NTESNotificationLogout";
@interface NTESAppDelegate ()<NIMLoginManagerDelegate,PKPushRegistryDelegate,BMKGeneralDelegate,JPUSHRegisterDelegate>

@property (nonatomic,strong) NTESSDKConfigDelegate *sdkConfigDelegate;

@end

@implementation NTESAppDelegate
{
    BMKMapManager* _mapManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    // 获取BaseURL
    [self initData];
    
    [self setupNIMSDK];
    [self setupServices];
    [self registerPushService];
    [self commonInitListenEvents];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];

    [self setupMainViewController];
    [self setNav];
        
    [self initBaiduMap];
    [self setupServices];
    [self initPGYUpdate];
    
    
    [TBCityIconFont setFontName:@"iconfont"];
    
    //     [JSPatch testScriptInBundle]; //本地测试
    
    //    [JSPatch startWithAppKey:@"d4230c8c18ddd9db"];
    //    [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDbjxT8ybTJCylCgCNVPAgofIuA\nNR9TqDjBrleJpJj3d7p6Vnr+83PmLCdr7n26W+kwF75eZERb64k69CfTFBNz+zWj\nDQLGfHTaToYAy8FmHl9sjLP0r35+Ybcn6opR2o71tdsaWrL3wMVFUKCb03SKLEnK\n5DRYJ6fT83RZ8qogSwIDAQAB\n-----END PUBLIC KEY-----"];
    //        [JSPatch sync]; //放在applicationDidBecomeActive里 .
    

    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"cc3f74cfe0b39f1140baa114"
                          channel:@"ITC"
                 apsForProduction:1
            advertisingIdentifier:nil];
    
    
    DDLogInfo(@"launch with options %@",launchOptions);
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}


#pragma mark - ApplicationDelegate
- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NewV3PushMessage" object:nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    DDLogInfo(@"didRegisterForRemoteNotificationsWithDeviceToken:  %@", deviceToken);
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    DDLogInfo(@"receive remote notification:  %@", userInfo);
    
    
////临时注释
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//
//    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"yes" otherButtonTitles:nil, nil];
//    [alert show];
//
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageNotification" object:userInfo];
    [SSChatHandler handlerPushNotification:userInfo];
    
}

////前台运行 会调用的方法
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void(^)(UNNotificationPresentationOptions))completionHandler {
//    NSDictionary *userInfo = notification.request.content.userInfo;
//    //前台运行推送
//}
//
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
//{
//    NSDictionary *userInfo = response.notification.request.content.userInfo;
//
//    completionHandler();
//}



- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DDLogError(@"fail to get apns token :%@",error);
}

#pragma mark PKPushRegistryDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type
{
    if ([type isEqualToString:PKPushTypeVoIP])
    {
        [[NIMSDK sharedSDK] updatePushKitToken:credentials.token];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type
{
    DDLogInfo(@"receive payload %@ type %@",payload.dictionaryPayload,type);
    NSNumber *badge = payload.dictionaryPayload[@"aps"][@"badge"];
    if ([badge isKindOfClass:[NSNumber class]])
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [badge integerValue];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(NSString *)type
{
    DDLogInfo(@"registry %@ invalidate %@",registry,type);
}


#pragma mark - openURL

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{

    return YES;
}



#pragma mark - misc
- (void)registerPushService
{
    if (@available(iOS 11.0, *))
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted)
            {
                [[UIApplication sharedApplication].keyWindow makeToast:@"请开启推送功能否则无法收到推送通知" duration:2.0 position:CSToastPositionCenter];
            }
        }];
    }
    else
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    //pushkit
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];

    
}


- (void)setupMainViewController
{
    LoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    
    //如果有缓存用户名密码推荐使用自动登录
    if ([account length] && [token length])
    {
        
        [TYHIMHandler sharedInstance].IMShouldEnabled = YES;
        
        
        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
        loginData.account = account;
        loginData.token = token;
        
        [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
        [[NTESServiceManager sharedManager] start];
        NTESMainTabController *mainTab = [[NTESMainTabController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController = mainTab;
        
        
        
        NSString  *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
        NSString  *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
        NSString  *userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
        NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
        
        dispatch_async(dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT), ^{
            TYHLoginAjaxHandler *handler = [TYHLoginAjaxHandler new];
            [handler submitLoginStatusWithLoginName:userName PassWord:password UserID:userID terminalStatus:@"1"];
            [handler LoginWithUserName:userName.length?userName:@"" Password:password.length?password:@"" OrganizationID:organizationID.length?organizationID:@"" andStatus:^(BOOL successful, TYHLoginInfoModel *userInfo) {
                [[NSUserDefaults standardUserDefaults]setValue:userInfo.token forKey:USER_DEFAULT_TOKEN];
                [[NSUserDefaults standardUserDefaults]setValue:userInfo.appCenterUrl forKey:USER_DEFAULT_appCenterUrl];
                [[NSUserDefaults standardUserDefaults]synchronize];
            } failure:^(NSError *error) {
                
            }];
        });
    }
    else
    {
        [self setupLoginViewController];
    }
}

- (void)commonInitListenEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:NTESNotificationLogout
                                               object:nil];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

- (void)setupLoginViewController
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    NTESLoginViewController *loginController = [[NTESLoginViewController alloc] init];
    [loginController loadView];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = nav;
}

#pragma mark - 注销
-(void)logout:(NSNotification *)note
{
    [self doLogout];
}

- (void)doLogout
{
    [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
    [[NTESServiceManager sharedManager] destory];
    [self setupLoginViewController];
}


#pragma NIMLoginManagerDelegate
-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            NSString *clientName = [NTESClientUtil clientName:clientType];
            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [[TYHAppLoadSharedInstance sharedInstance]appWebViewLoadSuccessful:NO];
    }];
}

- (void)onAutoLoginFailed:(NSError *)error
{
    //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
    DDLogInfo(@"onAutoLoginFailed %zd",error.code);
    [self showAutoLoginErrorAlert:error];
}


#pragma mark - logic impl
- (void)setupServices
{
    [[NTESLogManager sharedManager] start];
    [[NTESNotificationCenter sharedCenter] start];
    [[NTESSubscribeManager sharedManager] start];
}

- (void)setupNIMSDK
{
    //配置额外配置信息 （需要在注册 appkey 前完成
    self.sdkConfigDelegate = [[NTESSDKConfigDelegate alloc] init];
    [[NIMSDKConfig sharedConfig] setDelegate:self.sdkConfigDelegate];
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    [[NIMSDKConfig sharedConfig] setMaxAutoLoginRetryTimes:10];
    [[NIMSDKConfig sharedConfig] setMaximumLogDays:[[NTESBundleSetting sharedConfig] maximumLogDays]];
    [[NIMSDKConfig sharedConfig] setShouldCountTeamNotification:[[NTESBundleSetting sharedConfig] countTeamNotification]];
    [[NIMSDKConfig sharedConfig] setAnimatedImageThumbnailEnabled:[[NTESBundleSetting sharedConfig] animatedImageThumbnailEnabled]];
    [NIMSDKConfig sharedConfig].enabledHttpsForInfo = NO;

    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    NSString *appKey        = [[NTESDemoConfig sharedConfig] appKey];
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = [[NTESDemoConfig sharedConfig] apnsCername];
    option.pkCername        = [[NTESDemoConfig sharedConfig] pkCername];
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    
    //注册 NIMKit 自定义排版配置
    [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig new]];
}

#pragma mark - 登录错误回调
- (void)showAutoLoginErrorAlert:(NSError *)error
{
    NSString *message = [NTESSessionUtil formatAutoLoginMessage:error];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"自动登录失败"
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    if ([error.domain isEqualToString:NIMLocalErrorDomain] &&
        error.code == NIMLocalErrorCodeAutoLoginRetryLimit)
    {
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试"
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                LoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
                                                                NSString *account = [data account];
                                                                NSString *token = [data token];
                                                                if ([account length] && [token length])
                                                                {
                                                                    NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
                                                                    loginData.account = account;
                                                                    loginData.token = token;
                                                                    
                                                                    [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
                                                                }
                                                            }];
        [vc addAction:retryAction];
    }
    
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"注销"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
                                                             }];
                                                         }];
    [vc addAction:logoutAction];
    
    [self.window.rootViewController presentViewController:vc
                                                 animated:YES
                                               completion:nil];
}


#pragma mark - MyAdd
-(void)initBaiduMap
{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"0D67ZwQE78ogWS5sgEH4N7MzjmZgRoWa" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //微信登陆的时候需要初始化
    [ShareSDK registerApp:@"1751edfc17c20"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx126f677630d917ce"
                                       appSecret:@"30e2548186f407a05894708cffd9a836"];
                 break;
             default:
                 break;
         }
     }];
}

-(void)initPGYUpdate
{
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"221f512265109ee9d2dc8b2ae254b635"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"221f512265109ee9d2dc8b2ae254b635"];
//    [NSThread sleepForTimeInterval:1.0];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
}

- (void)registerAPNs
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationType types = UIUserNotificationTypeNone;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    
}

#pragma mark - 内存警告处理
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    // 1.取消正在下载的操作
    [manager cancelAll];
    // 2.清除内存缓存
    [manager.imageCache clearMemory];
    
}

-(void)initData
{
    NSString * pathDic = [[NSBundle mainBundle] pathForResource:@"LocalUrlSet.plist" ofType:nil];
    
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:pathDic];
    NSDictionary *localDic = dicArray[0];
    //    NSString *urlName = [localDic objectForKey:@"name"];
    NSString *urlString = [localDic objectForKey:@"url"];
    
    if (![NSString isBlankString:[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_BASEURL]])
    {
        
    }
    else{
        if (![NSString isBlankString:urlString]) {
            [[NSUserDefaults standardUserDefaults]setValue:urlString forKey:USER_DEFAULT_BASEURL];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
}

-(void)v3MessageAction:(NSNotification *)notification{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NewV3PushMessage" object:nil];
    
}

- (void)setNav
{
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置字体颜色
    
    bar.barTintColor = [UIColor TabBarColorGreen];
    
    bar.tintColor = [UIColor whiteColor];
    
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    
}


@end
