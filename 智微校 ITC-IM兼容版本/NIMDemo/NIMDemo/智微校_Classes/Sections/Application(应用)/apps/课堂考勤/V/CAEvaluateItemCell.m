//
//  CAEvaluateItemCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/1/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "CAEvaluateItemCell.h"
#import "PPNumberButton.h"
#import "ClassAttendanceModel.h"
#import "CAEvaluateController.h"

@interface CAEvaluateItemCell() <PPNumberButtonDelegate>

@end


@implementation CAEvaluateItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
    self.contentView.backgroundColor= [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
    
    self.itemNumberButtonView.delegate = self;
    self.itemNumberButtonView.shakeAnimation = YES;
    
    _itemNumberButtonView.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        NSLog(@"%ld",num);

    };
}

-(void)setModel:(CAEvaluateItemModel *)model
{
    _model = model;
    self.itemNameLabel.text = model.name;
    self.itemNumberButtonView.currentNumber = [_model.defaultNum integerValue];
    
    self.itemNumberButtonView.maxValue = [model.max integerValue];
    self.itemNumberButtonView.minValue = [model.min integerValue];
    
//    if (model.isSelected) {
//        [self.itemSelectButton setImage:[UIImage imageNamed:@"CA_radio"]forState:UIControlStateSelected];
//    }else
//         [self.itemSelectButton setImage:[UIImage imageNamed:@"CA_radio_nor"]forState:UIControlStateNormal];
    
}


#pragma mark - PPNumberButtonDelegate
- (void)pp_numberButton:(PPNumberButton *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus
{
    _model.score = [NSString stringWithFormat:@"%ld",number];
}


-(void)hasLectureScroe
{
    if ([[[self getCurrentVC] class] isEqual:[CAEvaluateController class]])
    {
        UIViewController *currentController = [self getCurrentVC];
        [currentController.view makeToast:[NSString stringWithFormat:@"此评价项评分范围(%@~%@)分",_model.min,_model.max] duration:1.5 position:CSToastPositionCenter];
    }
}

-(void)hasUnderScroe
{
    if ([[[self getCurrentVC] class] isEqual:[CAEvaluateController class]])
    {
        UIViewController *currentController = [self getCurrentVC];
        [currentController.view makeToast:[NSString stringWithFormat:@"此评价项评分范围(%@~%@)分",_model.min,_model.max] duration:1.5 position:CSToastPositionCenter];
    }
}

#pragma mark - Private

- (IBAction)selectClickedAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemSelectButtonClicked:)]) {
        [self.itemSelectButton setSelected:!_itemSelectButton.isSelected];
        
        self.itemSelectButton.isSelected?[self.itemSelectButton setImage:[UIImage imageNamed:@"CA_radio"] forState:UIControlStateSelected]:[self.itemSelectButton setImage:[UIImage imageNamed:@"CA_radio_nor"] forState:UIControlStateNormal];
        
        [self.delegate itemSelectButtonClicked:self];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
