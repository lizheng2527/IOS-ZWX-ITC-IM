//
//  ButtonCell.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/29/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYHAssetManagerItemModel;

@interface ButtonCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *number;

@property(nonatomic,retain)TYHAssetManagerItemModel *managerItemModel;

@property(nonatomic,retain)id repairModel;
@end
