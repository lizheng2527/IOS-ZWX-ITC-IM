//
//  WHDiliverMainCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHMyDetailModel;
@class WHDiliverMainCell;


@protocol WHDiliverMainCellDelegate <NSObject>

@optional
- (void)applyDateBtnDidClick:(WHDiliverMainCell *)cell;

- (void)applyOutWarehouseBtnDidClick:(WHDiliverMainCell *)cell;

- (void)applyUseKindBtnDidClick:(WHDiliverMainCell *)cell;

-(void)applyUserBtnDidClick:( WHDiliverMainCell *)cell;

-(void)applyDepartmentBtnDidClick:( WHDiliverMainCell *)cell;
@end


@interface WHDiliverMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *numberTextfield;
@property (weak, nonatomic) IBOutlet UIButton *outDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *outWarehouseBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseDepartmentBtn;

@property (weak, nonatomic) IBOutlet UILabel *makeDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *userPersonLabel;

@property (weak, nonatomic) IBOutlet UILabel *handlerPersonLabel;

@property (weak, nonatomic) IBOutlet UITextField *tipTextfield;

@property(nonatomic,retain)WHMyDetailModel *model;

@property(nonatomic,assign)id<WHDiliverMainCellDelegate>delegate;

@end
