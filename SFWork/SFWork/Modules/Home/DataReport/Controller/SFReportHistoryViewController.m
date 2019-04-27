//
//  SFReportHistoryViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFReportHistoryViewController.h"
#import "SFReportDateilViewController.h"
#import "SFDataReportHttpModel.h"
#import "SFDateTimePickerView.h"
#import "SFReportListCell.h"

static NSString * const SFReportListCellID = @"SFReportListCellID";

@interface SFReportHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,SFDateTimePickerViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) SFDateTimePickerView *timePickerView;
@property (nonatomic, copy) NSString *searchStartDate;
@property (nonatomic, copy) NSString *searchEndDate;

@end

@implementation SFReportHistoryViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史记录";
    [self setDrawUI];
    
    [self requestData];
}

- (void)requestData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@"1" forKey:@"pageNum"];
    [dict setValue:@"20" forKey:@"pageSize"];
    [dict setValue:self.searchStartDate forKey:@"searchStartDate"];
    [dict setValue:self.searchEndDate forKey:@"searchEndDate"];
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFDataReportHttpModel getMyHistoryDataReport:dict success:^(NSArray<SFTemplateModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    self.searchStartDate = @"";
    self.searchEndDate = @"";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 221;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFReportListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFReportListCellID forIndexPath:indexPath];
    
    SFTemplateModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFTemplateModel * model = self.dataArray[indexPath.section];
    SFReportDateilViewController * vc = [SFReportDateilViewController new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFReportListCell" bundle:nil] forCellReuseIdentifier:SFReportListCellID];
        
    }
    return _tableView;
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"时间筛选" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            [self selectTime:DatePickerViewDateMode];
        }];
    }
    return _rightButton;
}

- (void)selectTime:(DatePickerViewMode)type{
    
    SFDateTimePickerView *pickerView = [[SFDateTimePickerView alloc] init];
    self.timePickerView = pickerView;
    pickerView.delegate = self;
    pickerView.pickerViewMode = type;
    [LSKeyWindow addSubview:pickerView];
    [pickerView showDateTimePickerView];
}

#pragma mark - delegate

-(void)didClickFinishDateTimePickerViewStart:(NSString*)startDate withEnd:(NSString *)endDate{
    
    NSLog(@"%@   %@",startDate,endDate);
    self.searchStartDate = startDate;
    self.searchEndDate = endDate;
    
    [self requestData];
}


@end
