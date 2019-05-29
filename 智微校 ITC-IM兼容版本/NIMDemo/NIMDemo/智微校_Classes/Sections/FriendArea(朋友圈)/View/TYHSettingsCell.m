//
//  TYHSettingsCell.m
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/10.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import "TYHSettingsCell.h"

@implementation TYHSettingsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self initContentView];
}

-(void)setStateModel:(NewStateModel *)stateModel
{
    
}



-(void)initContentView
{
    self.nnewContent_Image.layer.masksToBounds = YES;
    self.nnewContent_Image.layer.cornerRadius = self.nnewContent_Image.frame.size.width / 2;
    self.nnewContent_Image.hidden = YES;
    
    self.nnewContent_Label.layer.masksToBounds = YES;
    self.nnewContent_Label.layer.cornerRadius = self.nnewContent_Label.frame.size.width / 2;
    self.nnewContent_Label.hidden = YES;
    
    self.nnewLikeOrComment_Label.layer.masksToBounds = YES;
    self.nnewLikeOrComment_Label.layer.cornerRadius = self.nnewLikeOrComment_Label.frame.size.width / 2;
    self.nnewLikeOrComment_Label.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
