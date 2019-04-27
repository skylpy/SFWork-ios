//
//  SFAttendanceSetViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttendanceSetViewController.h"
#import "SFAttendanceRulesViewController.h"
#import "SFAttendanceSetHttpModel.h"
#import "SFAttendanceListCell.h"

static NSString * const SFAttendanceListCellID = @"SFAttendanceListCellID";

@interface SFAttendanceSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation SFAttendanceSetViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"考勤设置";
    
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    [MBProgressHUD showActivityMessageInView:@""];
    [SFAttendanceSetHttpModel getTemplateListSuccess:^(NSArray<SFAttendanceModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.top.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(55);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-52);
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 247;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFAttendanceListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAttendanceListCellID forIndexPath:indexPath];
    SFAttendanceModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFAttendanceModel * model = self.dataArray[indexPath.section];
    UIViewController * vc = [NSClassFromString(@"SFAttendanceRulesViewController") new];
    [vc setValue:model forKey:@"smodel"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)addButton{
    
    if (!_addButton) {
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"btn_oval_add_green"] forState:UIControlStateNormal];
        @weakify(self)
        [[_addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            SFAttendanceRulesViewController * vc = [NSClassFromString(@"SFAttendanceRulesViewController") new];
            @weakify(self)
            [vc setReduceClick:^{
                @strongify(self)
                [self requestData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _addButton;
}


- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFAttendanceListCell" bundle:nil] forCellReuseIdentifier:SFAttendanceListCellID];
        
    }
    return _tableView;
}

@end
