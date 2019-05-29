//
//  AssetSearchConditionController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/27.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface AssetSearchConditionController : UIViewController

@property(nonatomic,retain)NSMutableArray *tmpDataArray;


@property (weak, nonatomic) IBOutlet UIButton *assetAllTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *assetAllTypeLabel;

@property (weak, nonatomic) IBOutlet UIButton *assetUnSeriseBtn;
@property (weak, nonatomic) IBOutlet UILabel *assetUnSeriseLabel;

@property (weak, nonatomic) IBOutlet UIButton *assetSeriseBtn;
@property (weak, nonatomic) IBOutlet UILabel *assetSeriseLabel;

@property (weak, nonatomic) IBOutlet UITextField *assetTFSaveSchool;
@property (weak, nonatomic) IBOutlet UITextField *assetTFSaveArea;
@property (weak, nonatomic) IBOutlet UITextField *assetTFType;
@property (weak, nonatomic) IBOutlet UITextField *assetTFBrand;
@property (weak, nonatomic) IBOutlet UITextField *assetTFGuige;
@property (weak, nonatomic) IBOutlet UITextField *assetTFName;
@property (weak, nonatomic) IBOutlet UITextField *assetTFCode;

@property (weak, nonatomic) IBOutlet UIButton *assetBtnStartDate;
@property (weak, nonatomic) IBOutlet UIButton *assetBtnEndDate;


@property(nonatomic,retain)NSMutableArray *assetArrayWithinChoose;
@property(nonatomic,copy)NSString *assetTypeWithinChooseID;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstant;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrollview;


@end
