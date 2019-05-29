//
//  PVisitRecordCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/29.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PVisitRecordCell.h"
#import "ProjectMainModel.h"


@implementation PVisitRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self initCellView];
    self.selectionStyle = NO;
}

-(void)setModel:(ProjectVisitRecordListModel *)model
{
    _model = model;
    _visitPersonLabel.text = model.visitor;
    _serviceTimeLabel.text = model.visitTime;
    _serviceCustomLabel.text = model.visitObject;
}

-(void)initCellView
{
    _detailButton.layer.masksToBounds = YES;
    _detailButton.layer.cornerRadius = 3.0f;
    _detailButton.layer.borderWidth = 0.5f;
    _detailButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (IBAction)detailAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(DetailBtnClickedInVisitRecord:)]) {
        [self.delegate DetailBtnClickedInVisitRecord:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
