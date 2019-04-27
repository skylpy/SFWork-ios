//
//  SFSpecialTimeViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSpecialTimeViewController.h"
#import "SFAttendanceRulesViewController.h"
#import "SFAttendanceSetHttpModel.h"
#import "SFLimitPunchViewController.h"
#import "SFSelectWeekView.h"
#import "SFAttendanceSetModel.h"
#import "SFAddPunchTimeCell.h"
#import "SFPickerView.h"

static NSString * const SFAttendanceRulesCellID = @"SFAttendanceRulesCellID";
static NSString * const SFAddPunchTimeCellID = @"SFAddPunchTimeCellID";

@interface SFSpecialTimeViewController ()<UITableViewDelegate,UITableViewDataSource,SFSelectWeekViewDelegate,DateTimePickerViewDelegate,SFPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) SFSelectWeekView *selectWeekView;
@property (nonatomic, strong) SFAttendanceSetModel * model;
@property (nonatomic, strong) NSMutableArray *days;


@end

@implementation SFSpecialTimeViewController


- (NSMutableArray *)days{
    
    if (!_days) {
        _days = [NSMutableArray array];
    }
    return _days;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑打卡时间";
    [self initData];
    [self setDrawUI];
}

- (void)initData {
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[SFAttendanceSetModel shareSpecialTimeModel]];
    
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
    
    if (model.type == 4) {
        SFAddPunchTimeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddPunchTimeCellID forIndexPath:indexPath];
        
        return cell;
    }
    
    SFAttendanceRulesCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAttendanceRulesCellID forIndexPath:indexPath];
    cell.model = model;
    if (model.type == 6) {
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
    switch (model.type) {
        case 5:
            [self selectTime:DatePickerViewDateMode];
            break;
        case 2:
            [self selectTime:DatePickerViewTimeMode];
            break;
        case 3:
            [self selectTime:DatePickerViewTimeMode];
            break;
        case 4:
        {
            [self.dataArray insertObject:[SFAttendanceSetModel addPunchTimeSection] atIndex:self.dataArray.count-2];
            [self.tableView reloadData];
        }
            break;
       
        default:
            break;
    }
    
}


- (void)customArr:(NSArray *)array withRow:(NSInteger)row{
    SFPickerView *picker = [[SFPickerView alloc] initWithFrame:self.view.bounds];
    picker.delegate = self ;
    picker.row = row;
    picker.customArr = array;
    [LSKeyWindow addSubview:picker];
}

#pragma SFPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text withRow:(NSInteger)row withSelectIndex:(NSInteger)selectIndex{
    
    [self.tableView reloadData];
    self.model.destitle = text;
    
    if (self.model.type == 9){
        if ([text isEqualToString:@"30分钟"]) {
            self.model.value = @"30";
        }
        if ([text isEqualToString:@"1小时"]) {
            self.model.value = @"60";
        }
        if ([text isEqualToString:@"2小时"]) {
            self.model.value = @"120";
        }
        if ([text isEqualToString:@"3小时"]) {
            self.model.value = @"180";
        }
        
    }else{
        if ([text isEqualToString:@"0分钟"]) {
            self.model.value = @"0";
        }
        if ([text isEqualToString:@"10分钟"]) {
            self.model.value = @"10";
        }
        if ([text isEqualToString:@"20分钟"]) {
            self.model.value = @"20";
        }
        if ([text isEqualToString:@"30分钟"]) {
            self.model.value = @"30";
        }
        if ([text isEqualToString:@"40分钟"]) {
            self.model.value = @"40";
        }
        if ([text isEqualToString:@"50分钟"]) {
            self.model.value = @"50";
        }
        if ([text isEqualToString:@"60分钟"]) {
            self.model.value = @"60";
        }
        if ([text isEqualToString:@"5分钟"]) {
            self.model.value = @"5";
        }
    }
    
}

- (void)selectWeek{
    
    _selectWeekView = [SFSelectWeekView shareSFSelectWeekView];
    self.selectWeekView.data = [SFSelectWeekModel manageSelectWeekModel];
    _selectWeekView.delegate = self;
    [LSKeyWindow addSubview:self.selectWeekView];
    _selectWeekView.frame = LSKeyWindow.bounds;
    [_selectWeekView showView];
    
}

#pragma SFSelectWeekView
- (void)selectWeekValueArr:(NSArray *)valueArray withTitleArr:(NSArray *)titleArray{
    
    NSString * title = @"";
    for (int i = 0; i < titleArray.count; i ++) {
        
        if (i == 0) {
            title = titleArray[i];
        }else{
            title = [NSString stringWithFormat:@"%@,%@",title,titleArray[i]];
        }
    }
    self.model.destitle = title;
    
    [self.days removeAllObjects];
    [self.days addObjectsFromArray:valueArray];
    self.model.persons = self.days;
    [self.tableView reloadData];
    //    NSLog(@"%@",array);
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
        [_tableView registerNib:[UINib nibWithNibName:@"SFAddPunchTimeCell" bundle:nil] forCellReuseIdentifier:SFAddPunchTimeCellID];
        
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
            
            
            NSMutableArray * arrays = [NSMutableArray array];
            NSMutableDictionary * dicts = [NSMutableDictionary dictionary];
            for (int i = 0;i < self.dataArray.count;i++) {
                NSArray * array = self.dataArray[i];
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                for (SFAttendanceSetModel * model in array) {
                    
                    if (model.type == 2) {
                        [dict setValue:@"" forKey:@"attendanceDateId"];
                        [dict setValue:@(i) forKey:@"timeNumber"];
                        [dict setValue:model.destitle forKey:@"startTime"];
                    }
                    if (model.type == 3) {
                        [dict setValue:model.destitle forKey:@"endTime"];
                    }
                    
                    if (model.type == 5) {
                        [dicts setValue:model.destitle forKey:@"specialDate"];
                    }
                    if (model.type ==6) {
                        [dicts setValue:model.destitle forKey:@"reason"];
                    }
                   
                    
                }
                if (dict.count > 0) {
                    
                    [arrays addObject:dict];
                }
                
                [dicts setObject:arrays forKey:@"attendanceTimeDTOList"];
                
            }
            [dicts setValue:@"CHECKIN" forKey:@"specialDateType"];
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
