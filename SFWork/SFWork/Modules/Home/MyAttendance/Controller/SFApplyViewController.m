//
//  SFApplyViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFApplyViewController.h"
#import "SFTemplateListCell.h"
#import "SFLeaveApplicationViewController.h"
#import "SFTripApplicationViewController.h"
#import "SFOvertimeApplicationViewController.h"

static NSString * const SFTemplateListCellID = @"SFTemplateListCellID";

@interface SFApplyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFApplyViewController


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置汇报模板";
    
    [self setDrawUI];
    [self initData];
}

- (void)initData {
    
    NSDictionary * dict1 = @{@"icon":@"icon_leave_request_black",@"name":@"请假申请"};
    NSDictionary * dict2 = @{@"icon":@"icon_to_apply_for_business_trip_black",@"name":@"出差申请"};
    NSDictionary * dict3 = @{@"icon":@"icon_request_for_overtime_black",@"name":@"加班申请"};
    [self.dataArray addObject:dict1];
    [self.dataArray addObject:dict2];
    [self.dataArray addObject:dict3];
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.top.left.right.equalTo(self.view);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFTemplateListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTemplateListCellID forIndexPath:indexPath];
    NSDictionary * dict = self.dataArray[indexPath.row];
    cell.dict = dict;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        SFLeaveApplicationViewController * vc = [SFLeaveApplicationViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        
        SFTripApplicationViewController * vc = [SFTripApplicationViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        
        SFOvertimeApplicationViewController * vc = [SFOvertimeApplicationViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFTemplateListCell" bundle:nil] forCellReuseIdentifier:SFTemplateListCellID];
    }
    return _tableView;
}


@end
