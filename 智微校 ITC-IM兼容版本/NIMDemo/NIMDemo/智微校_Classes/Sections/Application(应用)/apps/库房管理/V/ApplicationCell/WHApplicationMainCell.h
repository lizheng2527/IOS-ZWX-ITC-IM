//
//  WHApplicationMainCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/16.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHApplicationMainCell;
@class WHApplicationModel;


@protocol WHApplicationMainCellDelegate <NSObject>

@required
- (void)applyDateBtnDidClick:(WHApplicationMainCell *)cell;

- (void)applyOrgBtnDidClick:(WHApplicationMainCell *)cell;

- (void)applyCheckerBtnDidClick:(WHApplicationMainCell *)cell;

- (void)applyTypeBtnDidClick:(WHApplicationMainCell *)cell;

@end



@interface WHApplicationMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *applyNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *applyDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyOrgBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyCheckerBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *applyReasonTF;
@property (weak, nonatomic) IBOutlet UITextField *applyTipTF;

@property(nonatomic,retain)WHApplicationModel *model;
@property(assign,nonatomic)id<WHApplicationMainCellDelegate>delegate;
@end
