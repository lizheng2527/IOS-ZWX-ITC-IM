//
//  lookHomeworkViewController.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/28.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lookHomeworkViewController : UIViewController
@property(nonatomic,copy)NSString *homeworkID;

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeworkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeworkDuixiang;
@property (weak, nonatomic) IBOutlet UILabel *submitEndtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UILabel *deatilLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *homeworkBGview;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;


@property(nonatomic,retain)__block NSMutableArray *dataArray;

@end
