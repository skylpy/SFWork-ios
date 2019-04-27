//
//  SFFinancialInputViewController.m
//  SFWork
//
//  Created by fox on 2019/4/19.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFFinancialInputViewController.h"
#import "SFFinanciaDetailViewController.h"
#import "SFFinanAddRecordViewController.h"
#import "SFFinanciaDetailViewController.h"
#import "SFFinanDetailSearchViewController.h"
#import "FromDateSelectDatePick.h"
#import "SFFinanciaCell.h"
#import "SFDetailSearchView.h"
#import "SFFinancialApprovalHttpModel.h"
#import "SFFinancialApprovalingViewController.h"
#import "SFSearchDetailViewController.h"

@interface SFFinancialInputViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFFinancialInputViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self requestData];
}

- (void)requestData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setValue:@"" forKey:@"bizTypes"];
//    [dict setValue:@"1" forKey:@"pageNum"];
//    [dict setValue:@"15" forKey:@"pageSize"];
//    [dict setValue:@"" forKey:@"startDate"];
//    [dict setValue:@"" forKey:@"endDate"];
    
    [MBProgressHUD showActivityMessageInView:@""];
    [SFFinancialApprovalHttpModel finaceBillListProcess:dict success:^(NSArray * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
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
    
    UIButton * rightIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightIconBtn.frame = CGRectMake(0, 0, 35, 44);
    rightIconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightIconBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightIconBtn setTitle:@"日期筛选" forState:0];
    [rightIconBtn setTitleColor:[UIColor colorWithRed:40/255.0 green:179/255.0 blue:139/255.0 alpha:1.0] forState:0];
    [rightIconBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * clearItem = [[UIBarButtonItem alloc]initWithCustomView:rightIconBtn];
    self.navigationItem.rightBarButtonItems = @[clearItem,redItem];
    
    self.title = @"财务录入";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFFinanciaCell" bundle:nil] forCellReuseIdentifier:@"SFFinanciaCell"];
    
    [self.view bringSubviewToFront:_addBtn];
}

- (void)rightBtnAction:(UIButton *)sender{
    if (sender.tag==1000) {
        SFDetailSearchView * searchView = [[SFDetailSearchView alloc]initWithFrame:CGRectMake(0, 0,kWidth, kHeight)];
        [searchView createItemWithTitleArray:@[@"收入（借方）",@"支出（贷方）",@"自定义账款"]];
        searchView.titleStr = @"请问您要搜索哪一项？";
        searchView.selectIndexBlock = ^(NSInteger index) {
//            SFSearchDetailViewController * searDetailVC = [SFSearchDetailViewController new];
//            searDetailVC.title = index==101?@"收入详细搜索":@"支出详细搜索";
//            searDetailVC.type = index==101?@"DEBIT":@"CREDIT";
//            [self.navigationController pushViewController:searDetailVC animated:YES];
            
            SFSearchDetailViewController * searDetailVC = [SFSearchDetailViewController new];
            searDetailVC.title = [NSString stringWithFormat:@"%@详细搜索",self.title];
            
            if (index == 101) {
                searDetailVC.bizTypes = @"LS";
                searDetailVC.type = @"LS";
                searDetailVC.showDetailStr = @"收入（借方）详细搜索";
                searDetailVC.title = @"收入（借方）详细搜索";
            }else if (index == 102){
                searDetailVC.bizTypes =  @"LC";
                searDetailVC.type = @"LC";
                 searDetailVC.showDetailStr = @"支出（贷方）详细搜索";
                searDetailVC.title = @"支出（贷方）详细搜索";
            }else if (index == 103){
                searDetailVC.bizTypes = @"LO";
                searDetailVC.type = @"LO";
                searDetailVC.showDetailStr = @"自定义账款详细搜索";
                searDetailVC.title = @"自定义账款详细搜索";
            }
            [self.navigationController pushViewController:searDetailVC animated:YES];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:searchView];
    }else{
        FromDateSelectDatePick * datePickView = [[[NSBundle mainBundle]loadNibNamed:@"FromDateSelectDatePick" owner:nil options:nil] firstObject];
        datePickView.frame = CGRectMake(0, 0, kWidth, kHeight);
        [datePickView initUI];
        datePickView.sureBlock = ^(NSString * _Nonnull startDate, NSString * _Nonnull endDate) {
            
        };
        [[UIApplication sharedApplication].keyWindow addSubview:datePickView];
    }
    
}

- (NSString *)getDetailTitle{
    if ([self.title containsString:@"固定"]) {
        
        return @"固定支出详情";
    }
    
    if ([self.title containsString:@"应收"]) {
        return @"应收账款详情";
    }
    
    if ([self.title containsString:@"应付"]) {
        return @"应付账款详情";;
    }
    return @"";
}

- (NSString *)getBizTypes{
    if ([self.title containsString:@"固定"]) {
        return @"GZ";
    }
    
    if ([self.title containsString:@"应收"]) {
        return @"YS";
    }
    
    if ([self.title containsString:@"应付"]) {
        return @"YF";
    }
    return @"";
}

- (IBAction)addNewList:(UIButton *)sender {
    SFDetailSearchView * searchView = [[SFDetailSearchView alloc]initWithFrame:CGRectMake(0, 0,kWidth, kHeight)];
    [searchView createItemWithTitleArray:@[@"收入（借方）",@"支出（贷方）",@"自定义账款"]];
    searchView.titleStr = @"请问您要新增哪一项？";
    searchView.selectIndexBlock = ^(NSInteger index) {
        SFFinanAddRecordViewController * addVC = [SFFinanAddRecordViewController new];
        if (index == 101) {
            addVC.type = @"LS";
            addVC.title = @"新增收入（借方）";
        }else if (index == 102){
            addVC.type = @"LC";
            addVC.title = @"新增支出（贷方）";
        }else if (index == 103){
            addVC.type = @"LO";
            addVC.title = @"新增自定义账款";
        }
        [self.navigationController pushViewController:addVC animated:YES];
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
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFFinancialModel * model = self.dataArray[indexPath.section];
    SFFinanciaDetailViewController * finaDetailVC = [SFFinanciaDetailViewController new];
    
    finaDetailVC.f_id = model._id;
    finaDetailVC.fType = FinancialApprovalType;
    [self.navigationController pushViewController:finaDetailVC animated:YES];
    
//    SFFinancialApprovalingViewController * svc = [SFFinancialApprovalingViewController new];
//    svc.f_id = model._id;
//    svc.fType = FinancialApprovalType;
//    [self.navigationController pushViewController:svc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFFinanciaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFFinanciaCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SFFinancialModel * model = self.dataArray[indexPath.section];
    cell.fmodel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 145;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

@end
