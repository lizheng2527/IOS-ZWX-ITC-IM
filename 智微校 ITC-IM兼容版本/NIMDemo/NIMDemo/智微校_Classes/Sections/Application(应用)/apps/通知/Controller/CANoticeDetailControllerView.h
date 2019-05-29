//
//  CANoticeDetailControllerView.h
//  NIM
//
//  Created by 中电和讯 on 2018/9/29.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoticeModel;


@interface CANoticeDetailControllerView : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property(nonatomic,retain)NSString *titleString;
@property(nonatomic,retain)NSString *detailString;
@property(nonatomic,retain)NSString *navTitleString;


@property(nonatomic,assign)BOOL shouldHideRightBar;
@property(nonatomic,retain)NoticeModel *model;
@end
