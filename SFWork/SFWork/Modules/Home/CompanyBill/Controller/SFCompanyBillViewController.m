//
//  SFCompanyBillViewController.m
//  SFWork
//
//  Created by fox on 2019/4/15.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFCompanyBillViewController.h"
#import "SFSearchDetailViewController.h"
#import "SFIncomeViewController.h"
#import "SFCompanyBillHeadView.h"
#import "SFDetailSearchView.h"

@interface SFCompanyBillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (strong, nonatomic) SFCompanyBillHeadView * headView;

@property (strong, nonatomic) NSDictionary * infoDic;
@end

@implementation SFCompanyBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"公司总账";
    [self initUI];
    [self requestData];
}

#pragma mark 获取数据
- (void)requestData{
    [SFBaseModel BGET:BASE_URL(@"/finace/bill/sum/balance") parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        self.infoDic = model.result;
        self.headView.infoDic = self.infoDic;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

- (void)initUI{
    UIButton * redIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redIconBtn.frame = CGRectMake(0, 0, 65, 44);
    redIconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    redIconBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    redIconBtn.tag = 1000;
    [redIconBtn setTitle:@"详细搜索" forState:0];
    [redIconBtn setTitleColor:[UIColor colorWithRed:40/255.0 green:179/255.0 blue:139/255.0 alpha:1.0] forState:0];
    [redIconBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * redItem = [[UIBarButtonItem alloc]initWithCustomView:redIconBtn];
    self.navigationItem.rightBarButtonItem = redItem;
    
    _headView = [[[NSBundle mainBundle]loadNibNamed:@"SFCompanyBillHeadView" owner:self options:nil]firstObject];
    _headView.height = 157;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.tableHeaderView = _headView;
    
}

- (void)rightBtnAction:(UIButton *)sender{

    SFDetailSearchView * searchView = [[SFDetailSearchView alloc]initWithFrame:CGRectMake(0, 0,kWidth, kHeight)];
    [searchView createItemWithTitleArray:@[@"历史收入",@"历史支出"]];
    searchView.selectIndexBlock = ^(NSInteger index) {
        SFSearchDetailViewController * searDetailVC = [SFSearchDetailViewController new];
        searDetailVC.title = index==101?@"收入详细搜索":@"支出详细搜索";
        [self.navigationController pushViewController:searDetailVC animated:YES];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:searchView];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerNib:[UINib nibWithNibName:@"SFSystemMessageCell" bundle:nil] forCellReuseIdentifier:@"SFSystemMessageCell"];
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SFIncomeViewController * ivc = [SFIncomeViewController new];
    ivc.title = indexPath.row==0?@"收入":@"支出";
    [self.navigationController pushViewController:ivc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = indexPath.row==0?@"收入列表":@"支出列表";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

@end
