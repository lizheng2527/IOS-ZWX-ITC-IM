//
//  REquipmentTypeCollectionCell.m
//  NIM
//
//  Created by 中电和讯 on 17/3/13.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "REquipmentTypeCollectionCell.h"
#import "TYHRepairMainModel.h"
#import <UIImageView+WebCache.h>
#import "TYHRepairDefine.h"

@implementation REquipmentTypeCollectionCell
//{
//    NSString *userName;
//    NSString *password;
//    NSString *organizationID;
//    NSString *userID;
//    NSDictionary *userInfoDic;
//}
//
//#pragma mark - 获取用户基础数据
//-(void)getNeedData
//{
//    userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
//    password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
//    organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
//    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
//}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 15.0f;
}

-(void)setModel:(repairEquipmentTypeModel *)model
{
    self.itemNameLabel.text = model.name;
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_V3ServerURL,model.imageUrl]] placeholderImage:[UIImage imageNamed:@"icon_shebei"]];
    self.contentView.backgroundColor = [UIColor TabBarColorRepair];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.contentView.backgroundColor = [UIColor TabBarColorRepair];
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }];
}

@end
