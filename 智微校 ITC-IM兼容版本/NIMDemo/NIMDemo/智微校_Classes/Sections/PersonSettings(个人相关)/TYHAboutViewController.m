//
//  TYHAboutViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/5/19.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHAboutViewController.h"
#import <UIView+Toast.h>
#import <Social/Social.h>

#import "NSString+NTES.h"
#import <UIView+Toast.h>

#import <PgyUpdate/PgyUpdateManager.h>

@interface TYHAboutViewController ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@end


@implementation TYHAboutViewController{
    UIImageView *erweimaImageView;
    UIButton *copyButton;
    
    UILabel *versionLabel;
    UIButton *checkUpdateBtn;
    NSDictionary *infoDic;
    
    NSMutableArray *shareModelArray;
    NSString *shareTrueDownloadURL;
    NSString *shareTrueCodeImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the vie
    
    [self initView];
    [self changeLeftBar];
    
}

-(void)initView
{
    [self returnShareURL];
    
    self.title = @"关于";
    self.view.backgroundColor = [UIColor whiteColor];
    erweimaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(75, 60 + 64, [UIScreen mainScreen].bounds.size.width - 150 , [UIScreen mainScreen].bounds.size.width - 150)];
    erweimaImageView.image = [UIImage
                              imageNamed:shareTrueCodeImage];
    erweimaImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:erweimaImageView];
    
    copyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [copyButton setTitle:@"复制下载链接" forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    copyButton.frame = CGRectMake(60, 35 + [UIScreen mainScreen].bounds.size.width - 120 + 20 + 64, [UIScreen mainScreen].bounds.size.width - 120, 40);
    copyButton.backgroundColor = [UIColor colorWithRed:24 / 255.0 green:171 / 255.0 blue:142/ 255.0 alpha:0.9];
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyButton.layer.masksToBounds = YES;
    copyButton.layer.cornerRadius = 3;
    [self.view addSubview:copyButton];
    [copyButton addTarget:self action:@selector(copyUrlAction) forControlEvents:UIControlEventTouchUpInside];
    
    versionLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 80, [UIScreen mainScreen].bounds.size.height - 125 , 160, 20)];
    versionLabel.font = [UIFont boldSystemFontOfSize:13];
    versionLabel.textAlignment = NSTextAlignmentLeft;
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    versionLabel.text = [NSString stringWithFormat:@"当前版本 V%@",versionString];
    versionLabel.textColor = [UIColor blackColor];
    [self.view addSubview:versionLabel];
    versionLabel.userInteractionEnabled = YES;
    
    
    checkUpdateBtn  = [UIButton buttonWithType:UIButtonTypeSystem];
    checkUpdateBtn.frame = CGRectMake(versionLabel.frame.size.width - 60, 0,60, 20);
    [checkUpdateBtn setTitle:@"检查更新" forState:UIControlStateNormal];
    checkUpdateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [checkUpdateBtn setTitleColor:[UIColor colorWithRed:65 /255.0 green:105 / 255.0 blue:185/255.0 alpha:1] forState:UIControlStateNormal];
    [checkUpdateBtn addTarget:self action:@selector(checkUpdateAction) forControlEvents:UIControlEventTouchUpInside];
    [versionLabel addSubview:checkUpdateBtn];
    
}

-(void)copyUrlAction
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERNAME];
    //    pasteboard.string = [NSString stringWithFormat:@"https://www.pgyer.com/JLJY  ---分享自：%@(经纶教育)",userName];
    pasteboard.string = [NSString stringWithFormat:@"https://www.zdhx-edu.com/Mobile/  ---分享自：%@(智微校)",userName];
    
    UIImage *imageToShare = [UIImage imageNamed:@"mk-photo"];
    
    
    //    UIActivityViewController *activity1 = [[UIActivityViewController alloc] initWithActivityItems:@[@"经纶教育",imageToShare,[NSURL URLWithString:@"https://www.pgyer.com/JLJY"]] applicationActivities:nil];
    UIActivityViewController *activity1 = [[UIActivityViewController alloc] initWithActivityItems:@[@"智微校",imageToShare,[NSURL URLWithString:shareTrueDownloadURL]] applicationActivities:nil];
    
    activity1.modalInPopover = true;
    
    [self.navigationController presentViewController:activity1 animated:YES completion:nil];
}


-(void)checkUpdateAction
{
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:appIdZWX];   // 请将 PGY_APP_ID 换成应用的 App ID
    //    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
}

-(void)updateMethod:(NSDictionary *)info
{
    NSLog(@"---%@",info);
    infoDic = [NSDictionary dictionaryWithDictionary:info];
    if ([NSString isBlankString:[info objectForKey:@"versionName"]]) {
        [self.view makeToast:@"暂无更新" duration:1 position:CSToastPositionCenter];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"新版本更新 V%@",[info objectForKey:@"versionName"]]  message:[NSString stringWithFormat:@"%@",[info objectForKey:@"releaseNote"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:infoDic[@"downloadURL"]]];
        [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
    }
}


