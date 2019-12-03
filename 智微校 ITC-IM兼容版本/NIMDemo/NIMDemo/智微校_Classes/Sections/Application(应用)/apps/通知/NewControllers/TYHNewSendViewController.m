//
//  TYHNewSendViewController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/2/22.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHNewSendViewController.h"
#import "TYHNewContacterController.h"
#import "TYHChoosedPersonController.h"
#import "UIView+Extention.h"
#import <MJExtension.h>
#import "ZLPhoto.h"
#import "ImageCollectionCell.h"
#import <UIView+Toast.h>
#import <AFNetworking.h>
#import "SingleManager.h"
#import "AttachmentModel.h"
#import "UIAlertView+NTESBlock.h"
#import "TYHHttpTool.h"
#import "NSString+NTES.h"


#define MAX_LIMIT_NUMS     100 //来限制最大输入只能100个字符
#define kNumber5 2
static int a;

@interface TYHNewSendViewController ()<UIAlertViewDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerViewControllerDelegate,UIWebViewDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong,nonatomic) ZLCameraViewController *cameraVc;
@property (nonatomic, copy) NSString * receiveUserId;
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic, strong) NSMutableArray * imageDataArr;
@property (nonatomic, strong) MBProgressHUD * HUB;
@property (nonatomic, strong) NSMutableArray * imageName;
@property (nonatomic, copy) NSString * oldIdStr;
@property (nonatomic, copy) NSString * oldId;
@property (nonatomic, copy) NSString * contentStr;
@property (nonatomic, strong) NSSet * set;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UILabel * uilabel;
@property (nonatomic, strong) UIBarButtonItem * rightItem;
@property (nonatomic, assign) BOOL ifEdit;
@property (nonatomic, strong) NSMutableArray * attachIDArray;
@property (nonatomic, strong) ZLPhotoAssets * asset;

@property (nonatomic, copy) NSString * dateName;
@property(nonatomic,copy)NSString *dataSourceName;
@end

