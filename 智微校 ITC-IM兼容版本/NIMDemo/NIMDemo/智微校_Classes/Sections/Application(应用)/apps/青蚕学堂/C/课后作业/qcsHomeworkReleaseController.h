//
//  qcsHomeworkReleaseController.h
//  NIM
//
//  Created by 中电和讯 on 2018/5/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class qcsHomeworkModel;
@class ETTextView;


@interface qcsHomeworkReleaseController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *mainScrollview;

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionBGView;

@property (weak, nonatomic) IBOutlet ETTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *chooseImageButton;
@property (weak, nonatomic) IBOutlet UIButton *saveRecordButton;

@property (weak, nonatomic) IBOutlet UIButton *chooseObjectButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseTimeButton;

@property (weak, nonatomic) IBOutlet UIButton *releaseButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainCollectionBGViewLayoutHeight;


@property(nonatomic,copy)NSString *chooseObjectName;
@property(nonatomic,copy)NSString *chooseObjectID;
@property(nonatomic,copy)NSString *chooseGradeID;
@property(nonatomic,copy)NSString *chooseClassID;
@property(nonatomic,copy)NSString *chooseCourseID;

@property(nonatomic,copy)NSString *chooseTypeName;
@property(nonatomic,copy)NSString *chooseTypeID;
@property(nonatomic,copy)NSString *chooseFinishTime;

@property(nonatomic,retain)NSMutableArray *studentCourseArray;

@property(nonatomic,retain)qcsHomeworkModel *preDetailModel;
@end
