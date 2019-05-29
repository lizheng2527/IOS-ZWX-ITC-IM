//
//  CarStatustaskCell.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/18/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarStatusModel.h"
@interface CarStatustaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *arriveTime;
@property (weak, nonatomic) IBOutlet UILabel *telephone;
@property (weak, nonatomic) IBOutlet UILabel *useTime;
@property (weak, nonatomic) IBOutlet UILabel *arrivePlace;
@property (weak, nonatomic) IBOutlet UIButton *detailCar;
@property (weak, nonatomic) IBOutlet UIButton *optionalOne;
@property (weak, nonatomic) IBOutlet UIButton *optionalTwo;
@property (weak, nonatomic) IBOutlet UIButton *optionalThree;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNum;
@property (weak, nonatomic) IBOutlet UILabel *orderCar;
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;
@property (nonatomic, copy) NSString * orderCarId;
@property (nonatomic, copy) NSString * checkStatus;
//- (void)cellConfigueWithModel:(CarStatusModel *)model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionalOneFrame;

@property (weak, nonatomic) IBOutlet UILabel *arriveTimeLabel;
@end