@implementation TYHNewSendViewController
{
    
    NSUInteger remainTextNum_;
    float clientheight;
    NSString *urlString;
}
- (NSMutableArray *)assets {
    
    if (_assets == nil) {
        self.assets = [NSMutableArray arrayWithArray:@[]];
        
    }
    return _assets;
}
- (void)initData {
    
    NSString *tempUserName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    _organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    _userName = [NSString stringWithFormat:@"%@",tempUserName];
    _password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    _userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    _token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
    _dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    _dataSourceName = _dataSourceName.length?_dataSourceName:@"";
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
- (NSMutableArray *)tempArray {
    
    if (_tempArray == nil) {
        _tempArray = [[NSMutableArray alloc] init];
    }
    return _tempArray;
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        
        NSMutableArray * array2 = [SingleManager defaultManager].assets;
        
        if (array2.count>0) {
            
            _dataArray = [NSMutableArray arrayWithArray:array2];
//            NSLog(@"_dataArray == %@",_dataArray);
        }else{
            _dataArray = [NSMutableArray array];
        }
    
    }
    return _dataArray;
}
- (NSMutableArray *)attachIDArray {

    if (_attachIDArray == nil) {
        
        self.attachIDArray = [NSMutableArray arrayWithArray:[SingleManager defaultManager].idStrArray];
        
    }
    return _attachIDArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    self.title = @"发通知";
    [self registerForKeyboardNotifications];
    
    TPKeyboardAvoidingScrollView *scrollView = [TPKeyboardAvoidingScrollView new];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    self.textView3.layer.masksToBounds = YES;
    self.textView3.layer.cornerRadius = 3.0f;
    self.textView3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView3.layer.borderWidth = 0.5f;
    
    [scrollView addSubview:self.label1];
    [scrollView addSubview:self.label2];
    [scrollView addSubview:self.label3];
    [scrollView addSubview:self.label4];
    [self.button2 addSubview:self.label5];
    [scrollView addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    [scrollView addSubview:self.button4];
    [scrollView addSubview:self.button5];
    [scrollView addSubview:self.imageView1];
    [scrollView addSubview:self.imageView2];
    [scrollView addSubview:self.textView1];
    [scrollView addSubview:self.textView2];
    [scrollView addSubview:self.textView3];
    [scrollView addSubview:self.imageView1];
    [scrollView addSubview:self.imageView2];
    [scrollView addSubview:self.imageView3];
    [scrollView addSubview:self.view1];
    [scrollView addSubview:self.webView];
    
    [self setupCollectionView];
    
    [scrollView addSubview:self.collectionView];
    
    scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    self.label4.numberOfLines = 0;
    UIFont *font = [UIFont fontWithName:@"Arial" size:13];
    //设置字体
    self.label4.font = font;
    self.label4.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.label4.sd_layout
    .leftSpaceToView(scrollView, 70)
    .rightSpaceToView(scrollView, 50)
    .topSpaceToView(scrollView, 5)
    .heightIs(44);
    
    self.button4.sd_layout
    .leftSpaceToView(scrollView, 70)
    .rightSpaceToView(scrollView, 50)
    .topSpaceToView(scrollView, 0)
    .heightIs(44);
    [self.button4 addTarget:self action:@selector(didClickButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.label1.sd_layout
    .leftSpaceToView(scrollView, kNumber5)
    .rightSpaceToView(self.label4, kNumber5)
    .topEqualToView(self.label4)
    .centerYEqualToView(self.label4)
    .bottomEqualToView(self.label4);
    
    
    self.label1.text = @"接收人:";
    self.label1.font = [UIFont systemFontOfSize:14];
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.textColor = [UIColor lightGrayColor];
    
    self.button1.sd_layout
    .rightSpaceToView(scrollView, kNumber5)
    .leftSpaceToView(self.label4, kNumber5)
    .topEqualToView(self.label4)
    .centerYEqualToView(self.label4)
    .bottomEqualToView(self.label4);
    
    [self.button1 setImage:[UIImage imageNamed:@"btn_add_normal"] forState:(UIControlStateNormal)];
    [self.button1 setImage:[UIImage imageNamed:@"btn_add_pressed"] forState:(UIControlStateNormal)];
    self.button1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.button1 addTarget:self action:@selector(addNewPerson:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.imageView1.sd_layout
    .leftSpaceToView(scrollView,0)
    .rightSpaceToView(scrollView, 0)
    .topSpaceToView(self.label4, 2)
    .heightIs(1);
   
    
    self.textView2.sd_layout
    .leftSpaceToView(scrollView, 70)
    .rightSpaceToView(scrollView, 50)
    .topSpaceToView(self.imageView1, 2)
    .heightIs(44);
    
    self.label3.sd_layout
    .rightSpaceToView(scrollView, kNumber5)
    .leftSpaceToView(self.textView2, kNumber5)
    .topEqualToView(self.textView2)
    .centerYEqualToView(self.textView2)
    .bottomEqualToView(self.textView2);
    
    self.label2.sd_layout
    .leftSpaceToView(scrollView, kNumber5)
    .rightSpaceToView(self.textView2, kNumber5)
    .topEqualToView(self.textView2)
    .centerYEqualToView(self.textView2)
    .bottomEqualToView(self.textView2);
    
    self.label2.text = @"主题:";
    self.label2.font = [UIFont systemFontOfSize:14];
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.textColor = [UIColor lightGrayColor];
    
    self.imageView2.sd_layout
    .leftSpaceToView(scrollView,0)
    .rightSpaceToView(scrollView, 0)
    .topSpaceToView(self.textView2, 2)
    .heightIs(1);
    
    self.textView3.sd_layout
    .leftSpaceToView(scrollView, kNumber5)
    .rightSpaceToView(scrollView, kNumber5)
    .topSpaceToView(self.imageView2, 2)
    .heightIs(200);
    
    //在UITextView上面覆盖个UILable,UILable设置为全局变量。 placeholder
    _uilabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.width - 10, 20)];
    _uilabel.font = [UIFont systemFontOfSize:12];
    _uilabel.enabled = NO;//lable必须设置为不可用
    _uilabel.backgroundColor = [UIColor clearColor];
    [self.textView3 addSubview:_uilabel];
    
    
    self.button2.sd_layout.rightSpaceToView(self.view,20).heightIs(60).widthIs(60).bottomSpaceToView(self.view,120);
    
    self.button3.sd_layout.rightSpaceToView(self.view,0).leftSpaceToView(self.view,0).heightIs(44).bottomSpaceToView(self.view,0);
    
    if (@available(iOS 11.0, *)) {
        self.button3.sd_layout.rightSpaceToView(self.view,0).leftSpaceToView(self.view,0).heightIs(44).bottomSpaceToView(self.view,15);
    }
    
    self.button3.backgroundColor = [UIColor lightGrayColor];
    self.button3.alpha = 0.5;
    self.button3.hidden = YES;
    [self.button3 setTitle:@"图片" forState:(UIControlStateNormal)];
    [self.button3 addTarget:self action:@selector(chooseImageAttach) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.label5.sd_layout.rightSpaceToView(self.button2, 0).heightIs(15).widthIs(20).topSpaceToView(self.button2,0);
    self.label5.font = [UIFont systemFontOfSize:10];
    self.label5.textAlignment = NSTextAlignmentCenter;
    self.label5.textColor = [UIColor whiteColor];
    self.label5.backgroundColor = [UIColor redColor];
    
    [self.button2 addTarget:self action:@selector(chooseImageHiddenOrNot) forControlEvents:(UIControlEventTouchUpInside)];
    [self.button2 setImage:[UIImage imageNamed:@"附件03"] forState:UIControlStateNormal];
    [self.button2 setImage:[UIImage imageNamed:@"附件04"] forState:(UIControlStateSelected)];
    if ([self.label5.text isEqualToString:@""]) {
        self.label5.hidden = YES;
    } else {
        self.label5.hidden = NO;
    }
    self.label5.layer.masksToBounds = YES;
    self.label5.layer.cornerRadius = 8;
    
    // 初始化数组 图片
    self.imageArray = [NSMutableArray array];
    self.imageName = [NSMutableArray array];
    
    self.oldId = [SingleManager defaultManager].idStr;
//    NSLog(@"self.oldId == %@",self.oldId);
    //  原文 转发的  模型附件ID数组
    NSString * strID = [self.attachIDArray componentsJoinedByString:@","];
//    NSLog(@"strID == %@",strID);
    self.oldIdStr = strID;
    
    
    // 非原文转发
    if (self.oldId.length == 0) {
        
//        self.textView3.text = [NSString stringWithFormat:@"\n\n\n\n发自智微校客户端"];
        if (self.oldIdStr.length != 0) {
            
            // 如果有附件
            self.collectionView.sd_layout
            .leftSpaceToView(self.scrollView, kNumber5)
            .rightSpaceToView(self.scrollView, kNumber5)
            .topSpaceToView(self.textView3, kNumber5)
            .heightIs(20);
            
            [scrollView setupAutoContentSizeWithBottomView:self.collectionView bottomMargin:20];
            
        } else {
            
            [scrollView setupAutoContentSizeWithBottomView:self.textView3 bottomMargin:20];
        }
        
    }  else{// 原文转发
        
        // 获取webView 编辑之前存在webView  编辑后移除
        BOOL WebYN = [SingleManager defaultManager].webViewOrHidden;
//        NSLog(@"webyn0000  ===  %d",WebYN);// NO;
        
        if (!WebYN) {
        
            [self setupWebView];
            self.imageView3.sd_layout
            .leftSpaceToView(scrollView,5)
            .rightSpaceToView(scrollView, 80)
            .topSpaceToView(self.textView3, 10)
            .heightIs(1);
            
            // 添加编辑按钮
            self.button5.sd_layout.centerYEqualToView(self.imageView3).heightIs(22).leftSpaceToView(self.imageView3,5).rightSpaceToView(scrollView,5);
//            [self.button5 setTitle:@"编辑原文" forState:(UIControlStateNormal)];
            [self.button5 setTitle:@"原文如下" forState:(UIControlStateNormal)];
            self.button5.enabled = NO;
            self.button5.titleLabel.font= [UIFont systemFontOfSize:12];
//            [self.button5 setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
            //ITC版本不可用
            [self.button5 setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [self.button5 addTarget:self action:@selector(editWebViewToTextView) forControlEvents:(UIControlEventTouchUpInside)];
            
            // 内容
            self.webView.sd_layout.leftSpaceToView(scrollView,5)
            .rightSpaceToView(scrollView, 5)
            .topSpaceToView(self.imageView3, 10)
            .heightIs(clientheight + 20);
            
            //  有附件
            if (self.oldIdStr.length != 0) {
                
                self.collectionView.sd_layout
                .leftSpaceToView(scrollView, kNumber5)
                .rightSpaceToView(scrollView, kNumber5)
                .topSpaceToView(self.textView3, kNumber5)
                .heightIs(self.view.width/2);
                
                [scrollView setupAutoContentSizeWithBottomView:self.collectionView bottomMargin:20];
                
            } else {
                self.collectionView.sd_layout
                .leftSpaceToView(scrollView, kNumber5)
                .rightSpaceToView(scrollView, kNumber5)
                .topSpaceToView(self.textView3, kNumber5)
                .heightIs(self.view.width/2);
                [scrollView setupAutoContentSizeWithBottomView:self.textView3 bottomMargin:20];
            }
        }
         // 有附件
        if (self.oldIdStr.length != 0) {

            self.collectionView.sd_layout
            .leftSpaceToView(scrollView, kNumber5)
            .rightSpaceToView(scrollView, kNumber5)
            .topSpaceToView(self.textView3, kNumber5)
            .heightIs(self.view.width/2);
            
            [scrollView setupAutoContentSizeWithBottomView:self.collectionView bottomMargin:20];
            
        } else {// 新建通知
            self.collectionView.sd_layout
            .leftSpaceToView(scrollView, kNumber5)
            .rightSpaceToView(scrollView, kNumber5)
            .topSpaceToView(self.textView3, kNumber5)
            .heightIs(self.view.width/2);
            [scrollView setupAutoContentSizeWithBottomView:self.textView3 bottomMargin:20];
        }
    }
    
    self.textView1.delegate = self;
    self.textView2.delegate = self;
    self.textView3.delegate = self;
    
    self.textView1.scrollEnabled = NO;
    self.textView2.scrollEnabled = NO;
    self.textView3.scrollEnabled = YES;
    
    self.ifEdit = YES;
    [self creatLeftItem];
    
    
    self.set = [[NSSet alloc] init];
    
    if (self.textView3.text.length == 0) {
        _uilabel.text = @"请输入通知内容";
        _uilabel.font = [UIFont systemFontOfSize:16];
    }else{
        _uilabel.text = @"";
    }
}


// 编辑提醒
- (void)editWebViewToTextView {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"编辑原文可能会使部分格式或内容丢失,确认继续吗?" preferredStyle:(UIAlertControllerStyleAlert)];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [SingleManager defaultManager].webViewOrHidden = YES;
            
            [self.webView removeFromSuperview];
            [self.imageView3 removeFromSuperview];
            [self.button5 removeFromSuperview];
            
            
            self.oldId = nil;
            self.textView3.text = nil;
            self.ifEdit = NO;
            self.textView3.text = [NSString stringWithFormat:@"\n%@",_contentStr];
            self.contentStr = nil;
            CGRect frame3 = self.textView3.frame;
            CGSize constraintSize3 = CGSizeMake(frame3.size.width, MAXFLOAT);
            CGSize size3 = [self.textView3 sizeThatFits:constraintSize3];
            
            if (size3.height > 100) {
                self.textView3.frame = CGRectMake(frame3.origin.x, frame3.origin.y, frame3.size.width, size3.height);
            }
            
            if (self.oldIdStr.length != 0) {
                // 如果有附件
                int b = (int)[SingleManager defaultManager].idStrArray.count;
                if (b%2!=0) {
                    
                    b = b/2 + 1;
                }else {
                    b = b/2;
                }
                self.collectionView.sd_layout
                .leftSpaceToView(self.scrollView, kNumber5)
                .rightSpaceToView(self.scrollView, kNumber5)
                .topSpaceToView(self.textView3, kNumber5)
                .heightIs(self.view.width/2*b);
                
                [self.scrollView setupAutoContentSizeWithBottomView:self.collectionView bottomMargin:20];
            } else {
            // 如果没有附件
                int c = (int)_assets.count;
                if (c%2!=0) {
                    c = c/2+1;
                }else {
                    c = c/2;
                }
                self.collectionView.sd_layout
                .leftSpaceToView(self.scrollView, kNumber5)
                .rightSpaceToView(self.scrollView, kNumber5)
                .topSpaceToView(self.textView3, kNumber5)
                .heightIs(self.view.width/2 * c );
                
                [self.scrollView setupAutoContentSizeWithBottomView:self.collectionView bottomMargin:20];
                
            }
        }]];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"编辑原文可能会使部分格式或内容丢失,确认继续吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1005;
        [alert show];
    }
    
    [self.collectionView reloadData];
    
}
- (void)setupWebView {
    
//    http://www.zdhx-edu.com/zddc-cs/no/noticeMobile!getH5NoticeContent.action?imToken=484689dea8a09271544c07a2cd57d8cd&sys_username=yanjunpeng%2C20170527125235556876917905665617&id=20171011102729462374013289435180&sys_password=000000&sys_Token=484689dea8a09271544c07a2cd57d8cd&widthPx=411&sys_auto_authenticate=true
    
    
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.userInteractionEnabled = NO;
    NSString * string = [NSString stringWithFormat:@"%@/no/noticeMobile!getH5NoticeContent.action?",BaseURL];
    
    NSString * url = [NSString stringWithFormat:@"%@id=%@&sys_username=%@&sys_auto_authenticate=true&sys_password=%@&imToken=%@&dataSourceName=%@&sys_Token=%@",string,self.oldId,_userName,_password,self.token,_dataSourceName,self.token];
    NSLog(@"url -----  %@",url);
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
// webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    clientheight = [clientheight_str floatValue];
    //设置到WebView上
    // 内容
    self.webView.sd_layout.leftSpaceToView(self.scrollView,5)
    .rightSpaceToView(self.scrollView, 5)
    .topSpaceToView(self.imageView3, 10)
    .heightIs(clientheight + 20);
    
    webView.frame = CGRectMake(5, 5, self.scrollView.frame.size.width, clientheight  + 20);//  少大约20 自己加上的
    [SVProgressHUD show];
    NSString *getContentURL = [NSString stringWithFormat:@"%@/no/noticeMobile!getNoticeHtmlContent.action?id=%@&sys_username=%@&sys_auto_authenticate=true&sys_password=%@",BaseURL,self.oldId,_userName,_password];
    [TYHHttpTool gets:getContentURL params:nil success:^(id json) {
        id data = [[NSString  alloc] initWithData:json encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [self dictionaryWithJsonString:data];
        self.contentStr = [dic objectForKey:@"content"];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
//    self.contentStr = contentStr;

    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


- (void)chooseImageHiddenOrNot {
    
    if (self.button2.selected) {
        
        self.button3.hidden = YES;
        self.button2.selected =!self.button2.selected;
        
    }else {
        
        self.button3.hidden = NO;
        self.button2.selected =!self.button2.selected;
    }
    
    [self.view endEditing:NO];
}
- (void)chooseImageAttach {
    // 创建控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    // 最多能选9张图片
    pickerVc.maxCount = 4;
//    pickerVc.selectPickers = self.assets;
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self];
    
}
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets {
    // 添加图片数组
    self.assets = [NSMutableArray arrayWithArray:assets];
//    self.dateName = nil;

    [self.dataArray addObjectsFromArray:assets];

    SingleManager * defaultManager = [SingleManager defaultManager];
    defaultManager.assets = nil;
    defaultManager.assets = self.dataArray;
    
//    dispatch_queue_t queue = dispatch_queue_create("image.cn", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
        //            [NSThread sleepForTimeInterval:2];
        
        [self getImageData];
//        NSLog(@"dispatch_async2");
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        
//            [self getImageData];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self.collectionView reloadData];
//        });
//        
//        
//    });
    
//    NSLog(@"(int)_imageName.count) == %d",(int)_imageName.count);
    
}
#pragma mark setup UI
- (void)setupCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(self.view.width/2 - 10, self.view.width/2 - 10);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionCell"];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger integer =  [self.dataArray count];
//    NSLog(@"_dataArray.count === %d",(int)_dataArray.count);
    
    if (integer != 0) {
        
        self.label5.hidden = NO;
        self.label5.text = [NSString stringWithFormat:@"%d",(int)integer];
    } else {
        
        self.label5.hidden = YES;
    }
    a = (int)self.dataArray.count;
   
    if (a%2!=0) {
        a = a/2 + 1;
    } else {
        a = a/2;
    }
    
    if (self.oldId.length == 0) {
        self.collectionView.sd_layout
        .leftSpaceToView(self.scrollView, kNumber5)
        .rightSpaceToView(self.scrollView, kNumber5)
        .topSpaceToView(self.textView3, kNumber5)
        .heightIs(self.view.width/2*a);
    }else {
        self.collectionView.sd_layout
        .leftSpaceToView(self.scrollView, kNumber5)
        .rightSpaceToView(self.scrollView, kNumber5)
        .topSpaceToView(self.webView, kNumber5)
        .heightIs(self.view.width/2*a);
    }
    
    [self.scrollView setupAutoContentSizeWithBottomView:self.collectionView bottomMargin:20];
    
    return integer;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionCell" forIndexPath:indexPath];
    
    // 判断类型来获取Image
    if ([_dataArray[indexPath.item] isKindOfClass:[AttachmentModel class]]) {
        
        AttachmentModel * model = _dataArray[indexPath.item];
        cell.imgName.text = model.name;
        NSString * str = model.name;
        NSRange range = [str rangeOfString:@"."];
        str = [str substringFromIndex:range.location];
        
        if ([str isEqualToString:@".txt"]) {
            cell.officeName.image = [UIImage imageNamed:@"attach_file_icon_mailread_txt"];
        } else if ([str isEqualToString:@".doc"]||[str isEqualToString:@".docx"]||[str isEqualToString:@".DOC"]||[str isEqualToString:@".DOCX"]) {
            cell.officeName.image = [UIImage imageNamed:@"attach_file_icon_mailread_doc"];
        } else if ([str isEqualToString:@".zip"]) {
            cell.officeName.image = [UIImage imageNamed:@"attach_file_icon_mailread_zip"];
        } else if ([str isEqualToString:@".pdf"]) {
            cell.officeName.image = [UIImage imageNamed:@"attach_file_icon_mailread_pdf"];
        } else if ([str isEqualToString:@".xls"]||[str isEqualToString:@".xlsx"]|[str isEqualToString:@".XLSX"]|[str isEqualToString:@".XLS"]) {
            cell.officeName.image = [UIImage imageNamed:@"attach_file_icon_mailread_xls"];
        }else if ([str isEqualToString:@".ppt"]||[str isEqualToString:@".pptx"]||[str isEqualToString:@".PPT"]||[str isEqualToString:@".PPTX"]) {
            cell.officeName.image = [UIImage imageNamed:@"attach_file_icon_mailread_ppt"];
        } else {
            cell.officeName.image = [UIImage imageNamed:@"attach_file_icon_mailread_img"];
        }

        cell.labelName.text = @"原文附件";
        cell.labelName.hidden = NO;
        cell.sizeName.hidden = YES;
        cell.imageChose.hidden= YES;
        cell.imgName.hidden = NO;
        cell.officeName.hidden = NO;
        
    } else {
        NSString * sizeStr;
        
        ZLPhotoAssets * asset = _dataArray[indexPath.item];
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            
            cell.imageChose.image = [asset aspectRatioImage];
            NSData * data;
//            if (UIImagePNGRepresentation(cell.imageChose.image)) {
//                //返回为png图像。
//                data = UIImagePNGRepresentation(cell.imageChose.image);
//            }else {
                //返回为JPEG图像。
                data = UIImageJPEGRepresentation(cell.imageChose.image, 0.8);
//            }
            sizeStr = [NSString stringWithFormat:@" %zdKB",(unsigned long)[data length]/1024];
            
        }else if([asset isKindOfClass:[UIImage class]]){
        
            UIImage * image = (UIImage *)asset;
            NSData * data;
//            if (UIImagePNGRepresentation(image)) {
//                //返回为png图像。
//                data = UIImagePNGRepresentation(image);
//            }else {
                //返回为JPEG图像。
                data = UIImageJPEGRepresentation(image, 0.8);
//            }
            sizeStr = [NSString stringWithFormat:@" %zdKB",(unsigned long)[data length]/1024];
            
//            NSLog(@"sizeStr = %@",sizeStr);
            if ([sizeStr intValue] > 1024) {
                sizeStr = [NSString stringWithFormat:@" %zdM",(unsigned long)[data length]/1024/1024];
            }
            CGSize imagesize = image.size;
            imagesize.height = 130;
            imagesize.width = 130;
            image = [self imageWithImage:image scaledToSize:imagesize];
            cell.imageChose.image = image;
//            NSLog(@"image asset%@",asset);
            
        }else if ([asset isKindOfClass:[ZLCamera class]]){
            cell.imageChose.image = [asset thumbImage];
            NSData * data;
//            if (UIImagePNGRepresentation(cell.imageChose.image)) {
//                //返回为png图像。
//                data = UIImagePNGRepresentation(cell.imageChose.image);
//            }else {
                //返回为JPEG图像。
                data = UIImageJPEGRepresentation(cell.imageChose.image, 0.8);
//            }
            sizeStr = [NSString stringWithFormat:@" %zdKB",(unsigned long)[data length]/1024];
//            NSLog(@"ZLCamera asset%@",asset);
        }
        
        cell.sizeName.hidden = NO;
        cell.imageChose.hidden= NO;
        cell.imgName.hidden = YES;
        cell.officeName.hidden = YES;
        cell.labelName.hidden = YES;
       
        cell.sizeName.text = sizeStr;
        
        cell.sizeName.textColor = [UIColor whiteColor];
    }
    
    //  删除后出现的问题是
    [cell.deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.deleteBtn.tag = indexPath.item;
    
    return cell;
    
}
- (void)deleteBtn:(UIButton *)btn {
    
    ImageCollectionCell * cell = (ImageCollectionCell *)[[btn superview] superview];
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    
    NSInteger tag = indexPath.item;
    [self.dataArray enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (btn.tag == tag ) {
            *stop = YES;
            
            obj = self.dataArray[indexPath.item];
            if ([obj isKindOfClass:[AttachmentModel class]]) {
                AttachmentModel * model = (AttachmentModel *)obj;
                [self.attachIDArray removeObject:model.modelID];
                
            }
            else{
                
                if ([obj isKindOfClass:[ZLPhotoAssets class]]) {
                
                    ZLPhotoAssets * asset = (ZLPhotoAssets *)obj;
                   
                    [self.imageArray removeObject:[asset aspectRatioImage]];
                    NSURL *imageURL = [asset assetURL];
                    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
                        
                        ALAssetRepresentation *representation = [myasset defaultRepresentation];
                        NSString *fileName = [representation filename];
                        [self.imageName removeObject:fileName];
                    };
                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                    
                    [assetslibrary assetForURL:imageURL
                                  resultBlock:resultblock
                                   failureBlock:nil];
                    
                }else if([obj isKindOfClass:[UIImage class]]){
                        
                    UIImage * asset = (UIImage *)obj;
                    [self.imageArray removeObject:asset];
                    
                    [self.imageName removeObject:_dateName];
                    
                    
                }else if ([obj isKindOfClass:[ZLCamera class]]){
                    
                    ZLCamera * asset = (ZLCamera *)obj;
                    [self.imageArray removeObject:[asset thumbImage]];
                
//                    NSURL *imageURL = [asset assetURL];
//                    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
//                        
//                        ALAssetRepresentation *representation = [myasset defaultRepresentation];
//                        NSString *fileName = [representation filename];
//                        [self.imageName removeObject:fileName];
//                    };
//                    
//                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
//                    
//                    [assetslibrary assetForURL:imageURL
//                                   resultBlock:resultblock
//                                  failureBlock:nil];
                }
                
            }
            
            [_dataArray removeObjectAtIndex:tag];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            SingleManager * defaultManager = [SingleManager defaultManager];
            defaultManager.assets = nil;
            defaultManager.assets = self.dataArray;
            defaultManager.idStrArray = (NSArray *)_attachIDArray;
        }
    }];

    [self getImageData];
    
}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)creatLeftItem {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    } else {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
- (void)returnClicked {
    
    NSString * titleStr = @"放弃当前编辑";
    NSString * messageStr = @"退出后当前编辑内容不能保存,确认退出吗?";
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            
            [SingleManager defaultManager].content = nil;
            [SingleManager defaultManager].item = nil;
            [SingleManager defaultManager].assets = nil;
            [SingleManager defaultManager].idStr = nil;
            [SingleManager defaultManager].webViewOrHidden = NO;
            [SingleManager defaultManager].idStrArray = nil;
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1001;
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1&& alertView.tag == 1001){
        
        [SingleManager defaultManager].content = nil;
        [SingleManager defaultManager].item = nil;
        [SingleManager defaultManager].assets = nil;
        [SingleManager defaultManager].idStr = nil;
        [SingleManager defaultManager].idStrArray = nil;
        [SingleManager defaultManager].webViewOrHidden = NO;
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
    } else if(alertView.tag == 1005) {
        
        [self.webView removeFromSuperview];
        [self.imageView3 removeFromSuperview];
        [self.button5 removeFromSuperview];
        
        [SingleManager defaultManager].webViewOrHidden = YES;
        self.oldId = nil;
        self.textView3.text = nil;
        
        self.textView3.text = [NSString stringWithFormat:@"\n%@",_contentStr];
        self.contentStr = nil;
        CGRect frame3 = self.textView3.frame;
        CGSize constraintSize3 = CGSizeMake(frame3.size.width, MAXFLOAT);
        CGSize size3 = [self.textView3 sizeThatFits:constraintSize3];
        
        if (size3.height > 100) {
            
            self.textView3.frame = CGRectMake(frame3.origin.x, frame3.origin.y, frame3.size.width, size3.height);
        }
        // 如果没有附件
        if (self.oldIdStr.length == 0) {
            
            [self.scrollView setupAutoContentSizeWithBottomView:self.textView3 bottomMargin:20];
        } else {
            
            [self.scrollView setupAutoContentSizeWithBottomView:self.collectionView bottomMargin:20];
        }
        
    } else {
        
        self.textView2.text = @"(无主题)";
        
        [self sendNoticePerfect];
    }
}

