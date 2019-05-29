//
//  TYHRecordListCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/19.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHRecordListCell.h"
#import "CommentRecordListModel.h"
#import <UIImageView+WebCache.h>
#import "SDAutoLayout.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation TYHRecordListCell

-(void)setRecordModel:(CommentRecordListModel *)model withKind:(NSString *)kind
{
    self.nameLabel.text = model.userName;
    self.timeLabel.text = model.displayTime;
    self.commentDetailLabel.text = model.content;
    if ([kind isEqualToString:@"0"])
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,model.headUrl]] placeholderImage:[UIImage imageNamed:@"mk-photo"]];
    else
        self.userIcon.image = [UIImage imageNamed:@"defult_classhead"];
    self.contentDetailLabel.text = model.momentContent;
    if ([self isBlankString:model.picUrl]) {
        [self.contentFirstImage removeFromSuperview];
    }
    else
    {
        [self.contentDetailLabel removeFromSuperview];
        [self.contentFirstImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,model.picUrl]] placeholderImage:[UIImage imageNamed:@"hhh"]];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.width / 2;
    self.contentDetailLabel.sd_layout.topSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).bottomSpaceToView(self.contentView,10).widthIs(50).heightIs(50);
    self.contentFirstImage.sd_layout.topSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).bottomSpaceToView(self.contentView,10).widthIs(50).heightIs(50);
    self.commentDetailLabel.sd_layout.leftSpaceToView(self.contentView,75).rightSpaceToView(self.contentView,70);
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
