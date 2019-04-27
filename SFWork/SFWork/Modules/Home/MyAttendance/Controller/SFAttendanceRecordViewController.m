//
//  SFAttendanceRecordViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/24.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttendanceRecordViewController.h"
#import "SFPunchCardRecordCell.h"

static NSString * const SFPunchCardRecordCellID = @"SFPunchCardRecordCellID";

@interface SFAttendanceRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFAttendanceRecordViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@的打卡记录",self.username];
    [self setDrawUI];
    [self requestData:self.userId withDate:[NSDate dateWithFormat:@"yyyy-MM-dd"]];
}

- (void)requestData:(NSString *)userId withDate:(NSString *)date {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:userId forKey:@"employeeId"];
    [dict setValue:date forKey:@"qCreateTime"];
    
    [MBProgressHUD showActivityMessageInView:@""];
    [SFMyAttendanceHttpModel getPunchCarkRecord:dict success:^(NSArray<MyAttendanceGetRecord *> * _Nonnull list) {
        
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
        
        make.edges.equalTo(self.view);
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFPunchCardRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPunchCardRecordCellID forIndexPath:indexPath];
    MyAttendanceGetRecord * model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.upLineView.hidden = NO;
    cell.downLineView.hidden = NO;
    if (indexPath.row == 0 ) {
        cell.upLineView.hidden = YES;
    }
    if (indexPath.row == self.dataArray.count-1) {
        cell.downLineView.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyAttendanceGetRecord * model = self.dataArray[indexPath.row];
    
    UIViewController * vc = [[UIStoryboard storyboardWithName:@"MyAttendance" bundle:nil] instantiateViewControllerWithIdentifier:@"SFPunchCardDateil"];
    [vc setValue:model._id forKey:@"p_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerNib:[UINib nibWithNibName:@"SFPunchCardRecordCell" bundle:nil] forCellReuseIdentifier:SFPunchCardRecordCellID];
    }
    return _tableView;
}

@end
