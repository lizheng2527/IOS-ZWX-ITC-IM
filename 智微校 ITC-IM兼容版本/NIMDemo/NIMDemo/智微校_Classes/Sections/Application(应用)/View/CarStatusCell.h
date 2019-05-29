//
//  CarStatusCell.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/24/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarStatusModel.h"

@interface CarStatusCell : UITableViewCell
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
@property (nonatomic, copy) NSString * orderCarId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionalTwoFrame;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionalThreeFrame;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionalOneFrame;


@property (nonatomic, copy) NSString * checkStatus;
@property (nonatomic, copy) NSString * evaluateFlag;


@property (weak, nonatomic) IBOutlet UILabel *arriveTimeLabel;


@end
