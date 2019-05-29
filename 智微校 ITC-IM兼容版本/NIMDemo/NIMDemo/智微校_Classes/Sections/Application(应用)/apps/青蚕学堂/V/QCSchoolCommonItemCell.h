//
//  QCSchoolCommonItemCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/3/30.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCSSourceModel;


@interface QCSchoolCommonItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *IconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,retain)QCSSourceModel *model;

@end
