//
//  NoticeCell.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/10/20.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

//- (instancetype)initWithFrame:(CGRect)frame {
//
//    self = [super initWithFrame:frame];
//    if (self) {
//        CALayer  * layer = [self.logImage layer];
//        [layer setMasksToBounds:YES];
//        [layer setCornerRadius:30];
//    }
//    return self;
//}
//
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    if (self.editing == editing)
//    {
//        return;
//    }
//    
//    [super setEditing:editing animated:animated];
//    
//    if (editing)
//    {
//        self.selectionStyle = UITableViewCellSelectionStyleBlue;
//        self.backgroundView = nil;
//        self.textLabel.backgroundColor = [UIColor clearColor];
//        self.detailTextLabel.backgroundColor = [UIColor clearColor];
//        if (_m_checkImageView == nil)
//        {
//            _m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unselected.png"]];
////            _m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]];
//            _m_checkImageView.frame = CGRectMake(12, 25, 23, 23);
//            [self addSubview:_m_checkImageView];
//            
//        }
//        
//        [self setChecked:m_checked];
//        _m_checkImageView.center = CGPointMake(-CGRectGetWidth(_m_checkImageView.frame) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
//        _m_checkImageView.alpha = 0.0;
//        [self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5) alpha:1.0 animated:animated];
//    }
//    else
//    {
//        m_checked = NO;
//        self.selectionStyle = UITableViewCellSelectionStyleGray;
//        self.backgroundView = nil;
//        if (_m_checkImageView)
//        {
//            [self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(_m_checkImageView.frame) * 0.5,CGRectGetHeight(self.bounds) * 0.5)alpha:0.0 animated:animated];
//            
//        }
//    }
//}
//
//- (void)setChecked:(BOOL)checked
//{
//    if (checked)
//    {
//        _m_checkImageView.image = [UIImage imageNamed:@"Selected.png"];
//        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
//    }
//    else
//    {
//        _m_checkImageView.image = [UIImage imageNamed:@"Unselected.png"];
//        
////        _m_checkImageView.image = [UIImage imageNamed:nil];
//        self.backgroundView.backgroundColor = [UIColor whiteColor];
//    }
//    m_checked = checked;
//}
//
//- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
//{
//    if (animated)
//    {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationDuration:0.3];
//        
//        _m_checkImageView.center = pt;
//        _m_checkImageView.alpha = alpha;
//        [UIView commitAnimations];
//    }
//    else
//    {
//        _m_checkImageView.center = pt;
//        _m_checkImageView.alpha = alpha;
//    }
//}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.logImage.layer.cornerRadius = 8;
    self.logImage.layer.masksToBounds = YES;
//    self.logImage.clipsToBounds = YES;
}

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
