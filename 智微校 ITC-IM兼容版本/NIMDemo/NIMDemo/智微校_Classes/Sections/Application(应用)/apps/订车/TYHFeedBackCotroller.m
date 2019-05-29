//
//  TYHFeedBackCotroller.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/20/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHFeedBackCotroller.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIView+SDAutoLayout.h"
#import "LHRatingView.h"
#import "TYHLabel.h"
#import "TYHHttpTool.h"
#import <UIView+Toast.h>
#import "LTView.h"

#define Color colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1
#define kWidth self.view.frame.size.width
#define kHeight 30

@interface TYHFeedBackCotroller ()<ratingViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic)  TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) UIButton * commitBtn;
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) LTView * view1;

// 评分 tag
@property (nonatomic, strong) NSMutableDictionary * dictScore;
@property (nonatomic, strong) NSMutableArray * tagArray;
@property (nonatomic, strong) NSMutableArray * Tag;

// 意见 tag
@property (nonatomic, strong) NSMutableDictionary * dictScore2;
@property (nonatomic, strong) NSMutableArray * tagArray2;
@property (nonatomic, strong) NSMutableArray * Tag2;

@property (nonatomic, strong) LHRatingView * rateView;
@property (nonatomic, strong) NSMutableArray * allDataArray;
@property (nonatomic, strong) NSMutableArray * textArray;
@property (nonatomic, strong) NSMutableArray * arrayScore;

@end

@implementation TYHFeedBackCotroller

- (NSMutableArray *)arrayScore {

    if (_arrayScore == nil) {
        _arrayScore = [[NSMutableArray alloc] init];
    }
    return _arrayScore;
}
- (NSMutableArray *)textArray {

    if (_textArray == nil) {
        _textArray = [[NSMutableArray alloc] init];
    }
    return _textArray;
}
- (NSMutableArray *)allDataArray {
 
    if (_allDataArray == nil) {
        _allDataArray = [[NSMutableArray alloc] initWithObjects:@"",@"出车司机",@"出车车辆", nil];
    }
    return _allDataArray;
}

- (NSMutableArray *)tagArray2 {

    if (_tagArray2 == nil) {
        _tagArray2 = [[NSMutableArray alloc] init];
    }
    return _tagArray2;
}
- (NSMutableArray *)Tag2 {

    if (_Tag2 == nil) {
        _Tag2 = [[NSMutableArray alloc] init];
    }
    return _Tag2;
}

