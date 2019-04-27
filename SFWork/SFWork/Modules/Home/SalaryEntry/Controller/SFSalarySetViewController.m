//
//  SFSalarySetViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSalarySetViewController.h"
#import "SFProfileTableCell.h"
#import "SFOrganizationModel.h"
#import "SFJournalHttpModel.h"
#import "SFTipDesView.h"
#import "SFSalaryEntryModel.h"

static NSString * const SFProfileTableCellID = @"SFProfileTableCellID";


@interface SFSalarySetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UIButton * bottomButton;
@property (nonatomic, strong) SFTipDesView *tipDesView;
@property (nonatomic, strong) UIButton *letfButton;


@end

@implementation SFSalarySetViewController

- (SFTipDesView *)tipDesView{
    
    if (!_tipDesView) {
        _tipDesView = [SFTipDesView shareSFTipDesView];
    }
    return _tipDesView;
}


- (UIButton *)bottomButton{
    
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(0, 0, kWidth, 45);
        [_bottomButton setTitle:@"保存" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _bottomButton.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        _bottomButton.backgroundColor = Color(@"#01B38B");
        @weakify(self)
        [[_bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self saveDep];
            
        }];
    }
    return _bottomButton;
}

- (UIButton *)letfButton{
    
    if (!_letfButton) {
        
        _letfButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _letfButton.frame = CGRectMake(0, 0, 12, 20);
        [_letfButton setImage:[UIImage imageNamed:@"arrow_return_gray"] forState:UIControlStateNormal];
        @weakify(self)
        [[_letfButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _letfButton;
}


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"薪资录入";
    
    [self initDrawUI];
    [self initData];
}

- (void)saveDep{
    
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    SFProfileModel * model = self.dataArray[1];
    [dict setValue:self.empId forKey:@"id"];
    if ([model.destitle isEqualToString:@""]||model.destitle==nil) {
        [MBProgressHUD showTipMessageInView:@"请输入薪资"];
        return;
    }
    [dict setValue:model.destitle forKey:@"salary"];
    
    [MBProgressHUD showActivityMessageInView:@"保存中"];
    [SFSalaryEntryModel empSetSalary:dict success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:@"设置薪资成功"];
        !self.didSaveClick?:self.didSaveClick();
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:@"设置薪资失败"];
    }];
}


- (void)initData{
    
    NSArray * array = [SFProfileModel shareSalaryModel:self.empName withSalary:self.salary];
    
    [self.dataArray addObjectsFromArray:array];
    
    [self.tableView reloadData];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.tipDesView];
    [self.tipDesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.offset(35);
    }];
    
    [self.view addSubview:self.bottomButton];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(45);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipDesView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.bottomButton.mas_top);
    }];
    
   
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.letfButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFProfileTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFProfileTableCellID forIndexPath:indexPath];
    
    SFProfileModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerClass:[SFProfileTableCell class] forCellReuseIdentifier:SFProfileTableCellID];
        
    }
    return _tableView;
}


@end
