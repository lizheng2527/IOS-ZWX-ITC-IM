//
//  qcsStudyAnalyticsSearcuClassController.h
//  NIM
//
//  Created by 中电和讯 on 2018/5/2.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qcsStudyAnalyticsSearcuClassController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *chooseGradeButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;


@property(nonatomic,retain)NSMutableArray *gradeArray;

@end