- (void)creatRightItem {
    
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStylePlain) target:self action:@selector(sendNotice)];
    self.rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _rightItem;
}
- (void)sendNotice {
    
    if ([self.label4.text length] == 0) {
        [self.view  makeToast:@"未选接收人" duration:2 position:nil];
    } else if ([self.textView2.text isEqualToString:@""]) {
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
            
            UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"未填写主题，确认继续发送吗？" preferredStyle:(UIAlertControllerStyleAlert)];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                self.textView2.text = @"(无主题)";
                
                
                [self sendNoticePerfect];
                
            }]];
            [self presentViewController:alertVc animated:YES completion:nil];
            
        } else {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未填写主题，确定继续发送吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1000;
            [alert show];
        }
        
    }else {
        /**
         * 发/转发 通知
         * @param baseUrl
         * @param subject 主题
         content 内容
         receiveUserId 接收人id 逗号分隔
         attIds 原附件id 逗号分隔
         sourceId 原通知id
         sourceContent 原文内容
         "/no/noticeMobile!sendNotice.action"
         */
        [self sendNoticePerfect];
        
    }
}

- (void)sendNoticePerfect {
                
                self.rightItem.enabled = NO;
                
                MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
                hub.alpha = 0.5;
                [self.view addSubview:hub];
                hub.backgroundColor = [UIColor lightGrayColor];
                //    hub.minSize = CGSizeMake(200.0f, 30.0f);
                hub.labelText = @"消息发送中";
                [self.view endEditing:NO];
                
                self.imageDataArr = [[NSMutableArray alloc] init];
                
                NSString * strID = [self.attachIDArray componentsJoinedByString:@","];
                //    NSLog(@"strID == %@",strID);
                self.oldIdStr = strID;
                
                NSData * data;
                for (UIImage * image in self.imageArray) {
                    
                    //        //判断图片是不是png格式的文件
                    //        if (UIImagePNGRepresentation(image)) {
                    //            //返回为png图像。
                    //            data = UIImagePNGRepresentation(image);
                    //        }else {
                    //返回为JPEG图像。
                    data = UIImageJPEGRepresentation(image, 0.8);
                    //        }
                    [self.imageDataArr addObject:data];
                }
                
                NSString * item = self.textView2.text.length?self.textView2.text:@"(无主题)";
                NSString * content ;
    
                if (_ifEdit) {
                    if (_contentStr.length != 0) {

                        content = [self.textView3.text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",self.contentStr]];
                    } else {
                        content = self.textView3.text;
                    }
                } else {
                    content = self.textView3.text;
                }
                content = self.contentStr;
    
                NSString *string = [NSString stringWithFormat:@"%@/no/noticeMobile!sendNotice.action",BaseURL];
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                params[@"subject"] = item;
    
            if (![NSString isBlankString:self.textView3.text]) {
        params[@"content"] = [NSString stringWithFormat:@"%@\n",self.textView3.text];
            }
                if (![NSString isBlankString:self.contentStr]) {
                    params[@"sourceContent"] = self.contentStr;
                }
    
                params[@"receiveUserId"] = self.receiveUserId;
                params[@"attIds"] = self.oldIdStr;
                params[@"sourceId"] = self.oldId;
                //    params[@"imToken"] = self.token;
                //    NSLog(@"self.contentStr == %@",self.contentStr);
                //    params[@"sourceContent"] = @"";
                
                urlString = [NSString stringWithFormat:@"%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&userId=%@&imToken=%@&dataSourceName=%@",string,_userName,_password,_userId,self.token,_dataSourceName];
                
                // attIds 原附件id 逗号分隔  sourceId 原通知id
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString * str = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];

                int i = 0;
                NSMutableString *upLoadString = [NSMutableString string];
                NSMutableArray *upLoadArray = [NSMutableArray array];
                
                for (NSString * fileName in self.imageName) {
                    
                    if (i < self.imageName.count ) {
                        //            [upLoadArray addObject:fileName];
                        if (i == 0) {
                            [upLoadString appendFormat:@"%@",fileName];
                            
                        }
                        else
                        {
                            [upLoadString appendFormat:@",%@",fileName];
                        }
                        i++;
                        //            NSString * str2 = [NSString stringWithFormat:@"uploadFileNames[%d]",i];
                        //            params[str2] = fileName;
                        //            i ++;
                    }
                }
                
                params[@"uploadFileNames"] = upLoadString;
            params[@"uploadFileNamesIOS"] = upLoadString;
    
                if (self.imageDataArr.count > 0) {
                    NSString *tmpString = [NSString stringWithFormat:@"%@/no/noticeMobile!sendNoticeFileIOS.action",BaseURL];
                    urlString = [NSString stringWithFormat:@"%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&userId=%@&imToken=%@&dataSourceName=%@",tmpString,_userName,_password,_userId,self.token,_dataSourceName];
                    NSLog(@"%@",urlString);
                }
                //    NSLog(@"_imageName 2222 == %d",(int)_imageName.count);
                //    NSLog(@"params = %@",params);
    
    
    
                AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
                
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                
                [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    
                [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    
                    
                    [_imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSData *imageData = obj;
                        NSString *fileName = [NSString stringWithFormat:@"%@%d.png",str,(int)idx];
                        
                        [formData appendPartWithFileData:imageData name:@"uploadFiles" fileName:fileName mimeType:@"image/png"];
                    }];
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    
                    self.rightItem.enabled = YES;
                    NSString * data = [[NSString  alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    //        NSLog(@"data == %@",data);
                    
                    UIWindow * window = [UIApplication sharedApplication].keyWindow;
                    
                    if ([data isEqualToString:@"ok"]) {
                        
                        [hub removeFromSuperview];
                        [window makeToast:@"发送成功" duration:2 position:nil];
                    } else {
                        [window makeToast:data duration:2 position:nil];
                    }
                    
                    [SingleManager defaultManager].content = nil;
                    [SingleManager defaultManager].item = nil;
                    [SingleManager defaultManager].assets = nil;
                    [SingleManager defaultManager].idStrArray = nil;
                    [SingleManager defaultManager].idStr = nil;
                    [SingleManager defaultManager].webViewOrHidden = NO;
                    
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSString *string = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
                    NSLog(@"%@",string);
                    UIWindow * window = [UIApplication sharedApplication].keyWindow;
                    [window makeToast:[error localizedDescription] duration:2 position:nil];
                    
                    self.rightItem.enabled = YES;
                    //        NSLog(@"上传失败,%@",[error localizedDescription]);
                }];
    
}

/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter 键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 键盘隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillBeHidden:)  name:UIKeyboardWillHideNotification object:nil];
}
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification{
    // 获取键盘的位置和大小
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // 获取输入框的位置和大小
    CGRect attatchBtnFrame = self.button2.frame;
    // 计算出输入框的y坐标
    attatchBtnFrame.origin.y = self.view.height - (keyboardBounds.size.height + attatchBtnFrame.size.height + 60);
    
    // 动画改变位置
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        // 更改输入框的位置
        self.button2.frame = attatchBtnFrame;
    }];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // 获取输入框的位置和大小
    CGRect attatchBtnFrame = self.button2.frame;
    
    attatchBtnFrame.origin.y = self.view.height - attatchBtnFrame.size.height - 60;
    
    // 动画改变位置
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        // 更改输入框的位置
        self.button2.frame = attatchBtnFrame;
    }];
}
//  用于限制输入   有输入时触发但对于中文键盘出示的联想字选择时不会触发
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if (textView == self.textView2) {
        
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
        
        if (caninputlen >= 0)
        {
            return YES;
        }
        else
        {
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            
            if (rg.length > 0)
            {
                NSString *s = [text substringWithRange:rg];
                
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            }
            return NO;
        }
    } else {
        return YES;
    }
    
}
- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView == self.textView1) {
        
        CGRect frame = self.textView1.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        CGSize size = [self.textView1 sizeThatFits:constraintSize];
        
        if (size.height > 44) {
            self.textView1.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
        }
        
    } else if (textView == self.textView2){
        NSString  *nsTextContent = textView.text;
        NSInteger existTextNum = nsTextContent.length;
        
        if (existTextNum > MAX_LIMIT_NUMS)
        {
            //截取到最大位置的字符
            NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
            
            [textView setText:s];
        }
        
        //不让显示负数
        NSInteger newNum = MAX_LIMIT_NUMS - existTextNum;
        if (newNum >= 50) {
            self.label3.textColor = [UIColor greenColor];
        } else if (newNum <= 10) {
            self.label3.textColor = [UIColor redColor];
        } else {
        
            self.label3.textColor = [UIColor TabBarColorYellow];
        }
        
        self.label3.text = [NSString stringWithFormat:@"还剩%d",(int)MAX(0,newNum)];
        self.label3.font = [UIFont boldSystemFontOfSize:10];
        self.label3.textColor = [UIColor colorWithRed:28/255.0 green:168/255.0 blue:248/255.0 alpha:1];
        
        SingleManager * manager = [SingleManager defaultManager];
        manager.item = textView.text;
        
//  %d self.label3.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,newNum),MAX_LIMIT_NUMS];
        
        CGRect frame2 = self.textView2.frame;
        
        CGSize constraintSize2 = CGSizeMake(frame2.size.width, MAXFLOAT);
        CGSize size2 = [self.textView2 sizeThatFits:constraintSize2];
        
        if (size2.height > 44) {
            
            self.textView2.frame = CGRectMake(frame2.origin.x, frame2.origin.y, frame2.size.width, size2.height);
        }
    } else {
        
        if (textView.text.length == 0) {
            _uilabel.text = @"请输入通知内容";
        }else{
            _uilabel.text = @"";
        }
        
        CGRect frame3 = self.textView3.frame;
        CGSize constraintSize3 = CGSizeMake(frame3.size.width, MAXFLOAT);
        CGSize size3 = [self.textView3 sizeThatFits:constraintSize3];
        
        if (size3.height > 100) {
            
            self.textView3.frame = CGRectMake(frame3.origin.x, frame3.origin.y, frame3.size.width, size3.height);
        }
        SingleManager * manager = [SingleManager defaultManager];
        manager.content = textView.text;
        
    }
}

