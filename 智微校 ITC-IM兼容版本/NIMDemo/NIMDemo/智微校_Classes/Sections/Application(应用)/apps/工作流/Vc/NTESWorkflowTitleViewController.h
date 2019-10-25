//
//  NTESWorkflowTitleViewController.h
//  NIM
//
//  Created by 中电和讯 on 2019/10/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DropDownMenu;

@protocol TitleMenuDelegate2 <NSObject>
#pragma mark 当前选中了哪一行
@required
- (void)selectAtIndexPath:(NSIndexPath *)indexPath title:(NSString*)title;

@end

@interface NTESWorkflowTitleViewController : UITableViewController
@property (nonatomic, weak) id<TitleMenuDelegate2> delegate;
@property (nonatomic, strong) NSMutableArray * tempdata;
@property (nonatomic, weak) DropDownMenu * drop;

@property (nonatomic, assign) int count;
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
