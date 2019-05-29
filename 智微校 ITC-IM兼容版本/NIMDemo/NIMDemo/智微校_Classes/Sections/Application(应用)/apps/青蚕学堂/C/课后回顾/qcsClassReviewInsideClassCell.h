//
//  qcsClassReviewInsideClassCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class qcsClassReviewInsideClassCell;
@class QCSMainCLassModel;


@protocol qcsClassReviewInsideClassCellDelegate <NSObject>

@optional

- (void)StasticsBtnClicked:(qcsClassReviewInsideClassCell *)cell;

- (void)InteractionBtnClicked:(qcsClassReviewInsideClassCell *)cell;

- (void)ClassDetailBtnClicked:(qcsClassReviewInsideClassCell *)cell;

@end


@interface qcsClassReviewInsideClassCell : UITableViewCell

@property(nonatomic,assign)id<qcsClassReviewInsideClassCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIButton *stasticButton;
@property (weak, nonatomic) IBOutlet UIButton *interativeButton;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@property(nonatomic,retain)QCSMainCLassModel *model;
@end