-(void)changeLeftBar
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)returnShareURL
{
    [self dealShareModel];
    
    
    shareTrueDownloadURL = @"";
    shareTrueCodeImage = @"";
    
    NSString *localString = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_BASEURL];
    
    if ([localString hasPrefix:@"http://mck"]) {
        shareTrueDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-mck.html";
        shareTrueCodeImage = @"OA-马池口二维码";
    }
    else if ([localString hasPrefix:@"http://lyh"]) {
        shareTrueDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-lyh.html";
        shareTrueCodeImage = @"OA-龙游湖二维码";
    }
    else if ([localString hasPrefix:@"http://mylz"]) {
        shareTrueDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-mylz.html";
        shareTrueCodeImage = @"OA-密云六中二维码";
    }
    else if ([localString hasPrefix:@"http://hdfz"]) {
        shareTrueDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-hdfz.html";
        shareTrueCodeImage = @"OA-化大附中二维码";
    }
    else if ([localString hasPrefix:@"http://cz"]) {
        shareTrueDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-cz.html";
        shareTrueCodeImage = @"OA-长治二维码";
    }
    else if ([localString hasPrefix:@"http://im.bjcjl"]) {
        shareTrueDownloadURL = @"https://www.pgyer.com/jljy";
        shareTrueCodeImage = @"陈经纶二维码";
    }
    //临时注释 - 展会专用
    else if([localString hasPrefix:@"http://www"])
    {
        shareTrueDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-nczh.html";
        shareTrueCodeImage = @"OA-南昌展会官网分发二维码";
    }
    else
    {
        shareTrueDownloadURL = @"https://oa.zdhx-edu.com";
        shareTrueCodeImage = @"icon_share";
    }
    //
}


-(void)dealShareModel
{
    
    shareModelArray = [NSMutableArray array];
    
    //=====默认,统一蒲公英分发地址
    //默认分发-蒲公英
    TYHShareModel *shareModelDefaultFromePGYER = [TYHShareModel new];
    shareModelDefaultFromePGYER.shareSchoolName = @"默认-蒲公英";
    shareModelDefaultFromePGYER.shareCodeImage = @"icon_share";
    shareModelDefaultFromePGYER.shareDownloadURL = @"https://www.pgyer.com/zhwx-iOS";
    shareModelDefaultFromePGYER.shareLocalURL = @"http://im.zdhx-edu.com/im";
    [shareModelArray addObject:shareModelDefaultFromePGYER];
    //默认分发-公司OA
    TYHShareModel *shareModelDefaultFromOA = [TYHShareModel new];
    shareModelDefaultFromOA.shareSchoolName = @"默认-OA";
    shareModelDefaultFromOA.shareCodeImage = @"OA-公司官网二维码";
    shareModelDefaultFromOA.shareDownloadURL = @"https://oa.zdhx-edu.com";
    [shareModelArray addObject:shareModelDefaultFromOA];
    
    //=====单独,蒲公英分发地址
    //经纶教育
    TYHShareModel *shareModelJLJY = [TYHShareModel new];
    shareModelJLJY.shareSchoolName = @"经纶教育";
    shareModelJLJY.shareCodeImage = @"陈经纶二维码";
    shareModelJLJY.shareDownloadURL = @"https://www.pgyer.com/jljy";
    [shareModelArray addObject:shareModelJLJY];
    
    //=====非默认,有单独分发地址
    //马池口中学
    TYHShareModel *shareModelMCK = [TYHShareModel new];
    shareModelMCK.shareSchoolName = @"马池口中学";
    shareModelMCK.shareCodeImage = @"OA-马池口二维码";
    shareModelMCK.shareDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-mck.html";
    [shareModelArray addObject:shareModelMCK];
    
    //化大附中
    TYHShareModel *shareModelHDFZ = [TYHShareModel new];
    shareModelHDFZ.shareSchoolName = @"化大附中";
    shareModelHDFZ.shareCodeImage = @"OA-化大附中二维码";
    shareModelHDFZ.shareDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-hdfz.html";
    [shareModelArray addObject:shareModelHDFZ];
    
    //龙游湖
    TYHShareModel *shareModelLYH = [TYHShareModel new];
    shareModelLYH.shareSchoolName = @"龙游湖";
    shareModelLYH.shareCodeImage = @"OA-龙游湖二维码";
    shareModelLYH.shareDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-lyh.html";
    [shareModelArray addObject:shareModelLYH];
    
    //密云六中
    TYHShareModel *shareModelMYLZ = [TYHShareModel new];
    shareModelMYLZ.shareSchoolName = @"密云六中";
    shareModelMYLZ.shareCodeImage = @"OA-密云六中二维码";
    shareModelMYLZ.shareDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-mylz.html";
    [shareModelArray addObject:shareModelMYLZ];
    
    //长治
    TYHShareModel *shareModelCZ = [TYHShareModel new];
    shareModelCZ.shareSchoolName = @"长治";
    shareModelCZ.shareCodeImage = @"OA-长治二维码";
    shareModelCZ.shareDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-cz.html";
    [shareModelArray addObject:shareModelCZ];
    
    
    //南昌展会
    TYHShareModel *shareModelNCZH = [TYHShareModel new];
    shareModelNCZH.shareSchoolName = @"长治";
    shareModelNCZH.shareCodeImage = @"OA-南昌展会官网分发二维码";
    shareModelNCZH.shareDownloadURL = @"https://oa.zdhx-edu.com/mobile/index-nczh.html";
    [shareModelArray addObject:shareModelNCZH];
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

@implementation TYHShareModel

@end
