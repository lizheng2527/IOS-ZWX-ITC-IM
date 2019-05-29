//
//  TYHTittleViewController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/10/20.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownMenu;

@protocol TitleMenuDelegate <NSObject>
#pragma mark 当前选中了哪一行
@required
- (void)selectAtIndexPath:(NSIndexPath *)indexPath title:(NSString*)title;
@end

@interface TYHTittleViewController : UITableViewController

@property (nonatomic, weak) id<TitleMenuDelegate> delegate;

@property (nonatomic, weak) DropDownMenu * drop;

@property (nonatomic, assign) int count;
@property (nonatomic, assign) NSInteger index;

@end
