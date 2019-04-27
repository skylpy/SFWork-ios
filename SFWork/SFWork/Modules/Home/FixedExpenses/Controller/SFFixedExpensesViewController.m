//
//  SFFixedExpensesViewController.m
//  SFWork
//
//  Created by fox on 2019/4/20.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFFixedExpensesViewController.h"
#import "SFFixeDateSearchResultViewController.h"
#import "SFFixeDetailViewController.h"
#import "SFFixeSearchViewController.h"
#import "FromDateSelectDatePick.h"
#import "SFTallyTypeSelectView.h"
#import "SFIncomeTableViewCell.h"
#import "SFIncomeHeadView.h"
#import "SFAddTallyTypeView.h"
#import "SFBillHomeModel.h"

@interface SFFixedExpensesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * historyArray;
@property (nonatomic,strong) NSMutableDictionary * requestDic;
@property (nonatomic) NSInteger historyPage;
@property (nonatomic,strong) UIView * selectLine;
@property (nonatomic,strong) UIButton * selectBtn;
@end

@implementation SFFixedExpensesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)requestData{
    NSMutableDictionary * params = [self getCurrPageInterface];
    [params setObject:@(self.pageNum) forKey:@"pageNum"];
    [params setObject:_selectBtn.tag == 2002?@(self.historyPage):@(self.pageSize) forKey:@"pageSize"];
    [params setObject:_selectBtn.tag == 2002?@(YES):@(NO) forKey:@"isHistory"];
    [SFBaseModel BPOST:BASE_URL(@"/finace/bill/billList/group") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.selectBtn.tag == 2002) {
            if (self.pageNum == 1) {
                [self.historyArray removeAllObjects];
            }
            [self.historyArray addObjectsFromArray:[NSArray modelArrayWithClass:[SFBillHomeModel class] json:model.result[@"list"]]];
        }else{
            if (self.pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[SFBillHomeModel class] json:model.result[@"list"]]];
        }
        
        [self.tableView reloadData];
        NSLog(@"%@",self.dataArray);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

- (void)outExcelRequest{
    NSMutableDictionary * params = [self getCurrPageInterface];
    [params setObject:@(1) forKey:@"isDesc"];
    [params setObject:_selectBtn.tag == 2002?@(YES):@(NO) forKey:@"isHistory"];
    [SFBaseModel BPOST:BASE_URL(@"/finace/bill/billList/group") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.selectBtn.tag == 2002) {
            if (self.pageNum == 1) {
                [self.historyArray removeAllObjects];
            }
            [self.historyArray addObjectsFromArray:[NSArray modelArrayWithClass:[SFBillHomeModel class] json:model.result[@"list"]]];
        }else{
            if (self.pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[SFBillHomeModel class] json:model.result[@"list"]]];
        }
        
        [self.tableView reloadData];
        NSLog(@"%@",self.dataArray);
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
    
    UIButton * rightIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightIconBtn.frame = CGRectMake(0, 0, 35, 44);
    rightIconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightIconBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightIconBtn setTitle:@"日期筛选" forState:0];
    [rightIconBtn setTitleColor:[UIColor colorWithRed:40/255.0 green:179/255.0 blue:139/255.0 alpha:1.0] forState:0];
    [rightIconBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * clearItem = [[UIBarButtonItem alloc]initWithCustomView:rightIconBtn];
    self.navigationItem.rightBarButtonItems = @[clearItem,redItem];
    
    self.historyArray = [NSMutableArray array];
    self.historyPage = 1;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(46);
        make.bottom.mas_equalTo(SafeAreaBottomHeight);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFIncomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFIncomeTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mj_headerLoading)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mj_footLoading)];
    
    [self addAddBtn];
    [self topView];
    [self requestData];
}

- (void)mj_headerLoading{
    if (_selectBtn.tag == 2001) {
        self.pageSize = 1;
    }else{
        self.historyPage = 1;
    }
    [self requestData];
}

- (void)mj_footLoading{
    if (_selectBtn.tag == 2001) {
        self.pageSize ++;
    }else{
        self.historyPage ++;
    }
    [self requestData];
}

- (void)rightBtnAction:(UIButton *)sender{
    if (sender.tag == 1000) {
        SFFixeSearchViewController * fixSearchVC = [SFFixeSearchViewController new];
        fixSearchVC.title = [NSString stringWithFormat:@"%@详细搜索",self.title];
        [self.navigationController pushViewController:fixSearchVC animated:YES];
    }else{
        FromDateSelectDatePick * datePickView = [[[NSBundle mainBundle]loadNibNamed:@"FromDateSelectDatePick" owner:nil options:nil] firstObject];
        datePickView.frame = CGRectMake(0, 0, kWidth, kHeight);
        [datePickView initUI];
        datePickView.sureBlock = ^(NSString * _Nonnull startDate, NSString * _Nonnull endDate) {
            SFFixeDateSearchResultViewController * resultVC = [SFFixeDateSearchResultViewController new];
            resultVC.titleStr = [self getTitle];
            resultVC.startDateStr = startDate;
            resultVC.endDateStr = endDate;
            resultVC.reuestDic = self.requestDic;
            resultVC.title = @"日期筛选";
            [self.navigationController pushViewController:resultVC animated:YES];
            
        };
        [[UIApplication sharedApplication].keyWindow addSubview:datePickView];
    }


}

