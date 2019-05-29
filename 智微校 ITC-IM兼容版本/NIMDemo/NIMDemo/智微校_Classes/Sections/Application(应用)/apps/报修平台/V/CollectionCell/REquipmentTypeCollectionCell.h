//
//  REquipmentTypeCollectionCell.h
//  NIM
//
//  Created by 中电和讯 on 17/3/13.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class repairEquipmentTypeModel;

@interface REquipmentTypeCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;

@property(nonatomic,retain)repairEquipmentTypeModel *model;
@end
