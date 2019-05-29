//
//  TYHRepairMainHeaderView.h
//  NIM
//
//  Created by 中电和讯 on 17/3/11.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TYHRepairMainHeaderViewDelegate <NSObject>

@optional
- (void)CheckAllRepairListWithType:(NSString *)type;

@end

@interface TYHRepairMainHeaderView : UICollectionReusableView

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,copy)UIButton *checkBtn;
@property(nonatomic,copy)NSString *type;

@property(nonatomic,assign)id<TYHRepairMainHeaderViewDelegate>delegate;
@end
