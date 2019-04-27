
//
//  SFPunchCardRecordViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPunchCardRecordViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFMyAttendanceHttpModel.h"
#import "SFPunchCardRecordCell.h"

static NSString * const SFPunchCardRecordCellID = @"SFPunchCardRecordCellID";

@interface SFPunchCardRecordViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate,SFSuperSuborViewControllerDelagete>
@property (weak, nonatomic) IBOutlet UILabel *empNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *selectEmpView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *selectDateView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *date;

@end

@implementation SFPunchCardRecordViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"打卡记录";
    [self setDrawUI];
    [self requestData:[SFInstance shareInstance].userInfo._id withDate:[NSDate dateWithFormat:@"yyyy-MM-dd"]];
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
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;

    [self.tableView registerNib:[UINib nibWithNibName:@"SFPunchCardRecordCell" bundle:nil] forCellReuseIdentifier:SFPunchCardRecordCellID];
    
    self.empNameLabel.text = [SFInstance shareInstance].userInfo.name;
    self.userId = [SFInstance shareInstance].userInfo._id;
    self.date = [NSDate dateWithFormat:@"yyyy-MM-dd"];
    self.dateLabel.text = [NSDate dateWithFormat:@"yyyy-MM-dd"];
    @weakify(self)
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        
        if (!isEmployee) {
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.isSubor = YES;
            vc.delagete = self;
            vc.type = singleType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [self.selectEmpView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] init];
    [[tapGesture1 rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self selectTime:DatePickerViewDateMode];
    }];
    [self.selectDateView addGestureRecognizer:tapGesture1];
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    
    self.empNameLabel.text = employee.name;
    self.userId = employee._id;
    [self requestData:self.userId  withDate:self.date];
}

- (void)selectTime:(DatePickerViewMode)type{
    
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
 
    pickerView.delegate = self;
    pickerView.pickerViewMode = type;
    [LSKeyWindow addSubview:pickerView];
    [pickerView showDateTimePickerView];
}
#pragma mark - delegate

- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSLog(@"%@",date);
    self.dateLabel.text = date;
    self.date = date;
    [self requestData:self.userId  withDate:self.date];
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

@end
