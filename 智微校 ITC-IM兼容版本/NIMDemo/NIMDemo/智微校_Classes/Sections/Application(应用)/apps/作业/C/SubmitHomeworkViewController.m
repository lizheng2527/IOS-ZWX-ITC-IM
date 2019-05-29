//
//  SubmitHomeworkViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/29.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "SubmitHomeworkViewController.h"
#import "DFImagesSendViewController.h"
#import "DFPlainGridImageView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIBarButtonItem+Lite.h"
#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"
#import <MJRefresh.h>
#import "TZImagePickerController.h"

#import "NSString+NTES.h"
#import "AreaHelper.h"
#import <MBProgressHUD.h>
#import <UIView+Toast.h>

#import <AFNetworking.h>
#import "HWNetWorkHandler.h"

#import "ACMediaFrame.h"

#define ImageGridWidth [UIScreen mainScreen].bounds.size.width*0.7
#define myCyanColor colorWithRed:54/255.0 green:191/255.0 blue:181/255.0 alpha:1
@interface SubmitHomeworkViewController ()<TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray * imageName;
@property(nonatomic,retain)NSMutableArray *imageDataArr;
@property(nonatomic,retain)NSMutableArray *imageArray;
@property (nonatomic, strong) UITextView *contentView;

@property (nonatomic, strong) UIImagePickerController *pickerController;

@property(nonatomic, strong)UILabel *placeHolderLabel;
//获取用户所属班级ID
@property(nonatomic,copy)NSString *departmentID;

@property(nonatomic,assign)NSInteger uploadImageViewHeigh;
@property(nonatomic,retain)UIView *bgView;

@end

@implementation SubmitHomeworkViewController
{
    UIBarButtonItem * rightBtn;
    UIButton *chooseClassBtn;
    NSString *userName;
    NSString *password;
    NSString *organizationID;
    NSString *userID;
}

- (instancetype)initWithImages:(NSArray *) images andFinshString:(NSString *)finishString andHomeworkID:(NSString *)homeWorkID
{
    self = [super init];
    if (self) {
        _images = [NSMutableArray array];
        _imageName = [NSMutableArray array];
        _homeworkID = homeWorkID;
        [self getNeedData];
        if ([finishString isEqualToString:@"未完成"]) {
            self.title = @"提交作业";
        }
        else
        {
            self.title = @"查看我的作业";
        }
        
    }
    return self;
}

-(void)getNeedData
{
    userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self createLeftBar];
    [self uploadViewInit];
    rightBtn.enabled = NO;
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor myCyanColor]}];
    
}



-(void) initView
{
    CGFloat x, y, width, heigh;
    x=10;
    y=4;
    width = self.view.frame.size.width -2*x;
    heigh = 100;
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, heigh)];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.borderWidth = 1.0f;
    _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _contentView.scrollEnabled = YES;
    _contentView.delegate = self;
    _contentView.font = [UIFont systemFontOfSize:17];
    _placeHolderLabel = [[UILabel alloc]init];
    _placeHolderLabel.font = [UIFont boldSystemFontOfSize:12];
    _placeHolderLabel.frame = CGRectMake(x, y, 200, 20);
    _placeHolderLabel.text = @"作业备注";
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    [_contentView addSubview:_placeHolderLabel];

    [self.view addSubview:_contentView];
    
}


-(void)createLeftBar
{
    UIBarButtonItem * leftItem = nil;
    rightBtn = nil;
    
    
    UIBarButtonItem *
    barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    
    //设置字体为加粗的12号系统字，自己也可以随便设置。
    
    [barItemInNavigationBarAppearanceProxy
     setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont
                                                           boldSystemFontOfSize:15], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HomeWork_returns"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(sendPhotoAction)];
        rightBtn.tintColor = [UIColor myCyanColor];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HomeWork_returns"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(sendPhotoAction)];
        rightBtn.tintColor = [UIColor myCyanColor];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem =rightBtn;
    
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(BOOL)isEmpty
{
    if ([self isBlankString:_contentView.text] && _images.count == 0) {
        return YES;
    }
    else return NO;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)sendPhotoAction
{
    if ([self isEmpty]) {
        [self.view makeToast:@"提交内容为空" duration:1 position:CSToastPositionCenter];
        return;
    }
    rightBtn.enabled = NO;
    [self.view endEditing:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.labelFont = [UIFont systemFontOfSize:12];
    HWNetWorkHandler *helper = [[HWNetWorkHandler alloc]init];
        [helper uploadHomeworkandContentWith:_contentView.text tadID:_homeworkID uploadFiles:_images andStatus:^(BOOL successful , NSMutableArray *afterUploadInfo) {
            if (successful) {
                [hud removeFromSuperview];
                [self.view endEditing:YES];
                [self.view makeToast:@"上传成功" duration:1 position:CSToastPositionCenter];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"HWrefresh" object:nil];
                    
                });
            }
        } failure:^(NSError *error) {
            [self.view endEditing:YES];
            rightBtn.enabled = YES;
            [self.view makeToast:@"上传失败" duration:1 position:CSToastPositionCenter];
        }];
//
//    [self sendNoticePerfect];
}



#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [_placeHolderLabel removeFromSuperview];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *tempString = [textView.text  substringWithRange:range];
    if (![self isBlankString:text]) {
        rightBtn.enabled = YES;
    }
    else    if(textView.text.length == tempString.length && !(_images.count > 1)){
        rightBtn.enabled = NO;
    }
    else if (![self isBlankString:[NSString stringWithFormat:@"%@%@",textView.text,text]])
    {
        rightBtn.enabled = YES;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_contentView resignFirstResponder];
}


#pragma mark - viewConfig
// 初始化上传视图
-(void)uploadViewInit
{
    //1、得到默认布局高度（唯一获取高度方法）
    CGFloat height = [ACSelectMediaView defaultViewHeight];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 116, [UIScreen mainScreen].bounds.size.width - 32, height)];
    if (!_bgView.superview) {
        [self.view addSubview:_bgView];
    }
    
    //2、初始化
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height)];
    
    //3、选择媒体类型：ACMediaType
    mediaView.type = ACMediaTypePhotoAndCamera;
    
    mediaView.mediaArray = [NSMutableArray array];
    mediaView.imageMaxCount = 6;
    //是否需要显示图片上的删除按钮
    //mediaView.showDelete = NO;
    
    //5、随时获取新的布局高度
    [mediaView observeViewHeight:^(CGFloat value) {
        _bgView.height = value ;
        _uploadImageViewHeigh = (value - 40) / 2;
        if (_uploadImageViewHeigh < 60) {
            _uploadImageViewHeigh = 0;
        }
        
        //        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        //        [_mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    //6、随时获取已经选择的媒体文件
    [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
        
        _images  = [NSMutableArray array];
        
        for (ACMediaModel *model in list) {
            [_images addObject:model.image];
        }
        
        if (_images.count) {
            rightBtn.enabled = YES;
        }else if([self isBlankString:_contentView.text])
        {
            rightBtn.enabled = NO;
        }
    }];
    
    _bgView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:mediaView];
}


@end

