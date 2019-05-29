//
//  MRADetailCell.m
//  NIM
//
//  Created by 中电和讯 on 17/3/22.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MRADetailCell.h"
#import "MyRepairApplicationModel.h"
#import "RepairManagementModel.h"


@implementation MRADetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self viewConfig];
    self.selectionStyle = NO;
}

-(void)setModel:(MyRepairApplicationModel *)model
{
    
    self.cellRepairID = model.repairID;
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@报修",model.placeName,model.DeviceName];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.applyTime];
    
    self.statusLabel.text = [NSString stringWithFormat:@"%@",model.statusView];
    
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",model.faultDescription];
    
    if ([model.statusCode isEqualToString:@"0"]) {
        self.delBtnRightSpaceLayout.constant = 12;
        self.feedBackBtn.hidden = YES;
    }
    else if([model.statusCode isEqualToString:@"1"])
    {
            self.feedBackBtn.hidden = YES;
//            self.delBtnRightSpaceLayout.constant = 12;
            self.delBtn.hidden = YES;
    }
    else if([model.statusCode isEqualToString:@"2"])
    {
        self.feedBackBtn.hidden = NO;
        self.delBtn.hidden = YES;
    }
//    else if([model.statusCode isEqualToString:@"3"])
//    {
//        self.feedBackBtn.hidden = NO;
//        self.delBtn.hidden = YES;
//    }
//    else if([model.statusCode isEqualToString:@"4"])
//    {
//        self.feedBackBtn.hidden = NO;
//        self.delBtn.hidden = YES;
//    }
}


-(void)setMyServerModel:(RepairManagementModel *)myServerModel
{
    self.delBtn.hidden = YES;
    
    self.cellRepairID = myServerModel.repairID;
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@报修",myServerModel.placeName,myServerModel.DeviceName];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",myServerModel.applyTime];
    
    self.statusLabel.text = [NSString stringWithFormat:@"%@",myServerModel.statusView];
    
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",myServerModel.faultDescription];
    
    if ([myServerModel.statusCode isEqualToString:@"2"]) {
        self.feedBackBtn.hidden = YES;
    }
    else if ([myServerModel.statusCode isEqualToString:@"1"]) {
        self.feedBackBtn.hidden = NO;
    }
}




- (IBAction)lookAction:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(LookBtnClicked:)]) {
        [self.delegate LookBtnClicked:self];
    }
}

- (IBAction)feedBackAction:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(FeedBackClicked:)]) {
        [self.delegate FeedBackClicked:self];
    }
}

- (IBAction)deleteAction:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(DelBtnClicked:)]) {
        [self.delegate DelBtnClicked:self];
    }
}


-(void)viewConfig
{
    _lookBtn.layer.masksToBounds = YES;
    _lookBtn.layer.cornerRadius = 3.0f;
    _lookBtn.layer.borderWidth = .5f;
    _lookBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _delBtn.layer.masksToBounds = YES;
    _delBtn.layer.cornerRadius = 3.0f;
    _delBtn.layer.borderWidth = .5f;
    _delBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    _feedBackBtn.layer.masksToBounds = YES;
    _feedBackBtn.layer.cornerRadius = 3.0f;
    _feedBackBtn.layer.borderWidth = .5f;
    _feedBackBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
