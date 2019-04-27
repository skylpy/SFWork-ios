//
//  SFPowerListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPowerListViewController.h"
#import "SFPowerHttpModel.h"
#import "SFPowerListCell.h"

static NSString * const SFPowerListCellID = @"SFPowerListCellID";

@interface SFPowerListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic, strong) UIButton * addButton;

@end

@implementation SFPowerListViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.type isEqualToString:@"DEPARTMENT"]?
    @"设置部门管理人员":[self.type isEqualToString:@"FINANCE"]?
    @"设置财务人员":[self.type isEqualToString:@"ADMINISTRATION"]?
    @"设置行政人员":[self.type isEqualToString:@"SUPERADMIN"]?
    @"设置超级管理员":@"设置临时权限";
    
    [self initDrawUI];
   
}

- (void)requestData {
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFPowerHttpModel getMyPowerListsType:self.type success:^(NSArray<SFPowerListModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-32);
        make.width.height.offset(55);
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 74;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFPowerListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPowerListCellID forIndexPath:indexPath];
    SFPowerListModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFPowerListModel * model = self.dataArray[indexPath.section];
    UIViewController * vc = [NSClassFromString(@"SFAddPowerViewController") new];
    [vc setValue:model forKey:@"model"];
    [vc setValue:self.type forKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFPowerListCell" bundle:nil] forCellReuseIdentifier:SFPowerListCellID];
        
        
    }
    return _tableView;
}

- (UIButton *)addButton{
    
    if (!_addButton) {
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"btn_oval_add_green"] forState:UIControlStateNormal];
        
        @weakify(self)
        [[_addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            UIViewController * vc = [NSClassFromString(@"SFAddPowerViewController") new];
            [vc setValue:self.type forKey:@"type"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _addButton;
}

@end
