//
//  TYHCheckViewController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/12/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHCheckViewController.h"
#import "TYHHttpTool.h"
#import <UIView+Toast.h>
#import "TYHCarManagerController.h"

@interface TYHCheckViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusName;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UIButton *unpassButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitCheck;

@property (nonatomic, strong) MBProgressHUD * hub;
@property (nonatomic, assign) int a;

- (IBAction)commit:(id)sender;

@property (nonatomic, strong) UIButton * currentSelectedBtn;

@end

@implementation TYHCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1];
    
    // Do any additional setup after loading the view from its nib.
    NSString * contentStr = _statusName.text;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //设置：在0-1个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    _statusName.attributedText = str;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_passButton setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:(UIControlStateNormal)];
    _passButton.selected = YES;
    [_passButton setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:(UIControlStateSelected)];
    [_passButton addTarget:self action:@selector(pass:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [_unpassButton setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:(UIControlStateNormal)];
    [_unpassButton setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:(UIControlStateSelected)];
    [_unpassButton addTarget:self action:@selector(pass:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.currentSelectedBtn = _passButton;
    _commitCheck.layer.cornerRadius = 4;
    _commitCheck.layer.masksToBounds = YES;
    [_commitCheck setTitle:@"提交审核" forState:(UIControlStateNormal)];
    _textView.layer.cornerRadius = 4;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    MBProgressHUD * hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.alpha = 0.5;
    hub.backgroundColor = [UIColor lightGrayColor];
    //    hub.minSize = CGSizeMake(200.0f, 30.0f);
    hub.labelText = @"正在提交审核";
    self.hub = hub;
    
    _a = 1;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
    
}
- (void)pass:(UIButton *)btn {

    self.currentSelectedBtn.selected = NO;
    // 设置传入按钮选中的状态
    btn.selected = YES;
    // 设置当前按钮为传入的状态
    self.currentSelectedBtn = btn;
    
    if ([self.currentSelectedBtn isEqual:_passButton]) {
        
        _a = 1;
    } else if ([self.currentSelectedBtn isEqual:_unpassButton]) {
        _a = 2;
    }
    
}

// /cm/carMobile!getInputBaseInformation.action
- (IBAction)commit:(id)sender {
    ///cm/carMobile!checkOrderCar.action
    [self.view endEditing:YES];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"advice"] = self.textView.text;
    
    NSString * passStr = [NSString stringWithFormat:@"%@&status=%d",_urlStr,_a];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.hub];
    [TYHHttpTool get:passStr params:params success:^(id json) {
       
        // a = 1 通过 a = 2 不通过
        NSString * data = [[NSString alloc] initWithData:json encoding:(NSUTF8StringEncoding)];
        [self.hub removeFromSuperview];
        
        if (_One) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            
        } else {
        
            if ([data isEqualToString:@"ok"]) {
                if (self.returnCheckSuccess) {
                    
                    self.returnCheckSuccess(YES);
                }

                [self.navigationController popViewControllerAnimated:YES];
                [window makeToast:@"已审核" duration:2 position:nil];
            } else {
                [window makeToast:data duration:2 position:nil];
            }
        }

    } failure:^(NSError *error) {
        
        [self.hub removeFromSuperview];
        if (_One) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil];
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            
        } else {
            
                if (self.returnCheckSuccess) {
                    
                    self.returnCheckSuccess(YES);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                [window makeToast:@"已审核" duration:2 position:nil];
           
        }
        NSLog(@"%@",[error localizedDescription]);
    }];
    
    
}
@end
