//
//  MainTabController.m
//  NIMDemo
//
//  Created by chris on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESMainTabController.h"
#import "NTESAppDelegate.h"
#import "NTESSessionListViewController.h"
#import "NTESContactViewController.h"
#import "UIImage+NTESColor.h"
#import "NTESCustomNotificationDB.h"
#import "NTESNotificationCenter.h"
#import "NTESNavigationHandler.h"
#import "NTESNavigationAnimator.h"
#import "NTESBundleSetting.h"

#import "TYHNoticeController.h"
#import "TYHContacterListController.h"
#import "NTESUserInfoSettingViewController.h"
#import "QCSchoolMainController.h"


#define TabbarVC    @"vc"
#define TabbarTitle @"title"
#define TabbarImage @"image"
#define TabbarSelectedImage @"selectedImage"
#define TabbarItemBadgeValue @"badgeValue"
#define TabBarCount 4

typedef NS_ENUM(NSInteger,NTESMainTabType) {
    NTESMainTabTypeMessageList,    //聊天
    NTESMainTabTypeContact,        //通讯录
    NTESMainTabTypeChatroomList,   //聊天室
    NTESMainTabTypeSetting,        //设置
    
    NTESMainTabTypeTemp,        //临时
};



@interface NTESMainTabController ()<NIMSystemNotificationManagerDelegate,NIMConversationManagerDelegate>

@property (nonatomic,strong) NSArray *navigationHandlers;

@property (nonatomic,strong) NTESNavigationAnimator *animator;

@property (nonatomic,assign) NSInteger sessionUnreadCount;

@property (nonatomic,assign) NSInteger systemUnreadCount;

@property (nonatomic,assign) NSInteger customSystemUnreadCount;

@property (nonatomic,copy)  NSDictionary *configs;

@end

@implementation NTESMainTabController

+ (instancetype)instance{
    NTESAppDelegate *delegete = (NTESAppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[NTESMainTabController class]]) {
        return (NTESMainTabController *)vc;
    }else{
        return nil;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubNav];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    extern NSString *NTESCustomNotificationCountChanged;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCustomNotifyChanged:) name:NTESCustomNotificationCountChanged object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpStatusBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //会话界面发送拍摄的视频，拍摄结束后点击发送后可能顶部会有红条，导致的界面错位。
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray*)tabbars{
    self.sessionUnreadCount  = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    self.systemUnreadCount   = [NIMSDK sharedSDK].systemNotificationManager.allUnreadCount;
    self.customSystemUnreadCount = [[NTESCustomNotificationDB sharedInstance] unreadCount];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSInteger tabbar = 0; tabbar < TabBarCount; tabbar++) {
        [items addObject:@(tabbar)];
    }
    return items;
}


- (void)setUpSubNav{
    NSMutableArray *handleArray = [[NSMutableArray alloc] init];
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    [self.tabbars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * item =[self vcInfoForTabType:[obj integerValue]];
        NSString *vcName = item[TabbarVC];
        NSString *title  = item[TabbarTitle];
        NSString *imageName = item[TabbarImage];
        NSString *imageSelected = item[TabbarSelectedImage];
        Class clazz = NSClassFromString(vcName);
        UIViewController *vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = NO;
        
        
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        //临时添加,去掉手势冲突
//        nav.interactivePopGestureRecognizer.enabled = NO;
        
        nav.navigationBar.barTintColor= [UIColor TabBarColorGreen];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];//修改title字体颜色
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor TabBarColorGreen] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
        
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[[UIImage imageNamed:imageSelected]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        nav.tabBarItem.tag = idx;
        NSInteger badge = [item[TabbarItemBadgeValue] integerValue];
        if (badge) {
            nav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badge];
        }
        NTESNavigationHandler *handler = [[NTESNavigationHandler alloc] initWithNavigationController:nav];
        nav.delegate = handler;
        
        [vcArray addObject:nav];
        [handleArray addObject:handler];
    }];
    self.viewControllers = [NSArray arrayWithArray:vcArray];
    self.navigationHandlers = [NSArray arrayWithArray:handleArray];
}


- (void)setUpStatusBar{
    UIStatusBarStyle style = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:NO];
}


#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}


- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}


- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}

- (void)messagesDeletedInSession:(NIMSession *)session{
    self.sessionUnreadCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    [self refreshSessionBadge];
}

- (void)allMessagesDeleted{
    self.sessionUnreadCount = 0;
    [self refreshSessionBadge];
}

- (void)allMessagesRead
{
    self.sessionUnreadCount = 0;
    [self refreshSessionBadge];
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    self.systemUnreadCount = unreadCount;
    [self refreshContactBadge];
}

#pragma mark - Notification
- (void)onCustomNotifyChanged:(NSNotification *)notification
{
    NTESCustomNotificationDB *db = [NTESCustomNotificationDB sharedInstance];
    self.customSystemUnreadCount = db.unreadCount;
    [self refreshSettingBadge];
}



- (void)refreshSessionBadge{
    UINavigationController *nav = self.viewControllers[NTESMainTabTypeMessageList];
    nav.tabBarItem.badgeValue = self.sessionUnreadCount ? @(self.sessionUnreadCount).stringValue : nil;
}

