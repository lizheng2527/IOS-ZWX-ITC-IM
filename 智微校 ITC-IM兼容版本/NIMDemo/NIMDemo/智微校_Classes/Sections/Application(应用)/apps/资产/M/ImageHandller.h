//
//  ImageHandller.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHandller : NSObject
+ (UIImage *)imageNeedDeal:(UIImage *)image rotation:(UIImageOrientation)orientation;
+ (UIImage *)imageNeedAddText:(UIImage *)image Test:(NSString *)text1;
+ (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage;

+ (UIImage *)imageNeedAddTextYiHaoPin:(UIImage *)image Test:(NSString *)text1;

+ (UIImage *)addWatemarkTextAfteriOS7_WithLogoImage:(UIImage *)logoImage watemarkText:(NSString *)watemarkText;
@end
