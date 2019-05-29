//
//  SGPopSelectView_Asset.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/10/19.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PopViewSelectedHandle) (NSInteger selectedIndex);

@interface SGPopSelectView_Asset : UIView
@property (nonatomic, strong) NSArray *selections;
@property(nonatomic,  copy)NSString *locationString;

@property(nonatomic,strong)NSMutableArray *selectArray;
@property (nonatomic, copy) PopViewSelectedHandle selectedHandle;
@property (nonatomic, readonly) BOOL visible;

- (instancetype)init;
- (void)showFromView:(UIView*)view atPoint:(CGPoint)point animated:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
