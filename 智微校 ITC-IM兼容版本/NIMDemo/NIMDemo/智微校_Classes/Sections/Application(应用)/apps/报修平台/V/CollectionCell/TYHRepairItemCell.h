//
//  TYHRepairItemCell.h
//  NIM
//
//  Created by 中电和讯 on 17/3/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHRepairItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *number;

@property(nonatomic,retain)id repairModel;

@end
