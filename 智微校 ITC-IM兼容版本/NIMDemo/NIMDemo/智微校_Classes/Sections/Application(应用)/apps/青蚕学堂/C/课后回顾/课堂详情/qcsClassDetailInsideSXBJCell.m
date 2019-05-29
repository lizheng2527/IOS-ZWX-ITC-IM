//
//  qcsClassDetailInsideSXBJCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/9.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassDetailInsideSXBJCell.h"
#import "QCSClassDetailModel.h"
#import <UIImageView+WebCache.h>
#import "QCSchoolDefine.h"
#import "QCSMainModel.h"


@implementation qcsClassDetailInsideSXBJCell

-(void)setSxbjModel:(QCSClassDetailSXBJModel *)sxbjModel
{
    self.titleLabel.text = sxbjModel.startTime;
    
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],sxbjModel.picUrl]] placeholderImage:[UIImage imageNamed:@"暂无图片Test"]];
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 1.f;
    self.imageView.layer.borderColor = [UIColor orangeColor].CGColor;
}

-(void)setBsjlModel:(QCSClassDetailBSJLModel *)bsjlModel
{
    self.titleLabel.text = bsjlModel.name;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],bsjlModel.downloadUrl]] placeholderImage:[UIImage imageNamed:@"暂无图片Test"]];
}

-(void)setInsideModel:(QCSClassDetailSXBJDetailModel *)insideModel
{
    self.titleLabel.text = insideModel.name;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],insideModel.picUrl]] placeholderImage:[UIImage imageNamed:@"暂无图片Test"]];
}

-(void)setStudentModel:(QCSMainStudentSXBJModel *)studentModel
{
    self.titleLabel.text = studentModel.name;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],studentModel.picUrl]] placeholderImage:[UIImage imageNamed:@"暂无图片Test"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