- (NSMutableArray *)tagArray {

    if (_tagArray == nil) {
        _tagArray = [[NSMutableArray alloc] init];
    }
    return _tagArray;
}
- (NSMutableDictionary *)dictScore {

    if (_dictScore == nil) {
        _dictScore = [[NSMutableDictionary alloc] init];
    }
    return _dictScore;
}
- (NSMutableDictionary *)dictScore2 {

    if (_dictScore2 == nil) {
        _dictScore2 = [[NSMutableDictionary alloc] init];
    }
    return _dictScore2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    TPKeyboardAvoidingScrollView *scrollView = [TPKeyboardAvoidingScrollView new];
    [self.view addSubview:scrollView];
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    
    if (self.starData) {
        [self.allDataArray addObjectsFromArray:self.starData];
    }
    
    // 页面背景颜色
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    BOOL countY = self.assignData.count > 1?YES:NO;
    // assignData数组
    for (int j = 0; j < self.assignData.count; j++) {
        
        NSDictionary * dict = self.assignData[j];
    
        // 顶部
        TYHLabel * carLabel1 = [[TYHLabel alloc] init];
        [self.view addSubview:carLabel1];
        carLabel1.textAlignment = NSTextAlignmentLeft;
        [self.scrollView addSubview:carLabel1];

        if (countY) {
            
            carLabel1.font = [UIFont systemFontOfSize:12];
            carLabel1.backgroundColor = [UIColor Color];
            carLabel1.text = [NSString stringWithFormat:@"     车辆%d",j+1];
            
            if (j == 0 ) {
                
                carLabel1.sd_layout
                .leftSpaceToView(self.scrollView, 0)
                .topSpaceToView(self.scrollView, 20)
                .heightIs(20).widthIs(self.view.width);
                
            } else {
                
                carLabel1.sd_layout
                .leftSpaceToView(self.scrollView, 0)
                .topSpaceToView(self.textView, 20)
                .heightIs(20).widthIs(self.view.width);
            }
            
        } else {
            
            carLabel1.sd_layout
            .leftSpaceToView(self.scrollView, 20)
            .topSpaceToView(self.scrollView, 10)
            .heightIs(1).widthIs(60);
        }
        
        TYHLabel * carLabel = [[TYHLabel alloc] init];
        [self.view addSubview:carLabel];
        carLabel.sd_layout
        .leftSpaceToView(self.scrollView, 20)
        .topSpaceToView(carLabel1, 10)
        .heightIs(kHeight).widthIs(60);
        carLabel.text = @"出车司机";
        carLabel.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:carLabel];
        
        TYHLabel * carName = [[TYHLabel alloc] init];
        [self.view addSubview:carName];
        carName.textAlignment = NSTextAlignmentLeft;
        carName.sd_layout
        .leftSpaceToView(carLabel, 20)
        .topSpaceToView(carLabel1,10)
        .heightIs(kHeight).rightSpaceToView(self.scrollView, 20);
        carName.text = dict[@"driver"]; // 传参
        [self.scrollView addSubview:carName];
        
        TYHLabel * car = [[TYHLabel alloc] init];
        [self.view addSubview:car];
        car.sd_layout
        .leftSpaceToView(self.scrollView, 20)
        .topSpaceToView(carLabel,10)
        .heightIs(kHeight).widthIs(60);
        car.text = @"出车车辆";
        car.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:car];
        
        TYHLabel * carType = [[TYHLabel alloc] init];
        [self.view addSubview:carType];
        carType.textAlignment = NSTextAlignmentLeft;
        carType.sd_layout
        .leftSpaceToView(car, 20)
        .topSpaceToView(carName,10)
        .heightIs(kHeight).rightSpaceToView(self.scrollView, 20);
        carType.text = [NSString stringWithFormat:@"%@ %@",dict[@"carName"],dict[@"carNum"]]; // 传参
        [self.scrollView addSubview:carType];
        
        
        UIImageView * imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"分割线"];
        imageView.sd_layout
        .leftSpaceToView(self.scrollView, 20)
        .topSpaceToView(carType,10)
        .heightIs(1).rightSpaceToView(self.scrollView, 20);
        [self.scrollView addSubview:imageView];
        
        self.Tag = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.starData.count; i++) {
            
            LTView * view = [[LTView alloc] initWithFrame:CGRectMake(0, 20 + i *kHeight, kWidth, kHeight) description:self.starData[i][@"name"] Delegate:self];
            view.label.frame =CGRectMake(0, 0, kWidth/6.0, kHeight);
            view.textField.frame =CGRectMake(kWidth/6.0, 0, kWidth * 5/6.0, kHeight);
            view.label.font = [UIFont systemFontOfSize:15];
            view.imageView.hidden = YES;
            // 保存上一个 view
            [self.view addSubview:view];
            
            LHRatingView * rateView  = [[LHRatingView alloc]initWithFrame:CGRectMake(0, -8, 200, 40)];
            NSInteger integer = (1001 + i) * (j+1);
            rateView.tag = integer;
            view.tag = integer;
            
            [self.tagArray addObject:[NSString stringWithFormat:@"%d",(int)view.tag]];
            
            rateView.ratingType = INTEGER_TYPE;//整颗星
            rateView.delegate = self;
            [view.textField addSubview:rateView];
            
            if (i == 0) {
                view.sd_layout
                .leftSpaceToView(self.scrollView, 0)
                .topSpaceToView(imageView,20)
                .rightSpaceToView(self.scrollView,0)
                .heightIs(kHeight + 10);
            }
            else {
                // 特殊处理
                view.sd_layout
                .leftSpaceToView(self.scrollView, 0)
                .rightSpaceToView(self.scrollView, 0)
                .topSpaceToView(self.view1, 0)
                .heightIs(kHeight + 10);
            }
            [self.scrollView addSubview:view];
            // 保存上一个 View
            self.view1 = view;
        }
        
        // 底部
        TYHLabel * pingjia = [[TYHLabel alloc] init];
        [self.view addSubview:pingjia];
        pingjia.sd_layout
        .leftSpaceToView(self.scrollView, 20)
        .topSpaceToView(_view1,15)
        .heightIs(kHeight).widthIs(60);
        pingjia.text = @"评价意见";
        pingjia.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:pingjia];
        
        self.textView = [[UITextView alloc] init];
        self.textView.delegate = self;
        self.textView.tag = j+100;
        
        [self.tagArray2 addObject:[NSString stringWithFormat:@"%d", (int)self.textView.tag]];
        
        [self.view addSubview:self.textView];
        self.textView.layer.cornerRadius = 5;
        self.textView.layer.masksToBounds = YES;
        self.textView.layer.borderWidth = 0.5;
        self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.textView.sd_layout
        .leftSpaceToView(pingjia, 20)
        .topSpaceToView(_view1,15)
        .heightIs(120).rightSpaceToView(self.scrollView, 20);
        [self.scrollView addSubview:self.textView];
        
    }
    // 添加 提交订车单
    [self setupCommitBtn];
    [self.scrollView setupAutoContentSizeWithBottomView:self.commitBtn bottomMargin:10];
}

