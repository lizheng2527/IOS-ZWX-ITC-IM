//
//  ImageCollectionCell.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/12.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageChose;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *sizeName;
@property (weak, nonatomic) IBOutlet UILabel *imgName;
@property (weak, nonatomic) IBOutlet UIImageView *officeName;
@property (weak, nonatomic) IBOutlet UILabel *labelName;




@end
