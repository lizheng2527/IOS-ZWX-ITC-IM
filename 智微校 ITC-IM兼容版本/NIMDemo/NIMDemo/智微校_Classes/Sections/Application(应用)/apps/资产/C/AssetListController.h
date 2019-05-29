//
//  AssetListController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/26.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetListController : UIViewController
@property(nonatomic,retain)NSMutableArray *assetDatasource;

@property(nonatomic,copy)NSString *typeString;  //申请 && 查找 (只有这两种赋值)
@end
