//
//  HWDownloadCell.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/28.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWDownloadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *downloadimage;
@property (weak, nonatomic) IBOutlet UIImageView *fileTypeImage;

@end
