//
//  qcsClassDetailInsideSXBJCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/9.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCSClassDetailSXBJModel;
@class QCSClassDetailBSJLModel;
@class QCSClassDetailSXBJDetailModel;

@class QCSMainStudentSXBJModel;


@interface qcsClassDetailInsideSXBJCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,retain)QCSClassDetailSXBJModel *sxbjModel;

@property(nonatomic,retain)QCSClassDetailBSJLModel *bsjlModel;

@property(nonatomic,retain)QCSClassDetailSXBJDetailModel *insideModel;

@property(nonatomic,retain)QCSMainStudentSXBJModel *studentModel;
@end
