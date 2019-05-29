//
//  ProjectMainCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/17.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectMainCell;
@class ProjectMainModel;

@protocol ProjectMainCellDelegate <NSObject>

@optional

- (void)InBtnClicked:(ProjectMainCell *)cell;

- (void)CheckClicked:(ProjectMainCell *)cell;

- (void)DetailBtnClicked:(ProjectMainCell *)cell;
@end


@interface ProjectMainCell : UITableViewCell
@property(nonatomic,retain)ProjectMainModel *model;


@property(nonatomic,assign)id<ProjectMainCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *setPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *setTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UIButton *inButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end
