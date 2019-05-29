//
//  RepairApplicationPlaceCell.h
//  NIM
//
//  Created by 中电和讯 on 17/3/15.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RepairApplicationPlaceCell;

@protocol RepairApplicationPlaceCellDelegate <NSObject>

@optional

- (void)chooseSchool:(RepairApplicationPlaceCell *)cell;

- (void)chooseBuilding:(RepairApplicationPlaceCell *)cell;

- (void)chooseFloor:(RepairApplicationPlaceCell *)cell;

- (void)chooseClass:(RepairApplicationPlaceCell *)cell;

@end

@interface RepairApplicationPlaceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *chooseSchoolBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseBuildingBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseFloorBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseRoomBtn;

@property(nonatomic,assign)id<RepairApplicationPlaceCellDelegate>delegate;

@property(nonatomic,retain)NSMutableArray *placeArray;
@end
