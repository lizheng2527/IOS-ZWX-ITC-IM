//
//  ImageHandller.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "ImageHandller.h"
#import <AVFoundation/AVFoundation.h>
@implementation ImageHandller

//旋转图像
+ (UIImage *)imageNeedDeal:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

//添加时间戳文字
+ (UIImage *)imageNeedAddText:(UIImage *)image Test:(NSString *)text1
{
    int w = image.size.width;
    int h = image.size.height;
    text1 = [self getStringWithNameAndDate];
    UIGraphicsBeginImageContext(image.size);
    [[UIColor lightGrayColor] set];
    [image drawInRect:CGRectMake(0, 0, w, h)];
    
    CGRect addRect = CGRectMake(10, image.size.height - 30, image.size.width , 20);
//    CGRect addRect = CGRectMake(0, image.size.height / 2 - 10, image.size.width , 20);
    if([[[UIDevice currentDevice]systemName]floatValue] >= 7.0)
    {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:25], NSFontAttributeName,[UIColor blueColor] ,NSForegroundColorAttributeName,nil];
        [text1 drawInRect:addRect withAttributes:dic];
    }
    
//    else
//    {
//        //该方法在7.0及其以后都废弃了
        [text1 drawInRect:addRect withFont:[UIFont boldSystemFontOfSize:25]];
    
//    }
//    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

//添加水印图片
+ (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage
{
    UIGraphicsBeginImageContext(useImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    CGRect addRect = CGRectMake(10, 10, useImage.size.width / 3, useImage.size.width / 12);
    //四个参数为水印图片的位置
    [maskImage drawInRect:addRect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//获取系统时间并且获取用户名
+(NSString *)getStringWithNameAndDate
{
    NSMutableString *returnString = [NSMutableString string];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *nameString = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERNAME];
    [returnString appendFormat:@"%@ %@ #资产管理",nameString,dateString];
    return returnString;
}



+ (UIImage *)imageNeedAddTextYiHaoPin:(UIImage *)image Test:(NSString *)text1
{
    int w = image.size.width;
    int h = image.size.height;
    text1 = [self getStringWithNameAndDateYiHaoPin];
    UIGraphicsBeginImageContext(image.size);
    [[UIColor lightGrayColor] set];
    [image drawInRect:CGRectMake(0, 0, w, h)];
    
    CGRect addRect = CGRectMake(10, image.size.height - 40, image.size.width , 40);
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:30], NSFontAttributeName,[UIColor lightGrayColor] ,NSForegroundColorAttributeName,nil];
    [text1 drawInRect:addRect withAttributes:dic];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}


//获取系统时间并且获取用户名
+(NSString *)getStringWithNameAndDateYiHaoPin
{
    NSMutableString *returnString = [NSMutableString string];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *nameString = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERNAME];
    [returnString appendFormat:@"%@ %@ ",nameString,dateString];
    return returnString;
}





+ (UIImage *)addWatemarkTextAfteriOS7_WithLogoImage:(UIImage *)logoImage watemarkText:(NSString *)watemarkText{
    int w = logoImage.size.width;
    int h = logoImage.size.height;
    UIGraphicsBeginImageContext(logoImage.size);
    [[UIColor whiteColor] set];
    [logoImage drawInRect:CGRectMake(0, 0, w, h)];
    UIFont * font = [UIFont systemFontOfSize:50.0];
    [watemarkText drawInRect:CGRectMake(10, 55, 130, 80) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//+ (UIImage *)imageNeedAddTextYiHaoPinPhoto:(UIImage *)image Test:(NSString *)text1
//{
//    int w = image.size.width;
//    int h = image.size.height;
//    text1 = [self getStringWithNameAndDateYiHaoPin];
//    UIGraphicsBeginImageContext(image.size);
//    [[UIColor lightGrayColor] set];
//    [image drawInRect:CGRectMake(0, 0, w, h)];
//    
//    CGRect addRect = CGRectMake(10, image.size.height - 30, image.size.width , 20);
//    if([[[UIDevice currentDevice]systemName]floatValue] >= 7.0)
//    {
//        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:25], NSFontAttributeName,[UIColor blueColor] ,NSForegroundColorAttributeName,nil];
//        [text1 drawInRect:addRect withAttributes:dic];
//    }
//    [text1 drawInRect:addRect withFont:[UIFont boldSystemFontOfSize:25]];
//    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return aimg;
//}



@end
