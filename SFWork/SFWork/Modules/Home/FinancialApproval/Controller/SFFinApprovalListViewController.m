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
@property (nonatomic, strong) NSMutableArray *myLaunchArray;
@property (nonatomic, strong) NSMutableArray *myApproveArray;
@end

@implementation SFFinApprovalListViewController
- (NSMutableArray *)myApproveArray{
    
    if (!_myApproveArray) {
        _myApproveArray = [NSMutableArray array];
    }
    return _myApproveArray;
}

- (NSMutableArray *)myLaunchArray{
    
    if (!_myLaunchArray) {
        _myLaunchArray = [NSMutableArray array];
    }
    return _myLaunchArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 1;
    self.pageSize = 2000;
    [self initUI];
}

- (void)initUI{
    self.title = @"公司财务审批列表";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFIncomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFIncomeTableViewCell"];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mj_headerLoading)];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mj_footLoading)];
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
    
    [MBProgressHUD showActivityMessageInWindow:@"加载信息..."];
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary * pamars = [NSMutableDictionary dictionary];
        [pamars setObject:@(self.pageNum) forKey:@"pageNum"];
        [pamars setObject:@(self.pageSize) forKey:@"pageSize"];
        [pamars setObject:@(0) forKey:@"isProcessing"];
        [SFFinancialApprovalHttpModel myApproveBillALL:pamars success:^(NSArray * _Nonnull list) {
            [subscriber sendNext:@"1"];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            if (self.pageNum == 1) {
                [self.myLaunchArray removeAllObjects];
            }
            
            [self.myLaunchArray addObjectsFromArray:list];
            [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
        }];
        
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary * pamars = [NSMutableDictionary dictionary];
        [pamars setObject:@(self.pageNum) forKey:@"pageNum"];
        [pamars setObject:@(self.pageSize) forKey:@"pageSize"];
        [pamars setObject:@(1) forKey:@"isProcessing"];
        [SFFinancialApprovalHttpModel myApproveBillALL:pamars success:^(NSArray * _Nonnull list) {
            [subscriber sendNext:@"1"];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            if (self.pageNum == 1) {
                [self.myApproveArray removeAllObjects];
            }
            
            [self.myApproveArray addObjectsFromArray:list];
            [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
        }];
        
        return nil;
    }];
    [self rac_liftSelector:@selector(completedRequest1:request2:) withSignalsFromArray:@[signal1, signal2]];
}

- (void)completedRequest1:(NSString *)signal1 request2:(NSString *)signal2 {
    
    if ([signal1 isEqualToString:@"1"] && [signal2 isEqualToString:@"1"] ) {
       
        [MBProgressHUD hideHUD];
        [self.tableView reloadData];
    }else{
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showErrorMessage:@"加载失败,请重新加载!"];
        [MBProgressHUD hideHUD];
    }
}

- (void)rightBtnAction:(UIButton *)sender{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SFFinancialModel * model;
    if (indexPath.section == 0) {
        model = self.myApproveArray[indexPath.row];
    }else{
        model = self.myLaunchArray[indexPath.row];
    }
    
    SFFinancialApprovalingViewController * svc = [SFFinancialApprovalingViewController new];
    svc.f_id = model._id;
    svc.fType = FinancialApprovalType;
    svc.fmodel = model;
    [self.navigationController pushViewController:svc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.myLaunchArray.count;
    }
    return self.myApproveArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFIncomeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (indexPath.section == 0) {
        SFFinancialModel * model = self.myApproveArray[indexPath.row];
        cell.fmodel = model;
    }else{
        SFFinancialModel * model = self.myLaunchArray[indexPath.row];
        cell.fmodel = model;
    }
    
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
    headView.timeLB.text = @"已审批";
    if (section == 0) {
        headView.timeLB.text = @"待审批";
    }
    return headView;
}
@end
