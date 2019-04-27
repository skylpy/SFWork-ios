//
//  SFAddDataAssViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddDataAssViewController.h"
#import "SFAssessmentCell.h"
#import "SFAddHeaderView.h"
#import "SFAddDataFooterView.h"

static NSString * const SFAssessmentCellID = @"SFAssessmentCellID";

@interface SFAddDataAssViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SFAddHeaderView *headerView;
@property (nonatomic, strong) UIButton *footerButton;
@property (nonatomic, strong) SFAddDataFooterView * footerView;
@property (nonatomic, strong) ItemsModel *item;
@end

@implementation SFAddDataAssViewController


- (SFAddHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [SFAddHeaderView shareSFAddHeaderView];
        _headerView.autoresizingMask = UIViewAutoresizingNone;
        if (!self.model) {
            self.item = [ItemsModel addModel];
            _headerView.item = self.item;
        }
        
    }
    return _headerView;
}

- (SFAddDataFooterView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [SFAddDataFooterView shareSFAddDataFooterView];
        
    }
    return _footerView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加数据项";
    [self setDrawUI];
}

- (void)setModel:(ItemsModel *)model{
    _model = model;
    self.item = model;
    self.headerView.item = model;
    [self.dataArray addObjectsFromArray:model.ratingSettings];
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
   
    self.tableView.tableHeaderView = self.headerView;
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    [footerView addSubview:self.footerButton];
    footerView.backgroundColor = bgColor;
    self.tableView.tableFooterView = footerView;
    
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
    
    @weakify(self)
    [self.footerView setSureClick:^(NSInteger index) {
        @strongify(self)
        if (index == 1) {
            
            self.item.ratingSettings = self.dataArray;
            !self.completeClick?:self.completeClick(self.item);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 45;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == self.dataArray.count) {
        
        return 10;
        
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {

        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 45)];
        
        UILabel * titleLabel = [UILabel createALabelText:@"输入的考核数值大于等于达标值就显示加分，小于就显示扣分" withFont:[UIFont fontWithName:kRegFont size:11] withColor:Color(@"#666666")];
        [headerView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(15, 25, kWidth-30, 12);
        return headerView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFAssessmentCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAssessmentCellID forIndexPath:indexPath];
    RatingSettingModel * model = self.dataArray[indexPath.section];
    [cell cellWithValue:[self.headerView.numberTextField.text integerValue] withModel:model];
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFAssessmentCell" bundle:nil] forCellReuseIdentifier:SFAssessmentCellID];

    }
    return _tableView;
}

- (UIButton *)footerButton{
    
    if (!_footerButton) {
        _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _footerButton.frame = CGRectMake(0, 10, kWidth, 45);
        [_footerButton setTitle:@"添加考核项" forState:UIControlStateNormal];
        [_footerButton setTitleColor:Color(@"#01B38B") forState:UIControlStateNormal];
        _footerButton.backgroundColor = Color(@"#FFFFFF");
        _footerButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            if (self.headerView.numberTextField.text.length > 0) {
                [self.dataArray addObject:[RatingSettingModel addModel]];
                [self.tableView reloadData];
            }else{
                [UIAlertController alertTitle:@"温馨提示" mesasge:@"请先填写完整资料" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
                    
                } viewController:self];
            }
            
        }];
    }
    return _footerButton;
}

@end

