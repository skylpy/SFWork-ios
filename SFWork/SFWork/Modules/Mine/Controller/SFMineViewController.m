//
//  SFMineViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMineViewController.h"
#import "SFLoginViewController.h"
#import "SFMineTableCell.h"
#import "SFMineHeaderView.h"
#import "SFMineModel.h"
#import "SFRegisterModel.h"
#import "AppDelegate.h"

static NSString * const SFMineTableCellID = @"SFMineTableCellID";

@interface SFMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)UIButton * logoutButton;
@property (nonatomic,strong)SFMineHeaderView * headerView;

@end

@implementation SFMineViewController

- (SFMineHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [SFMineHeaderView shareSFMineHeaderView];
        @weakify(self)
        [_headerView setEnterPayClick:^{
            @strongify(self)
            UIViewController * vc = [NSClassFromString(@"SFBusinessPlanViewController") new];
            [self.navigationController pushViewController:vc animated:YES];
                
        }];
    }
    return _headerView;
    
}
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIButton *)logoutButton{
    
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.frame = CGRectMake(0, 0, kWidth, 45);
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:Color(@"#FF715A") forState:UIControlStateNormal];
        _logoutButton.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        _logoutButton.backgroundColor = [UIColor whiteColor];
        
    }
    return _logoutButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    [self initDrawUI];
    [self initData];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:updateSelfInfoDataNotificationSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self updateSelfData];
    }];
}

- (void)updateSelfData{
    
    [SFRegHttpModel getSelfInfoSuccess:^{
        
        self.headerView.userInfo = [SFInstance shareInstance].userInfo;
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)initData{
    
    NSArray * array = [SFMineModel shareMineModel];
    
    [self.dataArray addObjectsFromArray:array];
    
    [self.tableView reloadData];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    [[self.logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        [UIAlertController alertTitle:@"温情提示" mesasge:@"确定退出登录！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
            [[SFInstance shareInstance] logout];
            [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotificationSuccess object:nil];
        } viewController:self];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 169;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFMineTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFMineTableCellID forIndexPath:indexPath];
    SFMineModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFMineModel * model = self.dataArray[indexPath.row];
    if (![model.controller isEqualToString:@""]) {
        
        UIViewController * vc = [NSClassFromString(model.controller) new];
        if ([model.title isEqualToString:@"个人信息"]) {
            [vc setValue:(SFEmployeesModel *)[SFInstance shareInstance].userInfo forKey:@"employees"];
        }
        [self.navigationController pushViewController:vc animated:YES];
        
        
        NSLog(@"%@ %@",[SFInstance shareInstance].userInfo.name,[SFInstance shareInstance].companyInfo.name);
    }
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFMineTableCell" bundle:nil] forCellReuseIdentifier:SFMineTableCellID];
        
        
        _tableView.tableFooterView = self.logoutButton;
    }
    return _tableView;
}


@end
