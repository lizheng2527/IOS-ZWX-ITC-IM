//
//  TYHFindPasswordCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/11/10.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYHFindPasswordCell;



@protocol FindPasswordCellDelegate <NSObject>
@optional
-(void)getAjaxCodeAction:(TYHFindPasswordCell *)cell;
@end



@interface TYHFindPasswordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property(nonatomic,assign)id<FindPasswordCellDelegate>delegate;
@end
