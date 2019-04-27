
//
//  SFBillSearchResultViewController.m
//  SFWork
//
//  Created by fox on 2019/4/23.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFBillSearchResultViewController.h"
#import "SFShowAnsEditIncomeViewController.h"
#import "SFIncomeHeadView.h"
#import "SFIncomeTableViewCell.h"
#import "FromDateSelectDatePick.h"
#import "SFBillHomeModel.h"

@interface SFBillSearchResultViewController ()

@end

@implementation SFBillSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFIncomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFIncomeTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mj_headerLoading)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mj_footLoading)];
    [self requestData];
}

- (void)mj_headerLoading{
    self.pageNum = 1;
    [self requestData];
}

- (void)mj_footLoading{
    self.pageNum ++;
    [self requestData];
}

- (void)requestData{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[self.titleStr isEqualToString:@"收入"]?@[@"DEBIT"]:@[@"CREDIT"] forKey:@"dcFlags"];
    [params setObject:@(self.pageNum) forKey:@"pageNum"];
    [params setObject:@(self.pageSize) forKey:@"pageSize"];
    if (_startDateStr) {
        [params setObject:_startDateStr forKey:@"startDate"];
        [params setObject:_endDateStr forKey:@"endDate"];
    }
    [SFBaseModel BPOST:BASE_URL(@"/finace/bill/sum/search/group") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (self.pageNum == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[SFBillHomeModel class] json:model.result[@"list"]]];
        [self.tableView reloadData];
        NSLog(@"%@",self.dataArray);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SFShowAnsEditIncomeViewController * svc = [SFShowAnsEditIncomeViewController new];
    svc.title = @"支出（贷方）详情";
    SFBillHomeModel * listModel = self.dataArray[indexPath.section];
    SFBillListModel * model = listModel.billSumList[indexPath.row];
    svc.showModel = model.billInfo;
    [self.navigationController pushViewController:svc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SFBillHomeModel * model = self.dataArray[section];
    return model.billSumList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFIncomeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLB.text = [NSString stringWithFormat:@"%@:",self.titleStr];
    SFBillHomeModel * listModel = self.dataArray[indexPath.section];
    SFBillListModel * model = listModel.billSumList[indexPath.row];
    cell.model = model;
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
    SFBillHomeModel * model = self.dataArray[section];
    headView.timeLB.text = [SFCommon getNULLString:model.groupDateStr];
    return headView;
}

@end
