//
//  CheackHomeworkViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/29.
//  Copyright © 2016年 Lanxum. All rights reserved.
//
#define myCyanColor colorWithRed:54/255.0 green:191/255.0 blue:181/255.0 alpha:1

#import "CheackHomeworkViewController.h"
#import "YMTapGestureRecongnizer.h"
#import <UIImageView+WebCache.h>
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface CheackHomeworkViewController ()<UITextViewDelegate>
@property(nonatomic,retain)NSMutableArray *imageArray;
@property(nonatomic,copy)NSString *contentString;

@property(nonatomic,assign)NSInteger clickTag;

@end

@implementation CheackHomeworkViewController
-(instancetype)initWithImageList:(NSMutableArray *)imageList contentString:(NSString *)content
{
    self = [super init];
    if (self) {
        [self initView];
        [self changeLeftBar];
//        _imageArray = [NSMutableArray arrayWithArray:imageList];
        NSLog(@"content : %@",content);
        _contentView.text = content;
        _imageArray = [NSMutableArray array];
        for (NSString *imageUrl in imageList) {
            NSString *tmpString = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,imageUrl];
            [_imageArray addObject:tmpString];
            NSLog(@"%@",tmpString);
        }
#pragma mark - 图片部分
        
        for (int  i = 0; i < [_imageArray count]; i++) {
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(((375 -  200)/4)*(i%3 + 1) +  40 * (i%3)  - 30, self.contentView.frame.size.height + 3 * ((i/3) + 1) + (i/3) *  80 + 10 + 10  , 80,80)];
            
            image.userInteractionEnabled = YES;
            UITapGestureRecognizer *_tapges  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageViewWithTags:)];
            [image addGestureRecognizer:_tapges];
            
            image.backgroundColor = [UIColor lightGrayColor];
            image.tag =  i+10000;
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            
            
            [image sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *imageTmp, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
               
//                                if (_imageArray.count == 1) {
//                                    float heightScale = 90/imageTmp.size.height/1.0;
//                                    float widthScale = 90/imageTmp.size.width/1.0;
//                                    float scale = MIN(heightScale, widthScale);
//                                    float h = imageTmp.size.height*scale;
//                                    float w = imageTmp.size.width*scale;
//
//                                    image.frame = CGRectMake(0 + 20 + 20, self.contentView.frame.size.height + 3 * ((i/3) + 1) + (i/3) *  80 + 10 + 10   , w,h);
//                                    if (h <80) {
//                                        image.frame = CGRectMake( 40, self.contentView.frame.size.height + 3 * ((i/3) + 1) + (i/3) *  80 + 10 + 10 , (80/h *w<230?(80/h *w):230),80);
//                                    }
//                                }
                            }];
                [self.view addSubview:image];
            }
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)initView
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
    _contentView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_contentView];
}


#pragma mark - 创建返回NavBarItem
-(void)changeLeftBar
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HomeWork_returns"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HomeWork_returns"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor myCyanColor]}];
    self.title = @"我的作业";
}


- (void)showImageViewWithTags:(UITapGestureRecognizer *)tap{
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < _imageArray.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.image = [imageViews objectAtIndex:i];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[_imageArray objectAtIndex:i]]];
        
        //设置来源哪一个UIImageView
        [photos addObject:photo];
    }
    
    brower.photos = photos;
    //3.设置默认显示的图片索引
    brower.currentPhotoIndex = tap.view.tag - 10000;
    
    //4.显示浏览器
    [brower show];
}




//- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
////    NSLog(@"%@",tapGes.appendArray)
//    [self showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
