//
//  SFPowerMgrViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPowerMgrViewController.h"
#import "SFPowerMgrCell.h"
#import "SFPowerModel.h"

static NSString * const SFPowerMgrCellID = @"SFPowerMgrCellID";

@interface SFPowerMgrViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * titleArray;
@property (nonatomic,strong) UIView * headerView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SFPowerMgrViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithObjects:
                       @"超级管理可以设置部门管理员并分配对应的权限",
                       @"超级管理可以设置财务人员并分配对应的权限",
                       @"超级管理可以设置行政人员并分配对应的权限",
                       @"更换超级管理员权限，更换之后将不会再有权限",
                       @"可以设置让员工拥有临时权限，临时权限到期自动取消", nil];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"权限管理";
    [self initDrawUI];
    [self initData];
}


- (void)initData{
    
    NSArray * array = [SFPowerModel sharePowerModel];
    
    [self.dataArray addObjectsFromArray:array];
    
    [self.tableView reloadData];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kWidth-30, 30)];
    _titleLabel.font = [UIFont fontWithName:kRegFont size:12];
    _titleLabel.textColor = Color(@"#999999");
    [_headerView addSubview:_titleLabel];
    self.titleLabel.text = self.titleArray[section];
    return self.headerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFPowerMgrCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPowerMgrCellID forIndexPath:indexPath];
    SFPowerModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFPowerModel * model = self.dataArray[indexPath.section];
    UIViewController * vc = [NSClassFromString(@"SFPowerListViewController") new];
    [vc setValue:model.type forKey:@"type"];
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFPowerMgrCell" bundle:nil] forCellReuseIdentifier:SFPowerMgrCellID];
        
        
    }
    return _tableView;
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
