//
//  AttendanceRemarkAddRowFooterView.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/11/7.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttendanceFooterViewDelegate <NSObject>
-(void)remarkItemAdd;
@end

@interface AttendanceRemarkAddRowFooterView : UIView
@property(nonatomic,assign)id<AttendanceFooterViewDelegate>delegate;
@end
