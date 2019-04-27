//
//  SFSelectPersonViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/23.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectPersonViewController.h"
#import "SFOrganizationModel.h"
#import "SFVisitHttpModel.h"
#import "SFEmployeeCell.h"

static NSString * const SFEmployeeCellID = @"SFEmployeeCellID";

@interface SFSelectPersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFSelectPersonViewController


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"员工列表";
    [self initDrawUI];
    [self getEmployees];
}


- (void)getEmployees{
    
    [SFOrganizationModel getDirectlyEmployeesSuccess:^(NSArray<SFEmployeesModel *> * _Nonnull list) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFEmployeeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFEmployeeCellID forIndexPath:indexPath];
    SFEmployeesModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.type = self.type;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFEmployeesModel * model = self.dataArray[indexPath.row];
    [self dealWealData:model];
    
}

- (void)dealWealData:(SFEmployeesModel *)model{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:model._id forKey:@"visitorid"];
    NSLog(@"%@",dict);
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFVisitHttpModel clientVisitList:dict success:^(NSArray<SFVisitListModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        UIViewController * vc = [NSClassFromString(@"SFSeachListViewController") new];
        [vc setValue:list forKey:@"data"];
        [vc setValue:model.name forKey:@"name"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
    
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFEmployeeCell" bundle:nil] forCellReuseIdentifier:SFEmployeeCellID];
    }
    return _tableView;
}


@end
