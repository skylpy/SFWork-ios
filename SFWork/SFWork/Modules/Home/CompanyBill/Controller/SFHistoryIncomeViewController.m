//
//  SFHistoryIncomeViewController.m
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFHistoryIncomeViewController.h"
#import "SFShowAnsEditIncomeViewController.h"
#import "SFFinancialApprovalingViewController.h"
#import "SFIncomeTableViewCell.h"
#import "FromDateSelectDatePick.h"
#import "SFBillHomeModel.h"

@interface SFHistoryIncomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SFHistoryIncomeViewController

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
    [self requestData];
}

- (void)requestData{
    [SFBaseModel BPOST:BASE_URL(@"/finace/bill/search") parameters:_params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        NSLog(@"%@",model.result);
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[SFBillListModel class] json:model.result[@"list"]]];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SFBillListModel * model = self.dataArray[indexPath.row];
    if (_bizTypes) {
        SFFinancialApprovalingViewController * svc = [SFFinancialApprovalingViewController new];
        svc.f_id = model.ID;
        svc.title = _showDetailStr;
        svc.fmodel = model;
        svc.state = @"1";
        [self.navigationController pushViewController:svc animated:YES];
    }else{
        SFShowAnsEditIncomeViewController * svc = [SFShowAnsEditIncomeViewController new];
        
        svc.showModel = model;
        if (_showDetailStr) {
            svc.title = _showDetailStr;
        }else{
            svc.title = [self.title containsString:@"支出"]?@"支出（贷方）详情":@"收入（借方）详情";
        }
        [self.navigationController pushViewController:svc animated:YES];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFIncomeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    SFBillListModel * model = self.dataArray[indexPath.row];
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
    return 0.0001;
}

@end
