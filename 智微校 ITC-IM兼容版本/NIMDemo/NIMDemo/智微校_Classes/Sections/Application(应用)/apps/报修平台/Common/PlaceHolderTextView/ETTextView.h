//
//  ETTextView.h
//  ElectronicTradingApp
//
//  Created by Huangqian on 15/8/26.
//  Copyright (c) 2015年 leimingtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETTextView : UITextView

/*!
 * @brief 占位符文本,与UITextField的placeholder功能一致
 */
@property (nonatomic, strong) NSString *placeholder;

/*!
 * @brief 占位符文本颜色
 */
@property (nonatomic, strong) UIColor *placeholderTextColor;

@end
