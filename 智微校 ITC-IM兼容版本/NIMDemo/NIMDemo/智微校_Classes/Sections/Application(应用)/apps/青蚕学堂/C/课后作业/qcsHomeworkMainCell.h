//
//  qcsHomeworkMainCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/5/22.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KRVideoPlayerController.h>

@class qcsHomeworkModel;
@class qcsHomeworkMainCell;

@protocol qcsHomeworkMainCellDelegate <NSObject>
@optional

- (void)didClickDelButtonInCell:(qcsHomeworkMainCell *)cell;
- (void)didClickEditButtonInCell:(qcsHomeworkMainCell *)cell;

@end


@interface qcsHomeworkMainCell : UITableViewCell<UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pushClassTitleLabel;


@property (weak, nonatomic) IBOutlet UILabel *titleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *pushLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *detailTexttLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *sourceContainerView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceViewHeight;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);


@property(nonatomic,retain)qcsHomeworkModel *model;

@property (nonatomic, weak) id<qcsHomeworkMainCellDelegate> delegate;

@property (nonatomic, strong) KRVideoPlayerController *videoController;
@end
