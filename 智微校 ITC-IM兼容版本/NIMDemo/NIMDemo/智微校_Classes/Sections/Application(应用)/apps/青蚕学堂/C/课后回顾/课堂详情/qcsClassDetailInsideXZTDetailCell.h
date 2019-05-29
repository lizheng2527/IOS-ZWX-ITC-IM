//
//  qcsClassDetailInsideXZTDetailCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCSClassDetailXZTInsideModel;


@interface qcsClassDetailInsideXZTDetailCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property(nonatomic,retain)QCSClassDetailXZTInsideModel *model;
@end
