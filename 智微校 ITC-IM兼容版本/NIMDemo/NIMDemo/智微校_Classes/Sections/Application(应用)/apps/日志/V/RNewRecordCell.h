//
//  RNewRecordCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNewRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UITextField *workTimeTextfield;
@property (weak, nonatomic) IBOutlet UITextView *planTextview;
@property (weak, nonatomic) IBOutlet UITextView *summarizeTextview;
@property (weak, nonatomic) IBOutlet UITextView *noteTextview;


@end
