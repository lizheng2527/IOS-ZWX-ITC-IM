//
//  NTESNoticeSelPerTableViewCell.h
//  NIM
//
//  Created by 中电和讯 on 2019/11/1.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NTESNoticeSelPerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView * selectImage;

@end

NS_ASSUME_NONNULL_END
