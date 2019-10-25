//
//  NTESWorkflowViewController.m
//  NIM
//
//  Created by 中电和讯 on 2019/10/23.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "NTESWorkflowTitleViewController.h"
#import "NTESWorkflowViewController.h"
#import "DropDownMenu.h"
#import "UIView+Extention.h"
#import "NTESNetWorkflowViewController.h"

@interface NTESWorkflowViewController ()<UIWebViewDelegate,DropDownMenuDelegate,TitleMenuDelegate2>
@property(nonatomic,retain)MBProgressHUD *hud;
@property(nonatomic,copy)UIButton *backBtn;
@property (nonatomic, strong) DropDownMenu * drop;
@property (nonatomic, strong) NSMutableArray * datas;
@end

@implementation NTESWorkflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    
}

-(void) initData{
    NTESNetWorkflowViewController *net = [[NTESNetWorkflowViewController alloc] init];
    [net getApplicationUrlJson:_code andStatus:^(BOOL success, NSMutableArray * arr) {
        if([arr count] > 0){
            _datas = arr;
            [self creatTitleView:0];
            [self initWebview:0];
        }else{
            [self.view makeToast:@"数据错误" duration:1 position:nil];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    }
#pragma mark   -------  定义titleView下拉菜单
- (void)creatTitleView:(NSInteger *) position {
    _titleButton = [[TitleButton alloc] init];
     _titleButton.titleTypeByV3App = @"notice";
    NTESWorkflowModel *model = [_datas objectAtIndex:position];
    NSString * name = self.aNewTitle?self.aNewTitle:model.name;
    [_titleButton setTitle:name forState:UIControlStateNormal];
    // 监听标题点击
    [_titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleButton;
    
    
}

#pragma mark   ======  titleView的菜单设置
- (void)titleClick:(UIButton *)btn{
    
    // 创建下拉菜单
    DropDownMenu *drop = [[DropDownMenu alloc] init];
    self.drop = drop;
    // 设置下拉菜单弹出、销毁事件的监听者
    drop.delegate = self;

    // 2.设置要显示的内容
    NTESWorkflowTitleViewController *titleMenuVC = [[NTESWorkflowTitleViewController alloc] init];
    titleMenuVC.tempdata = [[NSMutableArray alloc ] init];
//    [titleMenuVC.tempdata removeAllObjects];
    for (int i = 0; i < _datas.count; i++)
    {
        NTESWorkflowModel *model = [_datas objectAtIndex:i];
        [titleMenuVC.tempdata insertObject:model.name atIndex:i];
    }
    titleMenuVC.drop = drop;
    titleMenuVC.delegate = self;
    titleMenuVC.view.height = 44*4;
    titleMenuVC.view.width = self.view.frame.size.width;
    titleMenuVC.index = _index;
    drop.contentController = titleMenuVC;
//    // 显示
    [drop showFrom:btn];
}

-(void)initWebview:(NSInteger *) position
{
    
    NTESWorkflowModel *model = [_datas objectAtIndex:position];
    _mainWebView.delegate = self;
    NSString *sys_token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_SYS_TOKEN];
    
    NSString *url = [NSString stringWithFormat:@"%@&sys_token=%@",model.url,sys_token ];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_mainWebView loadRequest:request];
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelFont = [UIFont systemFontOfSize:12];
    _hud.labelText = @"正在加载网页";
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_hud removeFromSuperview];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TitleMenuDelegate2
-(void)selectAtIndexPath:(NSIndexPath *)indexPath title:(NSString *)title
{
    //    NSLog(@"indexPath = %ld", (long)indexPath.row);
    //    NSLog(@"当前选择了%@", title);
    self.aNewTitle = title;
    
    _index = indexPath.row;
    [self creatTitleView:indexPath.row];
    [self initWebview:indexPath.row];
}

- (void)dropdownMenuDidDismiss:(DropDownMenu *)menu
{
    TitleButton *titleButton = (TitleButton *)self.navigationItem.titleView;
    // 让箭头向下
    titleButton.selected = NO;
}

//下拉菜单显示了
- (void)dropdownMenuDidShow:(DropDownMenu *)menu
{
    TitleButton *titleButton = (TitleButton *)self.navigationItem.titleView;
    // 让箭头向上
    titleButton.selected = YES;
}

@end
