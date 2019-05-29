//
//  WHApplicationDetailItemCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHMyItemListModel;


@interface WHApplicationDetailItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property(nonatomic,retain)WHMyItemListModel *model;
@end
