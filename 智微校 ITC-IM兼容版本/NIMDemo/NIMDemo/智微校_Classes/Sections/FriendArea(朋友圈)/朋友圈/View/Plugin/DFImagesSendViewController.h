//
//  DFImagesSendViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 16/2/15.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "DFImagesSendViewController.h"
#import "SchoolMatesModel.h"
@protocol DFImagesSendViewControllerDelegatee <NSObject>

@optional

-(void) onSendTextImage:(NSString *) text images:(NSArray *)images;


@end
@interface DFImagesSendViewController : UIViewController

@property(assign,nonatomic)BOOL isClassPaper;


@property (nonatomic, strong) id<DFImagesSendViewControllerDelegatee> delegate;

- (instancetype)initWithImages:(NSArray *) images;

@property(nonatomic,retain)classModel *tmpClassModel;

@property(nonatomic,retain)NSMutableArray *classArray;


@end
