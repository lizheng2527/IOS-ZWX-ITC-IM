//
//  qcsClassDetailInsideController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassDetailInsideController.h"
#import "QCSchoolDefine.h"

#import "qcsClassDetailInsideSXBJCell.h"
#import "qcsClassDetailInsideXZTCell.h"
#import "qcsClassDetailInsideJXKJCell.h"
#import "qcsClassDetailInsideXZTStudentCell.h"


#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "QCSNetHelper.h"
#import "QCSClassDetailModel.h"

#import "qcsClassDetailInsideSXBJDetailController.h"
#import "qcsClassDetailInsideXZTDetailController.h"
#import "TYHHttpTool.h"


@interface qcsClassDetailInsideController()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,qcsClassDetailInsideXZTCellDelegate,UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UICollectionView * collectionView;
@property(nonatomic,retain)NSMutableArray *itemArray;

@property(nonatomic,retain)NSMutableArray *SXBJDataSource;
@property(nonatomic,retain)NSMutableArray *BSJLDataSource;
@property(nonatomic,retain)NSMutableArray *XZTDataSource;
@property(nonatomic,retain)NSMutableArray *JXKJDataSource;

@end

@implementation qcsClassDetailInsideController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpCollectionView];
    
    [self getNewData];
}



#pragma mark - initData
- (void)getNewData {
    
    
    _SXBJDataSource = [NSMutableArray array];
    _BSJLDataSource = [NSMutableArray array];
    _XZTDataSource = [NSMutableArray array];
    _JXKJDataSource = [NSMutableArray array];
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
    
    switch (self.viewTag) {
        case 1001:
        {
            [SVProgressHUD showWithStatus:@"获取数据中"];
            [helper getClassDetailSXBJListWithID:self.wisdomclassId Type:@"sxbj" andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                
                _SXBJDataSource = dataSource;
                [SVProgressHUD dismiss];
                [_collectionView reloadData];
                
            } failure:^(NSError *error) {
                [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
                [SVProgressHUD dismiss];
                
            }];
            
        }
            break;
        case 1002:
        {
            [SVProgressHUD showWithStatus:@"获取数据中"];
            
            if ([self.userType isEqualToString:@"teacher"]) {
                [helper getClassDetailBSJLListWithID:self.wisdomclassId Type:@"bsjl" andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                    _BSJLDataSource = dataSource;
                    
                    [SVProgressHUD dismiss];
                    [_collectionView reloadData];
                    
                } failure:^(NSError *error) {
                    [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
                    [SVProgressHUD dismiss];
                    
                }];
            }else
            {
                [helper getClassDetailBSJLListWithID:self.wisdomclassId Type:@"bsbj" andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                    _BSJLDataSource = dataSource;
                    
                    [SVProgressHUD dismiss];
                    [_collectionView reloadData];
                    
                } failure:^(NSError *error) {
                    [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
                    [SVProgressHUD dismiss];
                    
                }];
            }
            
            
        }
            break;
        case 1003:
        {
            [SVProgressHUD showWithStatus:@"获取数据中"];
            [helper getClassDetailXZTListWithID:self.wisdomclassId Type:@"xzt" andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                _XZTDataSource = dataSource;
                
                [SVProgressHUD dismiss];
                [_collectionView reloadData];
                
            } failure:^(NSError *error) {
                [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
                [SVProgressHUD dismiss];
                
            }];
            
        }
            break;
        case 1004:
        {
            [SVProgressHUD showWithStatus:@"获取数据中"];
            [helper getClassDetailJXKJListWithID:self.wisdomclassId Type:@"jxkj" andStatus:^(BOOL successful, NSMutableArray *dataSource) {
                _JXKJDataSource = dataSource;
                
                [SVProgressHUD dismiss];
                [_collectionView reloadData];
                
            } failure:^(NSError *error) {
                [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
                [SVProgressHUD dismiss];
                
            }];
            
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark - initView

- (void)setUpCollectionView {
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 2 - 20, 120);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 5; //调节Cell间距
    flowLayout.sectionInset = UIEdgeInsetsMake(7,7,7,7);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, SCREEN_HEIGHT - AdjustHeight - 50 - 8) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor QCSBackgroundColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:@"qcsClassDetailInsideSXBJCell" bundle:nil] forCellWithReuseIdentifier:@"qcsClassDetailInsideSXBJCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"qcsClassDetailInsideXZTCell" bundle:nil] forCellWithReuseIdentifier:@"qcsClassDetailInsideXZTCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"qcsClassDetailInsideJXKJCell" bundle:nil] forCellWithReuseIdentifier:@"qcsClassDetailInsideJXKJCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"qcsClassDetailInsideXZTStudentCell" bundle:nil] forCellWithReuseIdentifier:@"qcsClassDetailInsideXZTStudentCell"];
    
    
    // 注册headView
    self.collectionView = collectionView;
    _collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
    [self.view addSubview:collectionView];
    
}

