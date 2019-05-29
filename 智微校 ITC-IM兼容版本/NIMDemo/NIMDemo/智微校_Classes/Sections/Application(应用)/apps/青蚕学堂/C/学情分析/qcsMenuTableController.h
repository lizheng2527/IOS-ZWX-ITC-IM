//
//  qcsMenuTableController.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol qcsMenuTableDelegate <NSObject>

@optional

- (void)menuTableCellSelectedWithIndexpathRowOfStudent:(NSInteger )row;

- (void)menuTableCellSelectedWithIndexpathRowOfBigData:(NSInteger )row;

- (void)menuTableCellSelectedWithIndexpathRowOfClass:(NSInteger )row;

@end





typedef NS_ENUM(NSUInteger,DrawerType) {
    DrawerDefaultLeft = 1, // 默认动画，左侧划出
    DrawerDefaultRight,    // 默认动画，右侧滑出
    DrawerTypeMaskLeft,    // 遮盖动画，左侧划出
    DrawerTypeMaskRight    // 遮盖动画，右侧滑出
};

typedef NS_ENUM(NSUInteger,TapType) {
    TapBigData = 1, //
    TapClass = 2,    //
    TapStudent = 3    //
};


@interface qcsMenuTableController : UIViewController

@property (nonatomic,assign) DrawerType drawerType; // 抽屉类型

@property(nonatomic,retain)NSMutableArray *bigDataArray;
@property(nonatomic,retain)NSMutableArray *studentArray;
@property(nonatomic,retain)NSMutableArray *classArray;
@property (nonatomic,assign)TapType tapType;

@property(nonatomic,weak)id<qcsMenuTableDelegate>delegate;
@end
