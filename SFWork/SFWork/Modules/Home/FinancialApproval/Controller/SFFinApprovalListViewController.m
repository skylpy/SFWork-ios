//
//  SFFinApprovalListViewController.m
//  SFWork
//
//  Created by fox on 2019/4/25.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFFinApprovalListViewController.h"
#import "SFFinancialApprovalingViewController.h"
#import "SFIncomeHeadView.h"
#import "SFIncomeTableViewCell.h"

@interface SFFinApprovalListViewController ()

@end

@implementation SFFinApprovalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)initUI{
    self.title = @"公司财务审批列表";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFIncomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFIncomeTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mj_headerLoading)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mj_footLoading)];
    //    [self requestData];
}

- (void)rightBtnAction:(UIButton *)sender{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SFFinancialApprovalingViewController * svc = [SFFinancialApprovalingViewController new];
    //    svc.title = [self.title isEqualToString:@"支出"]?@"支出（贷方）详情":@"收入（借方）详情";
    //    SFBillHomeModel * listModel = self.dataArray[indexPath.section];
    //    SFBillListModel * model = listModel.billSumList[indexPath.row];
    //    svc.showModel = model.billInfo;
    [self.navigationController pushViewController:svc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    SFBillHomeModel * model = self.dataArray[section];
    //    return model.billSumList.count;
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFIncomeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.titleLB.text = [NSString stringWithFormat:@"%@:",self.title];
    //    SFBillHomeModel * listModel = self.dataArray[indexPath.section];
    //    SFBillListModel * model = listModel.billSumList[indexPath.row];
    //    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SFIncomeHeadView * headView = [[[NSBundle mainBundle]loadNibNamed:@"SFIncomeHeadView" owner:nil options:nil] firstObject];
    //    SFBillHomeModel * model = self.dataArray[section];
    //    headView.timeLB.text = [SFCommon getNULLString:model.groupDateStr];
    return headView;
}
@end
