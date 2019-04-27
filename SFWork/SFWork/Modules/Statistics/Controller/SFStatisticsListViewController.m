//
//  SFStatisticsListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFStatisticsListViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFReportDateilViewController.h"
#import "SFDataReportHttpModel.h"
#import "SFReportListCell.h"
#import "SFSelectEmployCell.h"

static NSString * const SFReportListCellID = @"SFReportListCellID";

@interface SFStatisticsListViewController ()<UITableViewDelegate,UITableViewDataSource,SFSuperSuborViewControllerDelagete>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *empName;

@end

@implementation SFStatisticsListViewController



- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    
    [self requestData];
}

- (void)requestData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@"1" forKey:@"pageNum"];
    [dict setValue:@"20" forKey:@"pageSize"];
    [MBProgressHUD showActivityMessageInView:@""];
    [SFDataReportHttpModel getDirectlyEmployeeReportDataReport:dict success:^(NSArray<SFTemplateModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = bgColor;
    self.empName = @"";
    [self.tableView registerNib:[UINib nibWithNibName:@"SFReportListCell" bundle:nil] forCellReuseIdentifier:SFReportListCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFSelectEmployCell" bundle:nil] forCellReuseIdentifier:@"SFSelectEmployCellID"];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 45;
    }
    return 221;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SFSelectEmployCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFSelectEmployCellID" forIndexPath:indexPath];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.name = self.empName;
        return cell;
    }
    SFReportListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFReportListCellID forIndexPath:indexPath];
    
    SFTemplateModel * model = self.dataArray[indexPath.section-1];
    cell.model = model;
    @weakify(self)
    [cell setSelectEmpClick:^(SFTemplateModel * _Nonnull item) {
        @strongify(self)
        [self checkThisEmp:item.employeeId];
    }];
    return cell;
}

- (void)checkThisEmp:(NSString *)empId{
    

    ModelComfirm *item1 = [ModelComfirm comfirmModelWith:@"查看该员工的所有日志" titleColor:Color(@"#0B0B0B") fontSize:16];
    ModelComfirm *item2 = [ModelComfirm comfirmModelWith:@"删除" titleColor:Color(@"#0B0B0B") fontSize:16];

    ModelComfirm *cancelItem = [ModelComfirm comfirmModelWith:@"取消" titleColor:Color(@"#0B0B0B") fontSize:16];
    [ComfirmView showInView:LSKeyWindow cancelItemWith:cancelItem dataSource:@[ item1 ,item2] actionBlock:^(ComfirmView *view, NSInteger index) {
        
        if (index == 0) {
            [self getEmployeeList:empId];
        }else{
            
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
        vc.delagete = self;
        vc.type = singleType;
        vc.isSubor = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        SFTemplateModel * model = self.dataArray[indexPath.section-1];
        SFReportDateilViewController * vc = [SFReportDateilViewController new];
        vc.model = model;
        @weakify(self)
        [vc setBackLastPage:^{
            @strongify(self)
            !self.backClick?:self.backClick();
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    self.empName = employee.name;
    [self.tableView reloadData];
    [self getEmployeeList:employee._id];
}

- (void)getEmployeeList:(NSString *)employeeId{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:employeeId forKey:@"employeeId"];
    [dict setValue:@"1" forKey:@"pageNum"];
    [dict setValue:@"20" forKey:@"pageSize"];
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    
    [SFDataReportHttpModel findByEmployeeDataReport:dict success:^(NSArray<SFTemplateModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

@end