- (void)refreshContactBadge{
    UINavigationController *nav = self.viewControllers[NTESMainTabTypeContact];
    NSInteger badge = self.systemUnreadCount;
    nav.tabBarItem.badgeValue = badge ? @(badge).stringValue : nil;
}

- (void)refreshSettingBadge{
    UINavigationController *nav = self.viewControllers[NTESMainTabTypeSetting];
    NSInteger badge = self.customSystemUnreadCount;
    nav.tabBarItem.badgeValue = badge ? @(badge).stringValue : nil;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - Rotate

- (BOOL)shouldAutorotate{
    BOOL enableRotate = [NTESBundleSetting sharedConfig].enableRotate;
    return enableRotate ? [self.selectedViewController shouldAutorotate] : NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    BOOL enableRotate = [NTESBundleSetting sharedConfig].enableRotate;
    return enableRotate ? [self.selectedViewController supportedInterfaceOrientations] : UIInterfaceOrientationMaskPortrait;
}


#pragma mark - VC
- (NSDictionary *)vcInfoForTabType:(NTESMainTabType)type{
    
    if (_configs == nil)
    {
        if ([TYHIMHandler sharedInstance].IMShouldEnabled) {
            _configs = @{
                         @(NTESMainTabTypeMessageList) : @{
                                 TabbarVC           : @"NTESSessionListViewController",
                                 TabbarTitle        : @"消息",
                                 TabbarImage        : @"btn_message_pressed",
                                 TabbarSelectedImage: @"btn_message_normal",
                                 TabbarItemBadgeValue: @(self.sessionUnreadCount)
                                 },
                         @(NTESMainTabTypeContact)     : @{
                                 TabbarVC           : @"NTESContactViewController",
                                 TabbarTitle        : @"通讯录",
                                 TabbarImage        : @"btn_contact_pressed",
                                 TabbarSelectedImage: @"btn_contact_normal",
                                 TabbarItemBadgeValue: @(self.systemUnreadCount)
                                 },
                         @(NTESMainTabTypeChatroomList): @{
                                 TabbarVC           : @"TYHAppMainController",
                                 //                             TabbarVC       :@"TYHNewAppController",
                                 TabbarTitle        : @"应用",
                                 TabbarImage        : @"btn_app_pressed",
                                 TabbarSelectedImage: @"btn_app_normal",
                                 },
                         //                     @(NTESMainTabTypeSetting)     : @{
                         //                             TabbarVC           : @"NTESSettingViewController",
                         //                             TabbarTitle        : @"设置",
                         //                             TabbarImage        : @"btn_settings_normal",
                         //                             TabbarSelectedImage: @"btn_settings_pressed",
                         //                             TabbarItemBadgeValue: @(self.customSystemUnreadCount)
                         //                             }
                         @(NTESMainTabTypeSetting)     : @{
                                 TabbarVC           : @"NTESUserInfoSettingViewController",
                                 TabbarTitle        : @"设置",
                                 TabbarImage        : @"btn_settings_normal",
                                 TabbarSelectedImage: @"btn_settings_pressed",
                                 TabbarItemBadgeValue: @(self.customSystemUnreadCount)
                                 }
                         };
        }
        else
        {
            _configs = @{
                         @(NTESMainTabTypeMessageList) : @{
                                 TabbarVC           : @"TYHNoticeController",
                                 TabbarTitle        : @"消息",
                                 TabbarImage        : @"btn_message_pressed",
                                 TabbarSelectedImage: @"btn_message_normal",
                                 TabbarItemBadgeValue: @(self.sessionUnreadCount)
                                 },
                         @(NTESMainTabTypeContact)     : @{
                                 TabbarVC           : @"TYHContacterListController",
                                 TabbarTitle        : @"通讯录",
                                 TabbarImage        : @"btn_contact_pressed",
                                 TabbarSelectedImage: @"btn_contact_normal",
                                 TabbarItemBadgeValue: @(self.systemUnreadCount)
                                 },
                         @(NTESMainTabTypeChatroomList): @{
                                 TabbarVC           : @"TYHAppMainController",
                                 //                             TabbarVC       :@"TYHNewAppController",
                                 TabbarTitle        : @"应用",
                                 TabbarImage        : @"btn_app_pressed",
                                 TabbarSelectedImage: @"btn_app_normal",
                                 },
                         @(NTESMainTabTypeSetting)     : @{
                                 TabbarVC           : @"NTESUserInfoSettingViewController",
                                 TabbarTitle        : @"设置",
                                 TabbarImage        : @"btn_settings_normal",
                                 TabbarSelectedImage: @"btn_settings_pressed",
                                 TabbarItemBadgeValue: @(self.customSystemUnreadCount)
                                 },
                         //                     @(NTESMainTabTypeTemp)     : @{
                         //                             TabbarVC           : @"QCSchoolMainController",
                         //                             TabbarTitle        : @"青蚕学堂",
                         //                             TabbarImage        : @"btn_circle_pressed",
                         //                             TabbarSelectedImage: @"btn_circle_normal",
                         //                             TabbarItemBadgeValue: @(self.customSystemUnreadCount)
                         //                             }
                         };
        }
    }
    return _configs[@(type)];
}






@end
