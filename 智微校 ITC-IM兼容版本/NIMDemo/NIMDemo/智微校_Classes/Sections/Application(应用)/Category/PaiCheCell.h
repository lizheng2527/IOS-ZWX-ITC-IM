//
//  PaiCheCell.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/13/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaiCheCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *useButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *carNumber;
@property (weak, nonatomic) IBOutlet UILabel *carPerson;
@property (weak, nonatomic) IBOutlet UIImageView *carimageView;
@property (weak, nonatomic) IBOutlet UILabel *fullLabel;

@end
