//
//  AttachmentViewController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/11/6.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttachmentModel.h"
@class AttachDropMenu;

@protocol AttachmentViewControllerDelegate <NSObject>
@optional
-(void)tableViewDidSelectWithUrl:(NSURL *)url;
@end

@interface AttachmentViewController : UITableViewController

@property (nonatomic, weak) AttachDropMenu * drop;
@property (nonatomic, strong) AttachmentModel * attachModel;
@property (nonatomic, strong) NSArray * attachmentArray;
@property(nonatomic,assign)id<AttachmentViewControllerDelegate>delegate;

@end
