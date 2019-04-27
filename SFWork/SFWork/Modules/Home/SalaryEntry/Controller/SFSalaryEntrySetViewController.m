//
//  SFSalaryEntryViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSalaryEntrySetViewController.h"
#import "SFSalaryEntryModel.h"
#import "SFSalaryEntryCell.h"

static NSString * const SFSalaryEntryCellID = @"SFSalaryEntryCellID";

@interface SFSalaryEntrySetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, copy) NSString *salaryRule;
@end

@implementation SFSalaryEntrySetViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"薪资规则设置";
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray: [SFSalaryEntryModel shareSalaryEntryModel]];
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 113;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFSalaryEntryCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSalaryEntryCellID forIndexPath:indexPath];
    SFSalaryEntryModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    @weakify(self)
    [cell setSelectClick:^(SFSalaryEntryModel * _Nonnull mod) {
        @strongify(self)
        [self selectForItem:mod];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFSalaryEntryModel * model = self.dataArray[indexPath.row];
    [self selectForItem:model];
    switch (model.type) {
        case 1:
            self.salaryRule = @"YPJ";
            break;
        case 2:
            self.salaryRule = @"YCQ";
            break;
        case 3:
            self.salaryRule = @"YTS";
            break;
        default:
            break;
    }
}

- (void)selectForItem:(SFSalaryEntryModel *)model {
    
    for (SFSalaryEntryModel * mod in self.dataArray) {
        mod.isClick = NO;
    }
    model.isClick = YES;
    self.saveButton.enabled = YES;
    self.saveButton.backgroundColor = Color(@"#01B38B");
    [self.tableView reloadData];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerNib:[UINib nibWithNibName:@"SFSalaryEntryCell" bundle:nil] forCellReuseIdentifier:SFSalaryEntryCellID];
        
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
        UILabel * footerLabel = [UILabel createALabelText:@"薪资规则会影响考勤考核规则的扣分设置" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#999999")];
        footerLabel.frame = CGRectMake(15, 10, kWidth-30, 18);
        [footerView addSubview:footerLabel];
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"确定" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.enabled = NO;
        _saveButton.backgroundColor = Color(@"#D8D8D8");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            [self saveData];
        }];
    }
    return _saveButton;
}

- (void)saveData {
    
    [SFSalaryEntryModel companySetSalaryRule:@{@"salaryRule":self.salaryRule} success:^{
        
        [MBProgressHUD showTipMessageInView:@"设置成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showTipMessageInView:@"设置失败"];
    }];
}

@end
