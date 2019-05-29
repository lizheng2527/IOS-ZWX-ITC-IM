//
//  NSString+Empty.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 5/20/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Empty)

+ (BOOL) isBlankString:(NSString *)string;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;
@end
