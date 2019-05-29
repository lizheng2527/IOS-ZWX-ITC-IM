//
//  RepairApplicationErrorCell.h
//  NIM
//
//  Created by 中电和讯 on 17/3/15.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTextView.h"

@interface RepairApplicationErrorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *errorDescribleLabel;

@property (weak, nonatomic) IBOutlet ETTextView *errorDescribleTextView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@end
