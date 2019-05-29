//
//  CheackHomeworkViewController.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/29.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheackHomeworkViewController : UIViewController
@property (nonatomic, strong) UITextView *contentView;
-(instancetype)initWithImageList:(NSMutableArray *)imageList contentString:(NSString *)content;

@end