//  获取评分
#pragma mark - ratingViewDelegate
- (void)ratingView:(LHRatingView *)view score:(CGFloat)score {
    
    for (int j = 0; j < self.assignData.count; j ++) {
    
        for (int i = 0; i < self.starData.count; i++) {
        
            [self.dictScore setObject:[NSString stringWithFormat:@"%d",(int)score] forKey:[NSString stringWithFormat:@"%ld",(long)view.tag]];
        }
    
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {

    for (int i = 0; i < self.assignData.count; i ++) {
        
        for (int i = 0; i < self.starData.count; i++) {
            
            [self.dictScore2 setObject:self.textView.text forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
        }
        
    }
}

#pragma mark == setupCommitBtn
- (void)setupCommitBtn {
    
    UIButton * commitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:commitBtn];
    [self.scrollView addSubview:commitBtn];
    
    commitBtn.sd_layout
    .leftSpaceToView(self.scrollView, 20)
    .rightSpaceToView(self.scrollView, 20)
    .topSpaceToView(self.textView,10)
    .heightIs(50);
    
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"蓝色按钮"] forState:(UIControlStateNormal)];
    [commitBtn setTitle:@"提交评价" forState:(UIControlStateNormal)];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 4;
    self.commitBtn = commitBtn;
    [commitBtn addTarget:self action:@selector(createOrderReverse:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)createOrderReverse:(UIButton *)btn {
    
    [self.view endEditing:YES];
    
    // 保留原始 tag 值
    [self.Tag addObjectsFromArray:self.tagArray];
    [self.Tag2 addObjectsFromArray:self.tagArray2];
    
    // 保存最终数组
    NSMutableArray * scoreArray = [[NSMutableArray alloc] init];
    NSMutableArray * scoreArray2 = [[NSMutableArray alloc] init];
    NSArray * newArray =  [self.dictScore allKeys];
    NSArray * newArray2 =  [self.dictScore2 allKeys];

    // 判断评分数组与实际需要评分的选项是否相同
    for (int i = 0; i < newArray.count; i++) {
        // 移除已经填写的
        if ([self.tagArray containsObject:newArray[i]]) {
            [self.tagArray removeObject:newArray[i]];
        }
    }
    for (int i = 0; i < newArray2.count; i++) {
        // 移除已经填写的
        if ([self.tagArray2 containsObject:newArray2[i]]) {
            [self.tagArray2 removeObject:newArray2[i]];
        }
    }
    
    // 这是表示有部分评分没有评 默认给零
    if (self.tagArray.count > 0) {
        for (int j = 0; j<self.tagArray.count; j++) {
            [self.dictScore setObject:@"0" forKey:self.tagArray[j]];
        }
    }
    if (self.tagArray2.count > 0) {
        for (int j = 0; j<self.tagArray2.count; j++) {
            // 空的
            [self.dictScore2 setObject:@"" forKey:self.tagArray2[j]];
        }
    }
    
    for (int i = 0; i < self.dictScore.count; i++) {
        // 按 tag 数组重新按顺序排序
        NSString * key1 = self.Tag[i];
       [self.dictScore enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
          
           if ([key isEqualToString:key1]) {
               
               [scoreArray addObject:obj];
               *stop = YES;
           }
       }];
    }
    for (int i = 0; i < self.dictScore2.count; i++) {
        // 按 tag 数组重新按顺序排序
        NSString * key1 = self.Tag2[i];
        [self.dictScore2 enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([key isEqualToString:key1]) {
                [scoreArray2 addObject:obj];
                *stop = YES;
            }
        }];
    }
    
    NSString * satisfaction = [scoreArray componentsJoinedByString:@","];
    
    MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.alpha = 0.5;
    [self.view addSubview:hub];
    hub.backgroundColor = [UIColor lightGrayColor];
    //    hub.minSize = CGSizeMake(200.0f, 30.0f);
    hub.labelText = @"正在评价";
    
    NSDictionary * dict = [NSDictionary dictionary];
    NSMutableArray * jsonArray = [NSMutableArray array];
    NSInteger integer = self.starData.count; // 3
    // 3
    for (int i = 0; i < self.assignData.count; i ++) {
        
        // (1,2,3 , 4,5,6)          (0,4)   (6,10)  4  3  5
        // (1,2,3,4 ,5,6,7,8)       (0,6)   (8,14)  6  4  6
        // (1,2,3,4,5 , 6,7,8,9,10) (0,8)   (10,18) 8  5  7
        NSRange range;
        if (i == 0) {
            range  = NSMakeRange(integer*i, integer + 3);
        } else {
            range  = NSMakeRange( integer*(i+1), integer + 3);
        }
    
        dict = @{
                 @"oaCarId":self.assignData[i][@"assignId"],
                 @"satisfaction": [satisfaction substringWithRange:range],
                 @"feedback":scoreArray2[i]
                 };
        [jsonArray addObject:dict];
        
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error]; // 只读
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"resultJson"] = jsonString;
    
    NSString *strUrl = self.urlStr2;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [TYHHttpTool gets:strUrl params:params success:^(id json) {
        
        NSString * string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        // 正在操作
        if (_One) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            
        } else {
            
            if ([string isEqualToString:@"ok"]) {
                
                [hub removeFromSuperview];
                if (self.returnCheckSuccess2) {
                    
                    self.returnCheckSuccess2(YES);
                }
                [window makeToast:@"评价已提交" duration:2 position:nil];
                
            } else {
                [window makeToast:string duration:2 position:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        
        }
    } failure:^(NSError *error) {
        // 不知道为什么 已经派车成功还是走这里
        [hub removeFromSuperview];
        NSLog(@"%@",[error localizedDescription]);
        
    }];
    
}
@end
