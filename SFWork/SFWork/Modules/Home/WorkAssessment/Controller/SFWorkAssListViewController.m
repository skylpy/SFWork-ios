//
//  SFWorkAssListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFWorkAssListViewController.h"
#import "SFWorkAssessmentViewController.h"
#import "SFSelectDepEmpViewController.h"
#import "SFWorkAssListCell.h"
#import "SFWorkAssTitleCell.h"

static NSString * const SFWorkAssListCellID = @"SFWorkAssListCellID";
static NSString * const SFWorkAssTitleCellID = @"SFWorkAssTitleCellID";

@interface SFWorkAssListViewController ()<UITableViewDelegate,UITableViewDataSource,SFAllEmployeeViewControllerDelagete>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFWorkAssListViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithObjects:@[@""], nil];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"考核结算";
    [self setDrawUI];
    [self getEmployees];
}

- (void)getEmployees{
    
    [SFOrganizationModel getDirectlyEmployeesSuccess:^(NSArray<SFEmployeesModel *> * _Nonnull list) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:@[@""]];
        [self.dataArray addObject:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 45;
    }
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 30;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        UILabel * title = [UILabel createALabelText:@"直属员工列表" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#666666")];
        title.frame = CGRectMake(15, 0, kWidth-30, 30);
        [headerView addSubview:title];
        return headerView;
    }
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SFWorkAssTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFWorkAssTitleCellID forIndexPath:indexPath];
        
        return cell;
    }
    SFWorkAssListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFWorkAssListCellID forIndexPath:indexPath];
    NSArray * array = self.dataArray[indexPath.section];
    SFEmployeesModel * model = array[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        SFAllEmployeeViewController * vc = [NSClassFromString(@"SFAllEmployeeViewController") new];
        vc.delagete = self;
        vc.type = singleType;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    NSArray * array = self.dataArray[indexPath.section];
    SFEmployeesModel * model = array[indexPath.row];
    SFWorkAssessmentViewController * vc = [[UIStoryboard storyboardWithName:@"WorkAssessment" bundle:nil] instantiateViewControllerWithIdentifier:@"SFWorkAssessment"];
    vc.employeeId = model._id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma SFAllEmployeeViewController
- (void)singleSelectEmoloyee:(SFEmployeesModel *)employee{
    
    SFWorkAssessmentViewController * vc = [[UIStoryboard storyboardWithName:@"WorkAssessment" bundle:nil] instantiateViewControllerWithIdentifier:@"SFWorkAssessment"];
    vc.employeeId = employee._id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFWorkAssListCell" bundle:nil] forCellReuseIdentifier:SFWorkAssListCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFWorkAssTitleCell" bundle:nil] forCellReuseIdentifier:SFWorkAssTitleCellID];
        
    }
    return _tableView;
}

@end
