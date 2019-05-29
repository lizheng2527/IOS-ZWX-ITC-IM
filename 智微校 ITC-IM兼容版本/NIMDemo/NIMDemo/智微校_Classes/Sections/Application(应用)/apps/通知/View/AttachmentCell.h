//
//  AttachmentCell.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/11/6.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numIndex;
@property (weak, nonatomic) IBOutlet UIImageView *officeImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) NSString * imageurl;
@property (weak, nonatomic) IBOutlet UIImageView *downloadimage;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, copy) NSString * strnews;
+ (CGFloat)cellAutoLayoutHeight:(NSString *)str;

@end
