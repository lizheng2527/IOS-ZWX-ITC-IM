//
//  LTView.m
//  lesson_3
//
//  Created on 15/4/17.
//  Copyright (c) 2015年 All rights reserved.
//

#import "LTView.h"
//宏定义
#define LTHeight frame.size.height//LTHeight替换成frame.seze.height
#define LTWeight frame.size.width

//第一种方式:通过延展的方式声明成实例变量,但是这个实例变量只能被本类和其子类访问
@interface LTView()
//{
//    UITextField *_textField;
//}

@end

@implementation LTView


//初始化方法
-(id)initWithFrame:(CGRect)frame description:(NSString *)text Delegate:(id<UITextFieldDelegate>)delegate
{
    self=[super initWithFrame:frame];
    if (self) {
        self.label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, LTWeight/4.0, LTHeight -1)];
        _label.text=text;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        //引用计数加1,用self.防止野指针情况造成的崩溃
        self.textField=[[UITextField alloc]initWithFrame:CGRectMake(LTWeight/4.0, 0, LTWeight - LTWeight/4.0, LTHeight-1)];
//        _textField.layer.cornerRadius=6.0;
//        _textField.layer.borderWidth=1.0;
        _textField.borderStyle=UITextBorderStyleNone;
        //设置textField代理
        _textField.delegate=delegate;
        _textField.textColor = [UIColor darkGrayColor];
        [self addSubview:_textField];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, LTWeight, 1)];
        imageView.image = [UIImage imageNamed:@"分割线"];
        self.imageView = imageView;
        [self addSubview:imageView];
    }
    return self;
}
- (void)setImageView:(UIImageView *)imageView {

    _imageView = imageView;
}
- (void)setLabel:(UILabel *)label {

    _label = label;
    
}
//重写属性delegate的setter方法
-(void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    //assign修饰,直接赋值
    _textField.delegate=delegate;
    
}

@end
