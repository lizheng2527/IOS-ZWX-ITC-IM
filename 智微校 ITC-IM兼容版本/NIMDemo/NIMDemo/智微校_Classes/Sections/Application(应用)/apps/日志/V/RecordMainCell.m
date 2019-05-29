//
//  RecordMainCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/17.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RecordMainCell.h"
#import "RecordModel.h"

@implementation RecordMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(RecordModel *)model
{

    self.nameLabel.text = model.userName;
    self.planLabel.text = model.plan;
    self.workTimeLabel.text = [NSString stringWithFormat:@"%@小时",model.effectiveTime] ;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",model.workStartTime,model.workEndTime];
    self.summarizeLabel.text = model.summarize;
    self.noteLabel.text = model.remark;
    
    if (model.attachmentList.count > 0) {
        self.attachNumLabel.text = [NSString stringWithFormat:@"%lu个附件",(unsigned long)model.attachmentList.count];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
