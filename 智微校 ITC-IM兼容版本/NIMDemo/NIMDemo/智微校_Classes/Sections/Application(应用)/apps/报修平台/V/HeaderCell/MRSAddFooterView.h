//
//  MRSAddFooterView.h
//  NIM
//
//  Created by 中电和讯 on 2017/4/5.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRSAddFooterViewDelegate <NSObject>

@optional
-(void)partsItemAdd;
@end

@interface MRSAddFooterView : UIView

@property(nonatomic,assign)id<MRSAddFooterViewDelegate>delegate;

@property(nonatomic,retain)UILabel *titleLabel;

@end
