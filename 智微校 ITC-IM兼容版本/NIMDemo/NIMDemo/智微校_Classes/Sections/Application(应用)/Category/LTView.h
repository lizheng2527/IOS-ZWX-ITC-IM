//
//  LTView.h
//  lesson_3
//
//  Created on 15/4/17.
//  Copyright (c) 2015年 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTView : UIView

//声明一个属性(代理用assign修饰)
@property(nonatomic,assign)id<UITextFieldDelegate>delegate;

//将对象声明成属性(外界也可以通过属性访问)
@property (nonatomic, retain) UITextField *textField;

//定义属性,重写setter方法
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, strong) UIImageView * imageView ;

//初始化方法
-(id)initWithFrame:(CGRect)frame description:(NSString *)text Delegate:(id<UITextFieldDelegate>)delegate;



@end
