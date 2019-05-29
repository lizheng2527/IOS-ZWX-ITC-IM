//
//  PVisitRecordCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/29.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PVisitRecordCell;
@class ProjectVisitRecordListModel;

@protocol PVisitRecordCellDelegate <NSObject>

@optional
- (void)CheckClickedInVisitRecord:(PVisitRecordCell *)cell;

- (void)DetailBtnClickedInVisitRecord:(PVisitRecordCell *)cell;
@end


@interface PVisitRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *visitPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceCustomLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@property(nonatomic,retain)ProjectVisitRecordListModel *model;
@property(nonatomic,assign)id<PVisitRecordCellDelegate>delegate;

@end
