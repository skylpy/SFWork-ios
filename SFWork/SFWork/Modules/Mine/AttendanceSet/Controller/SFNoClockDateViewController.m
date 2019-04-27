//
//  SFNoClockDateViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFNoClockDateViewController.h"
#import "SFAttendanceRulesViewController.h"
#import "SFAttendanceSetHttpModel.h"
#import "SFAttendanceSetModel.h"

static NSString * const SFAttendanceRulesCellID = @"SFAttendanceRulesCellID";

@interface SFNoClockDateViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) SFAttendanceSetModel * model;
@end

@implementation SFNoClockDateViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"不打卡日期";
    [self initData];
    [self setDrawUI];
}

- (void)initData {
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[SFAttendanceSetModel shareNoClickTimeModel]];
    
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.top.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    if (section == 0||section == self.dataArray.count-1) {
        
        return 10;
    }
    
    if (section == self.dataArray.count-2) {
        
        return 0.01;
    }
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0||section == self.dataArray.count-1||section == self.dataArray.count-2) {
        
        return [UIView new];
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    
    UILabel * titleLabel = [UILabel createALabelText:@"上下班时段" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#999999")];
    
    titleLabel.frame = CGRectMake(15, 10, kWidth-30, 15);
    [headerView addSubview:titleLabel];
    UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:Color(@"#FF715A") forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont fontWithName:kRegFont size:13];
    [headerView addSubview:deleteButton];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(headerView.mas_right).offset(-15);
        make.width.height.offset(40);
        make.centerY.equalTo(headerView);
    }];
    
    @weakify(self)
    [[deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.dataArray removeObjectAtIndex:section];
        [self.tableView reloadData];
    }];
    return headerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFAttendanceSetModel * model = array[indexPath.row];
    
    SFAttendanceRulesCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAttendanceRulesCellID forIndexPath:indexPath];
    cell.model = model;
    if (model.type == 3) {
        cell.iconImage.hidden = YES;
    }else{
        cell.iconImage.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFAttendanceSetModel * model = array[indexPath.row];
    self.model = model;
    if (model.type == 2) {
        [self selectTime:DatePickerViewDateMode];
    }
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
    self.model.destitle = date;
    
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerClass:[SFAttendanceRulesCell class] forCellReuseIdentifier:SFAttendanceRulesCellID];
    }
    return _tableView;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"提交" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#01B38B");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)

            NSMutableDictionary * dicts = [NSMutableDictionary dictionary];
            
            for (NSArray * array in self.dataArray) {
                
                for (SFAttendanceSetModel * model in array) {
                    if (model.type == 2) {
                        [dicts setValue:model.destitle forKey:@"specialDate"];
                    }
                    if (model.type == 3) {
                        [dicts setValue:model.destitle forKey:@"reason"];
                    }
                }
            }
            [dicts setValue:@"NOCHECK" forKey:@"specialDateType"];
            NSLog(@"====%@",dicts);
            //            NSArray * arr = [NSArray modelArrayWithClass:[AttendanceTimeModel class] json:arrays];
            SpecialDateModel * model = [SpecialDateModel modelWithJSON:dicts];
            //            model.attendanceTimeDTOList = arr;
            !self.addTimeClick?:self.addTimeClick(model);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _saveButton;
}


@end
