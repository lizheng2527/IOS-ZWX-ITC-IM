//
//  qcsMenuTableController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsMenuTableController.h"
#import "UIViewController+CWLateralSlide.h"
#import "qcsMenuTypeOneCell.h"
#import "qcsMenuTypeTwoMenuCell.h"
#import "QCSchoolDefine.h"
#import "QCSStudyAnalyticsModel.h"


@interface qcsMenuTableController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation qcsMenuTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableView];
    
    self.view.backgroundColor = [UIColor clearColor];
}


- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kCWSCREENWIDTH * 0.5, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    _tableView = tableView;
    
//    [tableView registerNib:[UINib nibWithNibName:@"NextTableViewCell" bundle:nil] forCellReuseIdentifier:@"NextCell"];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.tapType) {
        case TapBigData:
            return _bigDataArray.count;
            break;
        case TapClass:
            return  [QCSSourceHandler getStudyAnalyticsArrayClass].count;
            break;
        case TapStudent:
            return [QCSSourceHandler getStudyAnalyticsArrayStudent].count;
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.tapType) {
        case TapBigData:
        {
            static NSString *iden = @"qcsMenuTypeOneCellBigData";
            
            qcsMenuTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if(cell == nil)
            {
                cell = [[NSBundle mainBundle]loadNibNamed:@"qcsMenuTypeOneCell" owner:self options:nil].firstObject;
            }
            if (_bigDataArray.count) {
                QCSStudyAnalyticsItemModel *model = [_bigDataArray objectAtIndex:indexPath.row];
                if ([model.schoolFlag isEqualToString:@"0"]) {
                    cell.iconView.image = [UIImage imageNamed:@"qcxt_icon_leftdrawer_lesson_jt"];
                    cell.titleLabel.text = model.name;
                }
                else
                {
                    cell.iconView.image = [UIImage imageNamed:@"qcxt_icon_leftdrawer_lesson_fx"];
                    cell.titleLabel.text = model.name;
                }
            }
            return cell;
        }
            break;
        case TapClass:
        {
            static NSString *iden = @"qcsMenuTypeOneCellClass";
            
            qcsMenuTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if(cell == nil)
            {
                cell = [[NSBundle mainBundle]loadNibNamed:@"qcsMenuTypeOneCell" owner:self options:nil].firstObject;
            }
            cell.modelClass = [[QCSSourceHandler getStudyAnalyticsArrayClass]objectAtIndex:indexPath.row];
            return cell;
        }
            break;
        case TapStudent:
        {
            static NSString *iden = @"qcsMenuTypeOneCellStudent";
            
            qcsMenuTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if(cell == nil)
            {
                cell = [[NSBundle mainBundle]loadNibNamed:@"qcsMenuTypeOneCell" owner:self options:nil].firstObject;
            }
            cell.modelStudent = [[QCSSourceHandler getStudyAnalyticsArrayStudent]objectAtIndex:indexPath.row];
            return cell;
        }
            break;
            
        default:
        {
            return [UITableViewCell new];
        }
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (self.tapType) {
        case TapBigData:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(menuTableCellSelectedWithIndexpathRowOfBigData:)] ) {
                [self.delegate menuTableCellSelectedWithIndexpathRowOfBigData:indexPath.row];
            }
        }
            break;
        case TapClass:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(menuTableCellSelectedWithIndexpathRowOfClass:)] ) {
                QCSSourceModel *model = [[QCSSourceHandler getStudyAnalyticsArrayClass] objectAtIndex:indexPath.row];
                if ([model.level isEqualToString:@"1"]) {
                    [self.delegate menuTableCellSelectedWithIndexpathRowOfClass:indexPath.row];
                }
                else return;
            }
        }
            break;
        case TapStudent:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(menuTableCellSelectedWithIndexpathRowOfStudent:)] ) {
                [self.delegate menuTableCellSelectedWithIndexpathRowOfStudent:indexPath.row];
            }
        }
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kCWSCREENWIDTH * 0.5, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor QCSThemeColor];
    
    switch (self.tapType) {
        case TapBigData:
        {
            label.text = @"报表分析";
        }
            break;
        case TapClass:
        {
            label.text = @"课堂报表分析";
        }
            break;
        case TapStudent:
        {
            label.text = @"学生报表分析";
        }
            break;
            
        default:
            break;
    }
    
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect rect = self.view.frame;
    
    switch (_drawerType) {
        case DrawerDefaultLeft:
            [self.view.superview sendSubviewToBack:self.view];
            break;
        case DrawerTypeMaskLeft:
            rect.size.width = kCWSCREENWIDTH * 0.5;
            break;
        default:
            break;
    }
    
    self.view.frame = rect;
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
