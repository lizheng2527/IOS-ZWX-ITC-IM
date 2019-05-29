//
//  ProjectMainCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/17.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "ProjectMainCell.h"
#import "ProjectMainModel.h"


@implementation ProjectMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initCellView];
    self.selectionStyle = NO;
}

-(void)setModel:(ProjectMainModel *)model
{
    _model = model;
    
    self.customNameLabel.text = model.clientName;
    self.setPersonLabel.text = model.buildUserName;
    self.setTimeLabel.text = model.buildDate;
    self.projectNameLabel.text = model.projectName;
    
    if ([model.inOrNot isEqualToString:@"0"]) {
        self.inButton.hidden = YES;
    }else self.inButton.hidden = NO;
    
    if ([model.status isEqualToString:@"0"]) {
        
    }
    else if([model.status isEqualToString:@"1"])
    {
        
    }else if([model.status isEqualToString:@"2"])
    {
        
    }
}

-(void)initCellView
{
    _detailButton.layer.masksToBounds = YES;
    _detailButton.layer.cornerRadius = 3.0f;
    _detailButton.layer.borderWidth = 0.5f;
    _detailButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _inButton.layer.masksToBounds = YES;
    _inButton.layer.cornerRadius = 3.0f;
    _inButton.layer.borderWidth = 0.5f;
    _inButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _checkButton.layer.masksToBounds = YES;
    _checkButton.layer.cornerRadius = 3.0f;
    _checkButton.layer.borderWidth = 0.5f;
    _checkButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


#pragma mark - ButtonClick

- (IBAction)checkAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(CheckClicked:)]) {
        [self.delegate CheckClicked:self];
    }
}
- (IBAction)inAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(InBtnClicked:)]) {
        [self.delegate InBtnClicked:self];
    }
}
- (IBAction)detailAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(DetailBtnClicked:)]) {
        [self.delegate DetailBtnClicked:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