- (void)createNewMessage{
    SFFixeSearchViewController * fixSearchVC = [SFFixeSearchViewController new];
    fixSearchVC.title = [NSString stringWithFormat:@"新增%@",self.title];
    fixSearchVC.isAdd = YES;
    [self.navigationController pushViewController:fixSearchVC animated:YES];
}

- (void)topSelectAction:(UIButton *)sender{
    sender.selected = YES;
    _selectBtn.selected = NO;
    _selectBtn = sender;
    if (self.historyArray.count==0&&_selectBtn.tag == 2002) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self.tableView reloadData];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.selectLine.centerX = self.selectBtn.centerX;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SFFixeDetailViewController * finaDetailVC = [SFFixeDetailViewController new];
    finaDetailVC.title = @"收入（借方）详情";
    [self.navigationController pushViewController:finaDetailVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SFBillHomeModel * model = _selectBtn.tag == 2001?self.dataArray[section]:self.historyArray[section];
    return model.billList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _selectBtn.tag == 2001?self.dataArray.count:self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFIncomeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLB.text = [NSString stringWithFormat:@"%@:",[self getTitle]];
    SFBillHomeModel * model = _selectBtn.tag == 2001?self.dataArray[indexPath.section]:self.historyArray[indexPath.section];
    SFBillListModel * detailModel = model.billList[indexPath.row];
    cell.model = detailModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SFBillHomeModel * model = _selectBtn.tag == 2001?self.dataArray[section]:self.historyArray[section];
    SFIncomeHeadView * headView = [[[NSBundle mainBundle]loadNibNamed:@"SFIncomeHeadView" owner:nil options:nil]firstObject];
    headView.outBlock = ^{
        NSDate * date = [SFCommon stringToDate:model.groupDate];
        NSInteger currDays = [SFCommon getDateMonthDay:date];
    };
    headView.outBtn.hidden = NO;
    headView.timeLB.text = [SFCommon getNULLString:model.groupDate];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel * sumLB = [[UILabel alloc]initWithFrame:CGRectZero];
    SFBillHomeModel * model = _selectBtn.tag == 2001?self.dataArray[section]:self.historyArray[section];
    sumLB.text = [NSString stringWithFormat:@"总计：%@",[SFCommon getNULLStringReturnZero:model.groupAmt]];
    sumLB.textColor = [UIColor blackColor];
    sumLB.font = [UIFont boldSystemFontOfSize:14];
    sumLB.textAlignment = 1;
    sumLB.backgroundColor = UIColor.whiteColor;
    return sumLB;
}

- (void)addAddBtn{
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"btn_oval_add_green"] forState:0];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(createNewMessage) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.width.mas_equalTo(55);
        make.bottom.mas_equalTo(-70);
    }];
}

- (void)topView{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectZero];
    topView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
    
    UIButton * planFixedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [planFixedBtn setTitle:@"计划支出" forState:0];
    [planFixedBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    [planFixedBtn setTitleColor:[UIColor colorWithRed:1/255.0 green:179/255.0 blue:139/255.0 alpha:1.0] forState:UIControlStateSelected];
    planFixedBtn.selected = YES;
    planFixedBtn.tag = 2001;
    [topView addSubview:planFixedBtn];
    [planFixedBtn addTarget:self action:@selector(topSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [planFixedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kWidth/2);
    }];
    _selectBtn = planFixedBtn;
    
    UIView * lineLB = [[UIView alloc]initWithFrame:CGRectZero];
    lineLB.backgroundColor = [UIColor colorWithRed:1/255.0 green:179/255.0 blue:139/255.0 alpha:1.0];
    [topView addSubview:lineLB];
    [lineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(2);
        make.bottom.mas_equalTo(0);
        make.centerX.equalTo(planFixedBtn.mas_centerX);
    }];
    _selectLine = lineLB;

    UIButton * historydBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [historydBtn setTitle:@"历史支出" forState:0];
    historydBtn.tag = 2002;
    [historydBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    [historydBtn setTitleColor:[UIColor colorWithRed:1/255.0 green:179/255.0 blue:139/255.0 alpha:1.0] forState:UIControlStateSelected];
    [topView addSubview:historydBtn];
    [historydBtn addTarget:self action:@selector(topSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [historydBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(planFixedBtn.mas_right).offset(0);
        make.width.mas_equalTo(kWidth/2);
    }];

}

- (NSMutableDictionary *)getCurrPageInterface{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    _requestDic = params;
    if ([self.title containsString:@"固定"]) {
        [params setObject:@[@"GZ"] forKey:@"bizTypes"];
        [params setObject:@(NO) forKey:@"isDesc"];
    }
    
    if ([self.title containsString:@"应收"]) {
        [params setObject:@[@"YS"] forKey:@"bizTypes"];
        [params setObject:@(YES) forKey:@"isDesc"];
    }
    
    if ([self.title containsString:@"应付"]) {
        [params setObject:@[@"YF"] forKey:@"bizTypes"];
        [params setObject:@(NO) forKey:@"isDesc"];
    }
    return params;
}

- (NSString *)getTitle{
    if ([self.title containsString:@"固定"]) {
        return @"支出";
    }
    
    if ([self.title containsString:@"应收"]) {
        return @"收入";
    }
    
    if ([self.title containsString:@"应付"]) {
       return @"return @"";";
    }
    return @"";
}

- (NSMutableDictionary *)requestDic{
    if (_requestDic == nil) {
        _requestDic = [NSMutableDictionary dictionary];
    }
    
    return _requestDic;
}

@end
