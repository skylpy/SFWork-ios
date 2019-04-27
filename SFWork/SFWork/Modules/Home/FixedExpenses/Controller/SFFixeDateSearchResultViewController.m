//
//  SFFixeDateSearchResultViewController.m
//  SFWork
//
//  Created by fox on 2019/4/26.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFFixeDateSearchResultViewController.h"
#import "SFFixeDetailViewController.h"
#import "SFIncomeHeadView.h"
#import "SFIncomeTableViewCell.h"
#import "FromDateSelectDatePick.h"
#import "SFBillHomeModel.h"

@interface SFFixeDateSearchResultViewController ()

@end

@implementation SFFixeDateSearchResultViewController

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
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:_reuestDic];
    [params setObject:@(self.pageNum) forKey:@"pageNum"];
    [params setObject:@(self.pageSize) forKey:@"pageSize"];
    if (_startDateStr) {
        [params setObject:_startDateStr forKey:@"startDate"];
        [params setObject:_endDateStr forKey:@"endDate"];
    }
    [SFBaseModel BPOST:BASE_URL(@"/finace/bill/billList/group") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
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
    SFFixeDetailViewController * finaDetailVC = [SFFixeDetailViewController new];
    finaDetailVC.title = @"收入（借方）详情";
    [self.navigationController pushViewController:finaDetailVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SFBillHomeModel * model = self.dataArray[section];
    return model.billList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFIncomeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLB.text = [NSString stringWithFormat:@"%@:",_titleStr];
    SFBillHomeModel * model = self.dataArray[indexPath.section];
    SFBillListModel * detailModel = model.billList[indexPath.row];
    cell.model = detailModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SFIncomeHeadView * headView = [[[NSBundle mainBundle]loadNibNamed:@"SFIncomeHeadView" owner:nil options:nil]firstObject];
    headView.outBtn.hidden = NO;
    
    return headView;
}

@end
