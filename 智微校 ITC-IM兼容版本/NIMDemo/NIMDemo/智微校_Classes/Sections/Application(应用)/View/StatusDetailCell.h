//
//  StatusDetailCell.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/25/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;
@property (weak, nonatomic) IBOutlet UILabel *opTime;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *note;

@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end
