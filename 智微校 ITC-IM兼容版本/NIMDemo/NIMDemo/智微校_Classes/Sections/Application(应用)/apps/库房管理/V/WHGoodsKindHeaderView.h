//
//  WHGoodsKindHeaderView.h
//  NIM
//
//  Created by 中电和讯 on 2017/4/8.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHGoodsKindModel;
@class WHGoodsKindInnerModel;
@class WHGoodsKindHeaderView;


@protocol WHGoodsKindHeaderViewDelegate <NSObject>

@optional
-(void)likeRowCellClicker:( WHGoodsKindHeaderView *)headerView;

@end

typedef void(^HYBHeaderViewExpandCallback)(BOOL isExpanded);


@interface WHGoodsKindHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) WHGoodsKindModel *model;
@property (nonatomic, copy) HYBHeaderViewExpandCallback expandCallback;

@property(nonatomic,assign)id<WHGoodsKindHeaderViewDelegate>delegate;

@end
