//
//  SubmitHomeworkViewController.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/29.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SchoolMatesModel.h"
@protocol DFImagesSendViewControllerDelegate <NSObject>

@optional

-(void) onSendTextImage:(NSString *) text images:(NSArray *)images;


@end

@interface SubmitHomeworkViewController : UIViewController

@property(nonatomic,copy)NSString *homeworkID;

@property(assign,nonatomic)BOOL isClassPaper;


@property (nonatomic, strong) id<DFImagesSendViewControllerDelegate> delegate;

- (instancetype)initWithImages:(NSArray *) images andFinshString:(NSString *)finishString andHomeworkID:(NSString *)homeWorkID;


@property(nonatomic,retain)NSMutableArray *classArray;



@end
