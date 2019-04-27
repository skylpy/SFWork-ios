//
//  SFHomeViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFHomeViewController.h"
#import "SFCompanyBillViewController.h"
#import "SFFinancialInputViewController.h"
#import "SFFixedExpensesViewController.h"
#import "SFFinancialApprovalViewController.h"
#import "SFHomeModel.h"
#import "SFHomeTableCell.h"
#import "SFHomeHeaderView.h"

#define cellH (kWidth - 70) / 3
static NSString * const SFHomeTableCellID = @"SFHomeTableCellID";

@interface SFHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SFHomeTableCellDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * titleArray;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation SFHomeViewController

-(NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"日常办公",@"客户管理",@"财务管理", nil];
    }
    return _titleArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    [self initDrawUI];
    [self initData];
    
}

- (void)initData{
    
    NSArray * array = [SFHomeModel shareHomeModel];
   
    NSArray * arrs = [SFInstance shareInstance].userInfo.permissions;
    NSMutableArray * allArray = [NSMutableArray array];
    for (NSArray * arr in array) {
        NSMutableArray * sectionArr = [NSMutableArray array];
        for (SFHomeModel * model in arr) {
            for (PermissionsModel * pmodel in arrs) {
                
                if ([model.code isEqualToString: pmodel.code]) {
                    if (pmodel.hasPermission) {
                        model.title = pmodel.name;
                        [sectionArr addObject:model];
                    }
                }
            }
           
        }
        if (sectionArr.count > 0) {
            [allArray addObject:sectionArr];
        }
    }
    
    [self.dataArray addObjectsFromArray:allArray];
    
    [self.tableView reloadData];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         
         make.edges.mas_equalTo(self.view);
     }];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    NSLog(@"array == %ld",array.count);
    NSInteger index = array.count%3 == 0 ? array.count/3:array.count/3+1;
    return 80*index+70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SFHomeHeaderView * header = [SFHomeHeaderView shareSFHomeHeaderView];
    header.titleLabel.text = self.titleArray[section];
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFHomeTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFHomeTableCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * array = self.dataArray[indexPath.section];
    cell.array = array;
    cell.delegate = self;
    return cell;
    
}

#pragma SFHomeTableCellDelegate
- (void)collectionView:(SFHomeModel *)model didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (model.type == 0) {
        
        UIViewController * vc = [[UIStoryboard storyboardWithName:@"MyAttendance" bundle:nil] instantiateViewControllerWithIdentifier:@"SFMyAttendance"];
        
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == 1) {
        
        UIViewController * vc = [[UIStoryboard storyboardWithName:@"AttendanceMgr" bundle:nil] instantiateViewControllerWithIdentifier:@"SFAttendanceMgr"];
        
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == 11 && isEmployee){
        
        
        UIViewController * vc = [[UIStoryboard storyboardWithName:@"WorkAssessment" bundle:nil] instantiateViewControllerWithIdentifier:@"SFWorkAssessment"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == 15) {

        UIViewController * vc = [[UIStoryboard storyboardWithName:@"CustomerMgr" bundle:nil] instantiateViewControllerWithIdentifier:@"SFCustomerMgr"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.type == 16 || model.type == 17){
        
        UIViewController * vc = [[UIStoryboard storyboardWithName:@"VisitMgr" bundle:nil] instantiateViewControllerWithIdentifier:@"SFVisitMgr"];
        if (model.type == 16) {
            
            [vc setValue:@"TEL" forKey:@"type"];
        }

        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (model.type == 24) {
        SFCompanyBillViewController * finVC = [SFCompanyBillViewController new];
        [self.navigationController pushViewController:finVC animated:YES];
    }
    else if (model.type == 18) {
        SFFinancialInputViewController * finVC = [SFFinancialInputViewController new];
        [self.navigationController pushViewController:finVC animated:YES];
    }else if (model.type == 25) {
        SFFinancialApprovalViewController * finVC = [SFFinancialApprovalViewController new];
        [self.navigationController pushViewController:finVC animated:YES];
    }else if (model.type == 19||model.type == 20||model.type == 21){
        SFFixedExpensesViewController * fixVC = [SFFixedExpensesViewController new];
        if (model.type == 19) {
            fixVC.title = @"固定支出";
        }else if (model.type == 20){
            fixVC.title = @"应收账款";
        }else if (model.type == 21){
            fixVC.title = @"应付账款";
        }
        [self.navigationController pushViewController:fixVC animated:YES];
    }else if (model.type == 7){
         UIViewController * vc = [[UIStoryboard storyboardWithName:@"ExpenseMgr" bundle:nil] instantiateViewControllerWithIdentifier:@"SFExpenseMgr"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIViewController * vc = [NSClassFromString(model.controller) new];
        if (model.type == 13) {
            [vc setValue:@"" forKey:@"parentId"];
            [vc setValue:@"CONTRACT" forKey:@"type"];
        }else if (model.type == 22){
            [vc setValue:@"" forKey:@"parentId"];
            [vc setValue:@"FINANCE" forKey:@"type"];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerClass:[SFHomeTableCell class] forCellReuseIdentifier:SFHomeTableCellID];
        
    }
    return _tableView;
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"今日工作" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            UIViewController * vc = [[UIStoryboard storyboardWithName:@"ToDayWork" bundle:nil] instantiateViewControllerWithIdentifier:@"SFToDayWork"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
    }
    return _rightButton;
}

@end
