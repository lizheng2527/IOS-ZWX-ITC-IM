//
//  WHApplicationItemCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/16.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHApplicationItemCell;

@protocol WHApplicationItemCellDelegate <NSObject>

@required

-(void)itemWillAdd:( WHApplicationItemCell *)cell;
-(void)itemWillDiscrease:( WHApplicationItemCell *)cell;
-(void)itemWillDel:(WHApplicationItemCell *)cell;

@end

@interface WHApplicationItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *decreaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UITextField *itemCountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *itemPriceTextField;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceNameLabel;

@property (nonatomic,assign) id<WHApplicationItemCellDelegate> delegate;

@end
