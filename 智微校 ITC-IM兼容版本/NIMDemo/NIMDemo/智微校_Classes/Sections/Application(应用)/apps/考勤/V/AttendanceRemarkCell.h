//
//  AttendanceRemarkCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/11/7.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttendanceRemarkCell;

@protocol AttendanceRemarkCellDelegate <NSObject>
-(void)remarkItemDelete:(AttendanceRemarkCell *)cell;
-(void)typeBtnChoose:(AttendanceRemarkCell *)cell;
@end


@interface AttendanceRemarkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
//@property (weak, nonatomic) IBOutlet UITextField *useageTextField;
@property (weak, nonatomic) IBOutlet UIButton *delegateBtn;
@property (weak, nonatomic) IBOutlet UIButton *useageBtn;

@property(nonatomic,assign)id<AttendanceRemarkCellDelegate>delegate;

@end
