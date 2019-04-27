//
//  SFFinancialApprovalViewController.m
//  SFWork
//
//  Created by fox on 2019/4/25.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFFinancialApprovalViewController.h"
#import "SFFinancialApprovalingViewController.h"
#import "SFFinApprovalListViewController.h"
#import "SFIncomeHeadView.h"
#import "SFIncomeTableViewCell.h"
#import "SFFinancialApprovalHttpModel.h"
#import "SFFinancialListViewController.h"

@interface SFFinancialApprovalViewController ()

@property (nonatomic, strong) NSMutableArray *myLaunchArray;
@property (nonatomic, strong) NSMutableArray *myApproveArray;

@property (nonatomic, assign) BOOL isApprove;

@end

@implementation SFFinancialApprovalViewController

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
    [self requestData];
    [self initUI];
    [self addBottomView];
}

- (void)initUI{
    self.title = @"财务审批";
    self.isApprove = YES;
    UIButton * redIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redIconBtn.frame = CGRectMake(0, 0, 65, 44);
    redIconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    redIconBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    redIconBtn.tag = 1000;
    [redIconBtn setTitle:@"公司财务审批列表" forState:0];
    [redIconBtn setTitleColor:[UIColor colorWithRed:40/255.0 green:179/255.0 blue:139/255.0 alpha:1.0] forState:0];
    [redIconBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * redItem = [[UIBarButtonItem alloc]initWithCustomView:redIconBtn];
    self.navigationItem.rightBarButtonItem = redItem;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFIncomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFIncomeTableViewCell"];

}


- (void)requestData{
    
    [MBProgressHUD showActivityMessageInWindow:@"加载信息..."];
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFFinancialApprovalHttpModel myApproveBillGroups:@{} success:^(NSArray * _Nonnull list) {
             [subscriber sendNext:@"1"];
            [self.myApproveArray removeAllObjects];
            [self.myApproveArray addObjectsFromArray:list];
            [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
        }];
       
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFFinancialApprovalHttpModel myLaunchBillfinaceGroups:@{} success:^(NSArray * _Nonnull list) {
            [subscriber sendNext:@"1"];
            [self.myLaunchArray removeAllObjects];
            [self.myLaunchArray addObjectsFromArray:list];
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
        [MBProgressHUD showErrorMessage:@"加载失败,请重新加载!"];
        [MBProgressHUD hideHUD];
    }
}

- (void)rightBtnAction:(UIButton *)sender{
    SFFinApprovalListViewController * listVC = [SFFinApprovalListViewController new];
    [self.navigationController pushViewController:listVC animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * array = self.isApprove ? self.myApproveArray[indexPath.section]:self.myLaunchArray[indexPath.section];
    SFFinancialModel * model = array[indexPath.row];
    SFFinancialApprovalingViewController * svc = [SFFinancialApprovalingViewController new];
    svc.f_id = model._id;
    svc.fType = FinancialApprovalType;
    [self.navigationController pushViewController:svc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray * array = self.isApprove ? self.myApproveArray[section]:self.myLaunchArray[section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.isApprove?self.myApproveArray.count:self.myLaunchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFIncomeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray * array = self.isApprove ? self.myApproveArray[indexPath.section]:self.myLaunchArray[indexPath.section];
    SFFinancialModel * model = array[indexPath.row];
    cell.fmodel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    lineView.backgroundColor = Color(@"#D8D8D8");
    [footerView addSubview:lineView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"查看更多" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kRegFont size:13];
    [button setTitleColor:defaultColor forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [footerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(footerView);
        make.right.equalTo(footerView.mas_right).offset(-10);
        make.width.offset(100);
    }];
    
    @weakify(self)
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        SFFinancialListViewController * vc = [SFFinancialListViewController new];
        if (section == 0) {
            vc.isApprove = NO;
        }else{
            vc.isApprove = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SFIncomeHeadView * headView = [[[NSBundle mainBundle]loadNibNamed:@"SFIncomeHeadView" owner:nil options:nil] firstObject];
    NSArray * btnTitle = @[@"待审批",@"已审批"];
    NSString * title = btnTitle[section];
    headView.timeLB.text = title;
    return headView;
}

- (void)addBottomView{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    NSArray * btnTitle = @[@"待我审批的",@"我发起的"];
    for (int i = 0 ; i < btnTitle.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnTitle[i] forState:0];
        [btn setTitleColor:Color(@"#666666") forState:0];
        [btn setTitleColor:defaultColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i + 1000;
        [bottomView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(kWidth/2*i);
            make.width.mas_equalTo(kWidth/2);
        }];
        if (i == 0) {
            btn.selected = YES;
        }
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            if (x.tag == 1000) {
                self.isApprove = YES;
            }else{
                self.isApprove = NO;
            }
            for (int i = 1000; i < 1002; i ++) {
                UIButton * button = [bottomView viewWithTag:i];
                button.selected = NO;
            }
            x.selected = YES;
            [self.tableView reloadData];
        }];
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectZero];
//    line.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
    line.backgroundColor = [UIColor redColor];
    [bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
        make.centerY.mas_equalTo(50/2);
    }];
}
@end
