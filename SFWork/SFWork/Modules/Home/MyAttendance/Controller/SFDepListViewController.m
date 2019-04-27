//
//  SFDepListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFDepListViewController.h"
#import "SFAttendanceRecordViewController.h"
#import "SFStatisticsPersonCell.h"
#import "SFMyAttendanceHttpModel.h"
static NSString * const SFStatisticsPersonCellID = @"SFStatisticsPersonCellID";

@interface SFDepListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *selectDepView;
@property (weak, nonatomic) IBOutlet UILabel *depNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFDepListViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.atype isEqualToString:@"LATE"]?@"迟到统计":
    [self.atype isEqualToString:@"EARLY"]?@"早退统计":
    [self.atype isEqualToString:@"MISSING"]?@"漏卡统计":
    [self.atype isEqualToString:@"LATES"]?@"外出统计":
    [self.atype isEqualToString:@"LEAVE"]?@"请假统计":
    [self.atype isEqualToString:@"BUSINESS_TRAVEL"]?@"出差统计":@"加班统计";
    self.date = [NSDate dateWithFormat:@"yyyy-MM-dd"];
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.date forKey:@"qCreateTime"];
    [dict setValue:self.type forKey:@"type"];
    if (self.isAtten) {
        [dict setValue:self.atype forKey:@"attendanceStatus"];
    }else{
        [dict setValue:self.atype forKey:@"applicationType"];
    }
    
    [MBProgressHUD showActivityMessageInView:@""];
    if (self.isAtten) {
        [SFMyAttendanceHttpModel attendanceStatisticsByChecks:dict success:^(NSArray<AttendanceStatisticsModel *> * _Nonnull list) {
            [MBProgressHUD hideHUD];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:list];
            [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
        }];
    }else{
        [SFMyAttendanceHttpModel attendanceStatisticsByApprovals:dict success:^(NSArray<AttendanceStatisticsModel *> * _Nonnull list) {
            [MBProgressHUD hideHUD];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:list];
            [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
        }];
    }
    
    
    
}


- (void)setDrawUI {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SFStatisticsPersonCell" bundle:nil] forCellReuseIdentifier:SFStatisticsPersonCellID];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFStatisticsPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:SFStatisticsPersonCellID forIndexPath:indexPath];
    AttendanceStatisticsModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AttendanceStatisticsModel * model = self.dataArray[indexPath.row];
    SFAttendanceRecordViewController * vc = [SFAttendanceRecordViewController new];
    vc.userId = model.employeeId;
    vc.username = model.name;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
