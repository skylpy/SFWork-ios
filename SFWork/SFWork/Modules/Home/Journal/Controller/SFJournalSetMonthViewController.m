//
//  SFJournalSetMonthViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFJournalSetMonthViewController.h"
#import "SFJournalSetCell.h"
#import "SFSwitchCell.h"
#import "SFTextViewCell.h"
#import "SFJournalModel.h"
#import "SFPickerView.h"
#import "SFSelectWeekView.h"
#import "CustomMyPickerView.h"

static NSString * const SFSwitchCellID = @"SFSwitchCellID";
static NSString * const SFJournalSetCellID = @"SFJournalSetCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";

@interface SFJournalSetMonthViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate,SFPickerViewDelegate,SFSelectWeekViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DateTimePickerView *timePickerView;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) SFJournalModel * model;
@property (nonatomic, strong) SFSelectWeekView *selectWeekView;
@property (nonatomic, strong) SFJournalSetModel * smodel;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong)  UILabel * titleLabel;

@end

@implementation SFJournalSetMonthViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    [self requestData:YES with:YES];
}

- (void)requestData:(BOOL)isOn with:(BOOL)isO{
    
    [self.dataArray removeAllObjects];
    self.smodel = [SFJournalSetModel shareManager];
    [self.dataArray addObjectsFromArray: [SFJournalModel shareJournalSetMonthModel:isOn with:isO withM:self.smodel]];
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = bgColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFSwitchCell" bundle:nil] forCellReuseIdentifier:SFSwitchCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFJournalSetCell" bundle:nil] forCellReuseIdentifier:SFJournalSetCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
    }];
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
            [self savaJournalSetData];
        } ];
        
    }
    return _saveButton;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * array = self.dataArray[indexPath.section];
    SFJournalModel * model = array[indexPath.row];
    if (model.type == 6){
        
        return 139;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        return 50;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        
        self.titleLabel.text = [NSString stringWithFormat:@"每天%@开始写当天的日志，当天%@前提交为正常提交，之后提交为迟交",self.smodel.startTime,self.smodel.endTime];
        return self.headerView;
    }
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
    SFJournalModel * model = array[indexPath.row];
    if (model.type == 6) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.jmodel = model;
        @weakify(self)
        [cell setTextChange:^(NSString * _Nonnull text) {
            @strongify(self)
            [SFJournalSetModel shareManager].contentOfMonthly = text;
        }];
        return cell;
    }
    if (model.type == 1 || model.type == 4) {
        SFSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSwitchCellID forIndexPath:indexPath];
        cell.jmodel = model;
        @weakify(self)
        [cell setSelectClick:^(BOOL isOn) {
            @strongify(self)
            if (model.type == 1) {
                
                if (isOn) {
                    [self requestData:YES with:YES];
                }else{
                    [self requestData:NO with:YES];
                }
                
            }else{
                if (isOn) {
                    [self requestData:YES with:YES];
                }else{
                    [self requestData:YES with:NO];
                }
            }
            
        }];
        return cell;
        
    }
    SFJournalSetCell * cell = [tableView dequeueReusableCellWithIdentifier:SFJournalSetCellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)sdfsdf{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * array = self.dataArray[indexPath.section];
    SFJournalModel * model = array[indexPath.row];
    self.model = model;
    switch (model.type) {
        case 2:
            [self weekClick];
            break;
        case 3:
            [self weekClick];
            break;
            
            break;
        case 5:
            [self customArr:@[@"提前1小时提醒",@"提前2小时提醒",@"提前4小时提醒",@"提前8小时提醒"] withRow:indexPath.row];
            break;
        default:
            break;
    }
    
}


- (void)weekClick {
    
    CustomMyPickerView *customVC =[[CustomMyPickerView alloc] initWithComponentDataArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"] titleDataArray:@[@"1:00",@"2:00",@"3:00",@"4:00",@"5:00",@"6:00",@"7:00",@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00"]];
    customVC.getPickerValue = ^(NSString *compoentString, NSString *titileString) {
        NSLog(@"zhelicom is = %@   title = %@",compoentString,titileString);
        if (self.model.type == 2) {
            self.model.destitle = [NSString stringWithFormat:@"%@号   %@",compoentString,titileString];
            self.smodel.monthlyStartDate = compoentString;
            self.smodel.monthlyStartTime = titileString;
        }
        if (self.model.type == 3) {
            self.model.destitle = [NSString stringWithFormat:@"%@号   %@",compoentString,titileString];
            self.smodel.monthlyEndDate = compoentString;
            self.smodel.monthlyEndTime = titileString;
        }
        [self.tableView reloadData];
    };
    
    [LSKeyWindow addSubview:customVC];
}

- (UIView *)headerView {
    
    if (!_headerView) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        _headerView = headerView;
        UILabel * titleLabel = [UILabel createALabelText:[NSString stringWithFormat:@"每天%@开始写当天的日志，当天%@前提交为正常提交，之后提交为迟交",self.smodel.startTime,self.smodel.endTime] withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#999999")];
        titleLabel.numberOfLines = 2;
        _titleLabel = titleLabel;
        [headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(10);
            make.top.equalTo(headerView.mas_top).offset(5);
            make.right.equalTo(headerView.mas_right).offset(-10);
            make.bottom.equalTo(headerView.mas_bottom).offset(-5);
        }];
    }
    return _headerView;
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
    self.smodel.days = valueArray;
    [self.tableView reloadData];
    //    NSLog(@"%@",array);
}

- (void)savaJournalSetData{
    
    NSMutableDictionary * dic = (NSMutableDictionary *)[NSString dicFromObject:self.smodel];//[SFJournalModel pramJournalSetDayJson:self.dataArray];
    NSMutableDictionary * dict= dic.mutableCopy;
    
    
    [dict removeObjectForKey:@"_id"];
    [dict setValue:self.smodel._id forKey:@"id"];
    [dict setValue:@"MONTHLY" forKey:@"dailyType"];
    
    
    NSLog(@"%@",dict);
    
    
    [SFJournalHttpModel updateDailySettings:dict success:^{
        
        [MBProgressHUD showSuccessMessage:@"月报设置成功"];
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showErrorMessage:@"月报设置失败"];
    }];
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
    if ([text isEqualToString:@"提前1小时提醒"]) {
        self.smodel.remindTimeOfMonthly = @"1";
    }
    if ([text isEqualToString:@"提前2小时提醒"]) {
        self.smodel.remindTimeOfMonthly = @"2";
    }
    if ([text isEqualToString:@"提前4小时提醒"]) {
        self.smodel.remindTimeOfMonthly = @"4";
    }
    if ([text isEqualToString:@"提前8小时提醒"]) {
        self.smodel.remindTimeOfMonthly = @"8";
    }
}

- (void)selectTime:(DatePickerViewMode)type{
    
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    self.timePickerView = pickerView;
    pickerView.delegate = self;
    pickerView.pickerViewMode = type;
    [LSKeyWindow addSubview:pickerView];
    [pickerView showDateTimePickerView];
}
#pragma mark - delegate

- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSLog(@"%@",date);
    self.model.destitle = date;
    if (self.model.type == 2) {
        self.smodel.startTime = date;
    }
    if (self.model.type == 3) {
        self.smodel.endTime = date;
    }
    [self.tableView reloadData];
}
@end
