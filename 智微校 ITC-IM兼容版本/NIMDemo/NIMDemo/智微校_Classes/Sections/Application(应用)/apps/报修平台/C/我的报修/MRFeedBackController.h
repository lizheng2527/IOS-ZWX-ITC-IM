//
//  MRFeedBackController.h
//  NIM
//
//  Created by 中电和讯 on 2017/4/10.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ETTextView;

@interface MRFeedBackController : UIViewController

@property(nonatomic,copy)NSString *repairID;

@property (weak, nonatomic) IBOutlet ETTextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UILabel *yesLabel;

@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
