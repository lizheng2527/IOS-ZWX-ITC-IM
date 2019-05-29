//
//  SingleManager.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "SingleManager.h"

@implementation SingleManager

static SingleManager * manager = nil;
+ (SingleManager *)defaultManager
{
    if (manager == nil) {
        
        manager = [[SingleManager alloc] init];
        
    }
    
    return manager;
}
-(id)init
{
    if (self = [super init]) {
        
        self.item = [[NSString alloc] init];
        self.content = [[NSString alloc] init];
        
        self.assets = [NSMutableArray array];
        self.idStr = [[NSString alloc] init];
        
        self.selectedSingelArray = [NSMutableArray array];
        self.idStrArray = [NSArray array];
        self.title = [[NSString alloc] init];
        self.rangeString = [[NSString alloc] init];
//        self.webViewOrHidden = NO;
    }
    return self;
}

//// 保存主题和内容
//- (void)savaTextItem:(NSString*)item withTextContent:(NSString *)content{
//
//    
//    
//}
//
//// 设置附件
//- (void)saveAttachment:(NSMutableArray *)array{
//
//}
//
//// 保存显示个数
//- (void)saveChooseCount:(NSInteger)count {
//
//}

@end
