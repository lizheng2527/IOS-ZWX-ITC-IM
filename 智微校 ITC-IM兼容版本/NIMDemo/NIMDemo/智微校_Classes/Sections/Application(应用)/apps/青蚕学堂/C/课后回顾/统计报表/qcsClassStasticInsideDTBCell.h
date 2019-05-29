//
//  qcsClassStasticInsideDTBCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/9.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCSStasticListModel;

@interface qcsClassStasticInsideDTBCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (retain, nonatomic) UIImageView *scoreImageView;

@property(nonatomic,retain)UIView *lineView;

@property(nonatomic,retain)QCSStasticListModel *model;

@end