- (void)getImageData {

    // 不移除会导致附件重复添加
    [self.imageName removeAllObjects];
    [self.imageArray removeAllObjects];

    
    [self.dataArray enumerateObjectsUsingBlock:^(ZLPhotoAssets  *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSURL *imageURL;
        if (![asset isKindOfClass:[AttachmentModel class]]) {
            
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                
                [self.imageArray addObject:[asset originImage]];
                imageURL  = [asset assetURL];
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
                    
                    ALAssetRepresentation *representation = [myasset defaultRepresentation];
                    NSString *fileName = [representation filename];
                    [self.imageName addObject:fileName];
                    
                };
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                
                [assetslibrary assetForURL:imageURL
                               resultBlock:resultblock
                              failureBlock:nil];
                
            
            }else if([asset isKindOfClass:[UIImage class]]){
                
                
                [self.imageArray addObject:(UIImage *)asset];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                self.dateName = [NSString stringWithFormat:@"%@%d.jpg",[formatter stringFromDate:[NSDate date]],arc4random_uniform(100)];
                
                [self.imageName addObject:_dateName];
            
            }else if ([asset isKindOfClass:[ZLCamera class]]){
                
                [self.imageArray addObject:[asset thumbImage]];
                imageURL  = [asset assetURL];
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
                    
                    ALAssetRepresentation *representation = [myasset defaultRepresentation];
                    NSString *fileName = [representation filename];
                    [self.imageName addObject:fileName];
                    
                };
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                
                [assetslibrary assetForURL:imageURL
                               resultBlock:resultblock
                              failureBlock:nil];
                
            
            }
        }
    }];
  
    [self.collectionView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self creatRightItem];
    
    if (self.imageName.count == 0) {
        
//        if (_dataArray.count > 0) {
//            
//        
//            MBProgressHUD * hub2 = [[MBProgressHUD alloc] initWithView:self.view];
//            [self.view addSubview:hub2];
//            hub2.alpha = 0.5;
//            hub2.labelText = @"正在添加图片";
//            
//        }
        
//        NSLog(@"(int)_imageName.count)11111 == %d",(int)_imageName.count);
//        dispatch_queue_t queue = dispatch_queue_create("image.cn", DISPATCH_QUEUE_CONCURRENT);
//        dispatch_async(queue, ^{
//            [NSThread sleepForTimeInterval:2];
            
            [self getImageData];
//            NSLog(@"dispatch_async1");
//        });
        
    }
    
    NSString * content = [SingleManager defaultManager].content;
    
    if (content.length == 0) {
        
//        self.textView3.text = [NSString stringWithFormat:@"\n\n\n\n发自智微校客户端"];
    }
    else {
        _uilabel.text =@"";
        
        self.textView3.text = content;
    }
   
    NSMutableArray * hahaArray = [NSMutableArray array];
    NSMutableArray * heheArray = [NSMutableArray array];
    
    if (self.modelArray.count != 0) {
        
        NSSet * setArray = [NSSet setWithArray:self.modelArray];
        
        for (UserModel * model in setArray) {
            [hahaArray addObject:model.name];
            [heheArray addObject:model.strId];
        }
        
        NSString * nameStr = [hahaArray componentsJoinedByString:@","];
        self.receiveUserId = [heheArray componentsJoinedByString:@","];
        self.label4.text = nameStr;
        CGSize maximumLabelSize = CGSizeMake(self.view.width - 120, MAXFLOAT);//labelsize的最大值
        
//        NSLog(@"maximumLabelSize == %@",NSStringFromCGSize(maximumLabelSize));
        //关键语句
        CGSize expectSize = [self.label4 sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        if (expectSize.height > 44) {
            
            self.label4.frame = CGRectMake(70, 50, expectSize.width, expectSize.height);
        }
    }
    
    self.textView2.text = [SingleManager defaultManager].item;
    CGRect frame2 = self.textView2.frame;
    CGSize constraintSize2 = CGSizeMake(self.view.width - 120, MAXFLOAT);
    CGSize size = [self.textView2 sizeThatFits:constraintSize2];
    if (size.height > 44) {
        
        self.textView2.frame = CGRectMake(frame2.origin.x, frame2.origin.y, size.width, size.height);
    }
 
    NSString  *nsTextContent = self.textView2.text;
    NSUInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS){
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [self.textView2 setText:s];
    }
    //不让显示负数
    NSInteger newNum = MAX_LIMIT_NUMS - existTextNum;
    if (newNum >= 50) {
        self.label3.textColor = [UIColor greenColor];
    } else if (newNum <= 10) {
        self.label3.textColor = [UIColor redColor];
    } else {
        self.label3.textColor = [UIColor TabBarColorYellow];
    }
    self.label3.text = [NSString stringWithFormat:@"还剩%d",(int)MAX(0,newNum)];
    self.label3.font = [UIFont boldSystemFontOfSize:10];
    self.label3.textColor = [UIColor colorWithRed:28/255.0 green:168/255.0 blue:248/255.0 alpha:1];
    
    
    BOOL WebYN = [SingleManager defaultManager].webViewOrHidden;
