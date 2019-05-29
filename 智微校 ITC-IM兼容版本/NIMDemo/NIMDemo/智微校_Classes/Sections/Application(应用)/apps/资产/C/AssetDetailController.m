//
//  AssetDetailController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/1.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetDetailController.h"
#import "AssetNetWorkHelper.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "TYHAssetModel.h"
#import <UIImageView+WebCache.h>
#import "AssetSearchConditionController.h"
#import <MJExtension.h>
#import "AssetDiliverWaitController.h"

@interface AssetDetailController ()

@end

@implementation AssetDetailController
{
    NSString *imageURL;
    
    AssetMineDetailModel *mineDetailModel;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"资产卡片";
    [self createBarItem];
    [self requestData];
    if (![_whoGoinType isEqualToString:@"扫码进入"]) {
        _diliverBtn.hidden = YES;
    }
}

-(void)setWhoGoinType:(NSString *)whoGoinType
{
    _whoGoinType = whoGoinType;
}

-(void)setAssetCode:(NSString *)assetCode
{
    _assetCode = assetCode;
}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray.count && dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:dataArray];
    }
    else
        _dataArray = [NSMutableArray array];
}


#pragma mark - initData
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper getAssetDetailJsonWithAssetId:_assetCode andStatus:^(BOOL successful, AssetDetailModel *detailModel) {
        [self initViewWithModel:detailModel];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
    }];
}



#pragma mark - initView
-(void)initViewWithModel:(AssetDetailModel *)model
{
    _assetNameLabel.text = model.name;
    _assetTypeLabel.text = model.assetKindName;
    _assetCodeLabel.text = model.code;
    _assetStateLabel.text = model.statusView;
    _assetGuiGeLabel.text = model.patternName;
    
    _assetSavePersonLabel.text = model.custodian;
    _assetSvaeCodeLabel.text = model.stockNumber;
    _assetBuyDateLabel.text = model.purchaseDate;
    _assetOwnOraLabel.text = model.increaseWay;
    _assetBrandLabel.text = model.purchaseFactory;
    _assetPriceLabel.text = [NSString stringWithFormat:@"%ld",(long)model.unitPrice];
    _assetSolveLimitLabel.text = [NSString stringWithFormat:@"%ld",(long)model.warrantyPeriod];
    _assetAddDateLabel.text = model.registrationDate;
    
    [_assetImageViewTap sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_V3ServerURL,model.imageURL]] placeholderImage:[UIImage imageNamed:@"暂无图片Test"] completed:nil];
    
    _assetImageViewTap.layer.masksToBounds = YES;
    _assetImageViewTap.layer.borderWidth = 0.5f;
    _assetImageViewTap.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _assetImageViewTap.layer.cornerRadius = 3;
    _assetImageViewTap.userInteractionEnabled = YES;
    if (model.imageURL.length > 0) {
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
        [_assetImageViewTap addGestureRecognizer:ges];
    }
    
    //model转换为待添加的model格式
    [self assetDetailModelTranslateToMineDetailModel:model];
}

-(void)assetDetailModelTranslateToMineDetailModel:(AssetDetailModel *)model
{
    NSDictionary *statusDict = model.mj_keyValues;
    mineDetailModel  = [AssetMineDetailModel new];
    mineDetailModel = [AssetMineDetailModel mj_objectWithKeyValues:statusDict];
    mineDetailModel.assetId = model.assetId;
}

-(void)createBarItem
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}

#pragma mark - Actions
-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)imageTapAction:(UITapGestureRecognizer *)ges
{
    MJPhoto *photo = [[MJPhoto alloc]init];
    photo.url = [NSURL URLWithString:imageURL];
    NSArray *array = [NSArray arrayWithObject:photo];
    MJPhotoBrowser *brow = [[MJPhotoBrowser alloc]init];
    brow.photos = array;
    [brow show];
    brow.currentPhotoIndex = 0;
}


- (IBAction)addWaitDiliverArrayAction:(id)sender {
    [_dataArray addObject:mineDetailModel];
    AssetDiliverWaitController
    *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    takeView.dataArray = [NSMutableArray arrayWithArray:_dataArray];
    [self.navigationController
     popToViewController:takeView animated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
