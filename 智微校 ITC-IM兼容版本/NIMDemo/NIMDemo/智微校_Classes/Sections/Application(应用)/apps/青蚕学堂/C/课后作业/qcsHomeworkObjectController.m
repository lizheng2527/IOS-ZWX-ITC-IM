//
//  qcsHomeworkObjectController.m
//  NIM
//
//  Created by 中电和讯 on 2018/5/15.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsHomeworkObjectController.h"

#import "GYZCustomCalendarPickerView.h"
#import "QCSchoolDefine.h"

#import "ValuePickerView.h"
#import "QCSMainModel.h"
#import "NSString+NTES.h"
#import "QCSNetHelper.h"

#import "qcsHomeworkSelectCell.h"
#import "qcsHomeworkReleaseController.h"

@interface qcsHomeworkObjectController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSString *chooseGradeID;
@property(nonatomic,copy)NSString *chooseClassID;
@property(nonatomic,copy)NSString *chooseCourseID;

@property(nonatomic,retain)ValuePickerView *pickerView;

@property(nonatomic,retain)NSMutableArray *itemArray;

@property(nonatomic,retain)NSMutableArray *subjectArray;

@end

@implementation qcsHomeworkObjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initPickview];
    [self tableViewConfig];
    [self createBarItem];
    self.title = @"选择对象";
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)initPickview
{
    _pickerView = [[ValuePickerView alloc]init];
    self.pickerView.pickerTitle = @"选择项";
    self.pickerView.appType = @"青蚕学堂";
    
    if (self.studentCourseArray.count) {
        QCSMainResultGradeModel *model = self.studentCourseArray[0];
        self.chooseGradeID = model.id;
        [self.chooseGradeButton setTitle:model.name forState:UIControlStateNormal];
        [self getSubjectListWithId:self.chooseGradeID];
        
        if (model.childrenEclassModelArray.count) {
            [self getItemArrayAfterDeal:model.childrenEclassModelArray];
        }
    }
}


#pragma mark - ButtonClicked
- (IBAction)chooseGradeAction:(id)sender {
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (QCSMainResultGradeModel *model in self.studentCourseArray) {
        [array addObject:model.name];
    }
    self.pickerView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        
        if (weakSelf.studentCourseArray.count) {
            QCSMainResultGradeModel *model = weakSelf.studentCourseArray[index];
            weakSelf.chooseGradeID = model.id;
            
            if (model.childrenEclassModelArray.count) {
                [weakSelf getItemArrayAfterDeal:model.childrenEclassModelArray];
            }
        }
        [weakSelf.chooseGradeButton setTitle:stateArr[0] forState:UIControlStateNormal];
        
    };
    [self.pickerView show];
}



- (IBAction)chooseCourseAction:(id)sender {
    
    NSMutableArray *array = [NSMutableArray array];
    for (QCSMainUserModel *model in self.subjectArray) {
        [array addObject:model.name];
    }
    self.pickerView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        
        [weakSelf.chooseCourseButton setTitle:stateArr[0] forState:UIControlStateNormal];
        
        weakSelf.chooseCourseID = [weakSelf.itemArray[index] id];
        
    };
    
    [self.pickerView show];
    
}







#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden1 = @"qcsHomeworkSelectCell";
    
    qcsHomeworkSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"qcsHomeworkSelectCell" owner:self options:nil].firstObject;
    }
    
    if (_itemArray.count) {
        QCSMainChildrenEclassModel *model = _itemArray[indexPath.row];
        cell.titleLabel.text = model.name;
        cell.icon.image = [UIImage imageNamed:model.Selected?@"select_account_list_checked":@"select_account_list_unchecked"];
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    QCSMainChildrenEclassModel *model = _itemArray[indexPath.row];

    if ([model.name isEqualToString:@"全选"]) {
        model.Selected = !model.Selected;
        [_itemArray enumerateObjectsUsingBlock:^(QCSMainChildrenEclassModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >=1) {
                obj.Selected = model.Selected;
            }
            if (indexPath.row == idx) {
                [_mainTableView reloadData];
            }
        }];
    }else
    {
        model.Selected = !model.Selected;
        
        
        __block BOOL isSelectAll = NO;
        [_itemArray enumerateObjectsUsingBlock:^(QCSMainChildrenEclassModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >=1) {
                if (obj.Selected == YES) {
                    isSelectAll = YES;
                }else
                {
                    isSelectAll = NO;
                    *stop = YES;
                }
            }
        }];
        if (_itemArray.count) {
            QCSMainChildrenEclassModel *model = _itemArray[0];
            model.Selected = isSelectAll;
            [_mainTableView reloadData];
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    QCSMainChildrenEclassModel *model = _itemArray[indexPath.row];

    
    //    for (WHGoodsDetailModel *modelInArray in _tmpDataArray) {
    //        if ([modelInArray.goodsInfoName isEqualToString:model.name]) {
    //            [_tmpDataArray removeObject:modelInArray];
    //        }
    //    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}


#pragma mark - Submit

-(void)diliverAction:(id)sender
{
    
    
    __block NSMutableString *string = [NSMutableString string];
    [_itemArray enumerateObjectsUsingBlock:^(QCSMainChildrenEclassModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= 1) {
            if (obj.Selected) {
                [string appendFormat:@"%@,",obj.id];
            }
        }
    }];
    
    if (string.length) {
        self.chooseClassID = [NSString removeLastOneChar:[NSString stringWithFormat:@"%@",string]];
    }
    else
    {
        [self.view makeToast:@"请选择班级" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[qcsHomeworkReleaseController class]]) {
            
            qcsHomeworkReleaseController *tempController = (qcsHomeworkReleaseController *)controller;
            
            tempController.chooseGradeID = self.chooseGradeID;
            tempController.chooseCourseID = self.chooseCourseID;
            tempController.chooseClassID = self.chooseClassID;

            [self.navigationController popToViewController:tempController animated:YES];
        }
    }
    
}


#pragma mark - ViewConfig
-(void)tableViewConfig
{
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.bounces = NO;
    _mainTableView.rowHeight = 44.f;
}




-(void)createBarItem
{
    UIBarButtonItem *
    barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    //设置字体为加粗的12号系统字，自己也可以随便设置。
    [barItemInNavigationBarAppearanceProxy
     setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont
                                                           boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem * rightItem = nil;
    
    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self
                                               action:@selector(diliverAction:)];
    self.navigationItem.rightBarButtonItem =rightItem;
}


#pragma mark - Private
-(void)getSubjectListWithId:(NSString *)id
{
    QCSNetHelper *helper = [QCSNetHelper new];
    [helper getSubjectModelArrayWithGradeId:self.chooseGradeID status:^(NSMutableArray *dataSource) {
        _subjectArray = [NSMutableArray arrayWithArray:dataSource];
        if(dataSource.count)
        {
            [self.chooseCourseButton setTitle:[dataSource[0]name] forState:UIControlStateNormal];
            self.chooseCourseID = [dataSource[0]id];
        }
    }];
}

-(void)getItemArrayAfterDeal:(NSMutableArray *)array
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    QCSMainChildrenEclassModel *model = [QCSMainChildrenEclassModel new];
    model.name = @"全选";
    model.Selected = NO;
    [tempArray insertObject:model atIndex:0];
    [tempArray enumerateObjectsUsingBlock:^(QCSMainChildrenEclassModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.Selected = NO;
    }];
    _itemArray = [NSMutableArray arrayWithArray:tempArray];
    [_mainTableView reloadData];
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