//    NSLog(@"webyn 1111 ===  %d",WebYN);// NO;
    
    if (WebYN && self.oldId !=nil) {
        
        [self.webView removeFromSuperview];
        [self.imageView3 removeFromSuperview];
        [self.button5 removeFromSuperview];
        
        self.oldId = nil;
        
        self.ifEdit = NO;
        self.textView3.text = [SingleManager defaultManager].content;
       
        CGRect frame3 = self.textView3.frame;
        CGSize constraintSize3 = CGSizeMake(frame3.size.width, MAXFLOAT);
        CGSize size3 = [self.textView3 sizeThatFits:constraintSize3];
        
        if (size3.height > 100) {
            
            self.textView3.frame = CGRectMake(frame3.origin.x, frame3.origin.y, frame3.size.width, size3.height);
        }
        
        if (self.oldIdStr.length != 0) {
            // 如果有附件
            int b = (int)[SingleManager defaultManager].idStrArray.count;
            if (b%2!=0) {
                
                b = b/2 + 1;
            }else {
                b = b/2;
            }
            self.collectionView.sd_layout
            .leftSpaceToView(self.scrollView, kNumber5)
            .rightSpaceToView(self.scrollView, kNumber5)
            .topSpaceToView(self.textView3, kNumber5)
            .heightIs(self.view.width/2*b);
            
            [self.scrollView setupAutoContentSizeWithBottomView:self.collectionView bottomMargin:20];
        } else {
            // 如果没有附件
            int c = (int)_assets.count;
            if (c%2!=0) {
                c = c/2+1;
            }else {
                c = c/2;
            }
            self.collectionView.sd_layout
            .leftSpaceToView(self.scrollView, kNumber5)
            .rightSpaceToView(self.scrollView, kNumber5)
            .topSpaceToView(self.textView3, kNumber5)
            .heightIs(self.view.width/2 * c );
            
            [self.scrollView setupAutoContentSizeWithBottomView:self.collectionView bottomMargin:20];
        }
    }
}

