//
//  qcsClassDetailInsideJXKJCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/9.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QCSClassDetailJXKJModel;


@interface qcsClassDetailInsideJXKJCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *processView;

@property(nonatomic,retain)QCSClassDetailJXKJModel *model;

@end
