//
//  SFIncomeViewController.m
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFIncomeViewController.h"
#import "SFShowAnsEditIncomeViewController.h"
#import "SFBillSearchResultViewController.h"
#import "SFIncomeHeadView.h"
#import "SFIncomeTableViewCell.h"
#import "FromDateSelectDatePick.h"
#import "SFBillHomeModel.h"

@interface SFIncomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *outExcelBtn;
@property (weak, nonatomic) IBOutlet UILabel *sumAmountLB;

@end

@implementation SFIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}

- (void)initUI{
    _outExcelBtn.layer.cornerRadius = 6;
    UIButton * redIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redIconBtn.frame = CGRectMake(0, 0, 65, 44);
    redIconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    redIconBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    redIconBtn.tag = 1000;
    [redIconBtn setTitle:@"日期筛选" forState:0];
    [redIconBtn setTitleColor:[UIColor colorWithRed:40/255.0 green:179/255.0 blue:139/255.0 alpha:1.0] forState:0];
    [redIconBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * redItem = [[UIBarButtonItem alloc]initWithCustomView:redIconBtn];
    self.navigationItem.rightBarButtonItem = redItem;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.bottom.equalTo(self.view).offset(IsIPhoneX?-84:-50);
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

- (IBAction)outExcelAction:(UIButton *)sender {
    [MBProgressHUD showActivityMessageInView:@""];
    [self uploadHistory];
    
}


- (void)rightBtnAction:(UIButton *)sender{
    FromDateSelectDatePick * datePickView = [[[NSBundle mainBundle]loadNibNamed:@"FromDateSelectDatePick" owner:nil options:nil] firstObject];
    datePickView.frame = CGRectMake(0, 0, kWidth, kHeight);
    [datePickView initUI];
    datePickView.sureBlock = ^(NSString * _Nonnull startDate, NSString * _Nonnull endDate) {
        SFBillSearchResultViewController * resultVC = [SFBillSearchResultViewController new];
        resultVC.titleStr = self.title;
        resultVC.startDateStr = startDate;
        resultVC.endDateStr = endDate;
        resultVC.title = @"日期筛选";
        [self.navigationController pushViewController:resultVC animated:YES];
        
    };
    [[UIApplication sharedApplication].keyWindow addSubview:datePickView];
}

- (void)uploadHistory{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[self.title isEqualToString:@"收入"]?@[@"DEBIT"]:@[@"CREDIT"] forKey:@"dcFlags"];
    [params setObject:@(YES) forKey:@"isHistory"];
    [SFBaseModel BPOST:BASE_URL(@"/finace/bill/billList/export") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        if (model.status == 200) {
            [SFCommon ShowAlterViewWithTitle:@"导出已成功" IsShowCancel:NO Message:@"已经导出Excel文档到“财务文件\n”模块中的“最近上传”中了" RootVC:self SureBlock:^{
                
            }];
        }
        NSLog(@"%@",self.dataArray);
        [MBProgressHUD hideHUD];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

- (void)requestData{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[self.title isEqualToString:@"收入"]?@[@"DEBIT"]:@[@"CREDIT"] forKey:@"dcFlags"];
    [params setObject:@(self.pageNum) forKey:@"pageNum"];
    [params setObject:@(self.pageSize) forKey:@"pageSize"];
    [SFBaseModel BPOST:BASE_URL(@"/finace/bill/sum/search/group") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (self.pageNum==1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[SFBillHomeModel class] json:model.result[@"list"]]];
        [self.tableView reloadData];
        NSLog(@"%@",self.dataArray);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
    
    [SFBaseModel BGET:BASE_URL(@"/finace/bill/sum/balance") parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        if (model.status == 200) {
            self.sumAmountLB.text = [NSString stringWithFormat:@"%@总计:%@",self.title,[self.title isEqualToString:@"支出"]?model.result[@"creditAmount"]:model.result[@"debitAmount"]];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SFShowAnsEditIncomeViewController * svc = [SFShowAnsEditIncomeViewController new];
    svc.title = [self.title isEqualToString:@"支出"]?@"支出（贷方）详情":@"收入（借方）详情";
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
    cell.titleLB.text = [NSString stringWithFormat:@"%@:",self.title];
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