- (void)didClickButton {
    
    if (self.label4.text.length == 0) {
        
        TYHNewContacterController * newContact = [[TYHNewContacterController alloc] init];
        
        newContact.tempArray = [self getTempArray];
        newContact.modelArray = self.modelArray;
//        NSLog(@"%@",newContact.tempArray);
        
        [self.navigationController pushViewController:newContact animated:YES];
        
    }  else {//此处是已经选择的人展示页面,由于加入全选,此处开放f的话要判断全选相关问题
        
//        TYHChoosedPersonController * chooseContact = [[TYHChoosedPersonController alloc] init];
//
//        NSMutableArray * hahArray = [NSMutableArray array];
//        //modelArray   还差最近选择联系人的 选择
//        chooseContact.returnUserModelBlock = ^(NSMutableArray * modelArray){
//
//            _modelArray = [NSMutableArray arrayWithArray:modelArray];
//
//            for (UserModel * model in _modelArray) {
//
//                [hahArray addObject:model.strId];
//            }
//
//            self.tempArray = hahArray;
//        };
//
//        chooseContact.tempArray = [self getTempArray];
//
//        chooseContact.modelArray = self.modelArray;
//
//        [self.navigationController pushViewController:chooseContact animated:YES];
    }
    
}
// 添加联系人
- (void)addNewPerson:(UIButton *)btn{
    
    SingleManager * manager =  [SingleManager defaultManager];
    
    manager.item = self.textView2.text;
    manager.content = self.textView3.text;
    
    TYHNewContacterController * newContact = [[TYHNewContacterController alloc] init];
    
    newContact.tempArray = [self getTempArray];
    newContact.modelArray = self.modelArray;
    
    
    newContact.tempSelectGroupArray = self.tempSelectGroupArray;
    newContact.tempSelectGroupModelArray = self.tempSelectGroupModelArray;
    [self.navigationController pushViewController:newContact animated:YES];
    
}
- (NSMutableArray *)getTempArray {
    
    NSMutableArray * hahArray = [NSMutableArray array];
    for (UserModel * model in self.modelArray) {
        [hahArray addObject:model.strId];
    }
    self.tempArray = hahArray;
    
    return _tempArray;
}
@end