-(void)shouldCreateNoData:(NSMutableArray *)array
{
    UILabel *noDatalabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2 - 80, [UIScreen mainScreen].bounds.size.width, 40)];
    noDatalabel.text = @"暂无数据";
    CGPoint centerPoint = CGPointMake(self.collectionView.center.x, self.collectionView.center.y - 68);
    noDatalabel.center = centerPoint;
    noDatalabel.textColor = [UIColor grayColor];
    noDatalabel.textAlignment = NSTextAlignmentCenter;
    noDatalabel.font = [UIFont boldSystemFontOfSize:17];
    if (!noDatalabel.superview && !array.count) {
        [self.view addSubview:noDatalabel];
    }
    else [noDatalabel removeFromSuperview];
}



#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (self.viewTag) {
        case 1001:
            if (self.studentSXBJDatasource.count) {
                return _studentSXBJDatasource.count;
            }else
            return _SXBJDataSource.count;
            break;
        case 1002:
            return  _BSJLDataSource.count;
            break;
        case 1003:
            return _XZTDataSource.count;
            break;
        case 1004:
            return _JXKJDataSource.count;
            break;
        default: return 0;
            break;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.viewTag) {
        case 1001:
        {
            qcsClassDetailInsideSXBJCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qcsClassDetailInsideSXBJCell" forIndexPath:indexPath];
            if (![self.userType isEqualToString:@"student"]) {
                if (_SXBJDataSource.count) {
                    cell.sxbjModel = _SXBJDataSource[indexPath.row];
                }
            }
            else
            {
                if (self.studentSXBJDatasource.count) {
                    cell.studentModel = _studentSXBJDatasource[indexPath.row];
                }
            }
            
            
            return cell;
        }
            break;
        case 1002:
        {
            qcsClassDetailInsideSXBJCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qcsClassDetailInsideSXBJCell" forIndexPath:indexPath];
            if (_BSJLDataSource.count) {
                cell.bsjlModel = _BSJLDataSource[indexPath.row];
            }
            return cell;
        }
            break;
        case 1003:
        {
            
            if ([self.userType isEqualToString:@"teacher"]) {
                qcsClassDetailInsideXZTCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qcsClassDetailInsideXZTCell" forIndexPath:indexPath];
                cell.delegate = self;
                if (_XZTDataSource.count) {
                    cell.model = _XZTDataSource[indexPath.row];
                }
                return cell;
            }
            else
            {
                qcsClassDetailInsideXZTStudentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qcsClassDetailInsideXZTStudentCell" forIndexPath:indexPath];
                if (self.studentXZTDatasource.count) {
                    cell.model = _studentXZTDatasource[indexPath.row];
                }
                return cell;
            }
            
            
            
        }
            break;
        case 1004:
        {
            qcsClassDetailInsideJXKJCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qcsClassDetailInsideJXKJCell" forIndexPath:indexPath];
            if (_JXKJDataSource.count) {
                cell.model = _JXKJDataSource[indexPath.row];
            }
            return cell;
        }
            break;
        default: return [UICollectionViewCell new];
            break;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.viewTag) {
        case 1001:
        {
            
            if ([self.userType isEqualToString:@"teacher"]) {
                QCSClassDetailSXBJModel *model = _SXBJDataSource[indexPath.row];
                qcsClassDetailInsideSXBJDetailController *dView = [qcsClassDetailInsideSXBJDetailController new];
                dView.inID = model.id;
                [self.navigationController pushViewController:dView animated:YES];
            }
            else
            {
                QCSClassDetailSXBJModel *model = _studentSXBJDatasource[indexPath.row];
                MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
                NSMutableArray *photos = [NSMutableArray array];
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],model.picUrl]];
                
                [photos addObject:photo];
                brower.photos = photos;
                brower.currentPhotoIndex = 0;
                [brower show];
            }
        }
            break;
        case 1002:
        {
            QCSClassDetailBSJLModel *model = _BSJLDataSource[indexPath.row];
            
            MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
            NSMutableArray *photos = [NSMutableArray array];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],model.downloadUrl]] ;
            [photos addObject:photo];
            brower.photos = photos;
            brower.currentPhotoIndex = 0;
            [brower show];
        }
            break;
        case 1003:
        {
            if ([self.userType isEqualToString:@"student"]) {
                QCSMainStudentXZTJModel *model = _studentXZTDatasource[indexPath.row];
                MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
                NSMutableArray *photos = [NSMutableArray array];
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],model.downloadUrl]] ;
                [photos addObject:photo];
                brower.photos = photos;
                brower.currentPhotoIndex = 0;
                [brower show];
            }
        }
            break;
        case 1004:
        {
        
            QCSClassDetailJXKJModel *model = _JXKJDataSource[indexPath.row];
            
            qcsClassDetailInsideJXKJCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",model.size,model.name]];
            
            if (![fileManager fileExistsAtPath:paths])
            {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认下载该文件吗" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",model.size,model.name]];
                    
                    NSString *downloadURL = [NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],model.downloadUrl];
                    
                    TYHHttpTool *downloadHelper = [[TYHHttpTool alloc]init];
                    [downloadHelper downloadInferface:downloadURL downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        NSData * data = (NSData *)responseObject;
                        [data writeToFile:paths atomically:YES];
                        
                    } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self.view makeToast:@"下载失败" duration:1.5 position:CSToastPositionCenter];
                    } progress:^(float progress) {
                        
                       cell.processView.hidden = NO;
                    cell.processView.progress = progress;
                        if (progress == 1) {
                            [cell.processView setHidden:YES];
                        }
                    }];
                    
                }];
                UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alertController addAction:noAction];
                [alertController addAction:yesAction];
                
                [self presentViewController:alertController animated:yesAction completion:nil];
            }
            else
            {
                UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: [NSURL fileURLWithPath:paths]];
                
                interactionController.delegate = self;
                [interactionController presentPreviewAnimated:YES];
                CGRect navRect =self.navigationController.navigationBar.frame;
                navRect.size =CGSizeMake(1500.0f,40.0f);
                //显示包含预览的菜单项
                [interactionController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
//                UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: path];
//
//                interactionController.delegate = self;
//                [interactionController presentPreviewAnimated:YES];
//                CGRect navRect =self.navigationController.navigationBar.frame;
//                navRect.size =CGSizeMake(1500.0f,40.0f);
//                //显示包含预览的菜单项
//                [interactionController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - CollectionView Layout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.viewTag) {
        case 1001:
        {
            CGSize itemSize = CGSizeMake(SCREEN_WIDTH / 3 - 20, 140);
            return itemSize;
        }
            break;
        case 1002:
        {
            CGSize itemSize = CGSizeMake(SCREEN_WIDTH / 3 - 20, 140);
            return itemSize;
        }
            break;
        case 1003:
        {
            CGSize itemSize = CGSizeMake(SCREEN_WIDTH - 20, 140);
            return itemSize;
        }
            break;
        case 1004:
        {
            CGSize itemSize = CGSizeMake(SCREEN_WIDTH - 20, 84);
            return itemSize;
        }
            break;
        default: return CGSizeMake(0, 0);
            break;
    }
    
    
}

#pragma mark - qcsClassDetailInsideXZTCellDelegate
-(void)ImageViewClicked:(qcsClassDetailInsideXZTCell *)cell
{
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray array];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],cell.model.urls]] ;
    [photos addObject:photo];
    brower.photos = photos;
    brower.currentPhotoIndex = 0;
    [brower show];
}

-(void)DetailBtnClicked:(qcsClassDetailInsideXZTCell *)cell
{
    
    qcsClassDetailInsideXZTDetailController *dView = [qcsClassDetailInsideXZTDetailController new];
    dView.dataSource = [NSMutableArray arrayWithArray:cell.model.optionListModelArray];
    [self.navigationController pushViewController:dView animated:YES];
}


- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}


#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor QCSThemeColor]];
    
    //    [self getNewData];
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor QCSThemeColor]];
    [SVProgressHUD dismiss];
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
