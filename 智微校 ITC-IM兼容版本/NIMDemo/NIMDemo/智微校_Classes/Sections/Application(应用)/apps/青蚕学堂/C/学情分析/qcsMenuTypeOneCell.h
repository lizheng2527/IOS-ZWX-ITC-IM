//
//  qcsMenuTypeOneCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/27.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  QCSSourceModel;

@interface qcsMenuTypeOneCell : UITableViewCell
@property(nonatomic,retain)QCSSourceModel *modelStudent;
@property(nonatomic,retain)QCSSourceModel *modelClass;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
