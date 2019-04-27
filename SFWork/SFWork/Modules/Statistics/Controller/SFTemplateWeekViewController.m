//
//  SFTemplateWeekViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTemplateWeekViewController.h"
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

@interface SFTemplateWeekViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate,SFPickerViewDelegate,SFSelectWeekViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DateTimePickerView *timePickerView;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) SFJournalModel * model;
@property (nonatomic, strong) SFSelectWeekView *selectWeekView;
@property (nonatomic, strong) TemplateModel * smodel;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong)  UILabel * titleLabel;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation SFTemplateWeekViewController
- (NSMutableArray *)items{
    
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setDatas:(NSArray *)datas{
    _datas = datas;
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:datas];
    
}

- (void)setName:(NSString *)name{
    _name = name;
    self.smodel.name = name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    self.smodel = [TemplateModel shareManager];
    self.smodel.remindNotification = YES;
    [self requestData:YES with:YES];
}

- (void)requestData:(BOOL)isOn with:(BOOL)isO{
    
    [self.dataArray removeAllObjects];
    
    [self.dataArray addObjectsFromArray: [SFJournalModel shareReportSetWeekModel:isOn with:isO withM:self.smodel]];
    [self.tableView reloadData];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MyTemplateModelID" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.dataArray removeAllObjects];
        self.smodel = x.object;
        self.name = self.smodel.name;
        [self.items addObjectsFromArray:self.smodel.items];
        [self.dataArray addObjectsFromArray: [SFJournalModel shareReportSetWeekModel:isOn with:isO withM:self.smodel]];
        [self.tableView reloadData];
        
    }];
    
}

- (void)setDrawUI {
    
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = bgColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFSwitchCell" bundle:nil] forCellReuseIdentifier:SFSwitchCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFJournalSetCell" bundle:nil] forCellReuseIdentifier:SFJournalSetCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
    
//    [self.view addSubview:self.saveButton];
//    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.offset(45);
//    }];
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
    
    if (section == 1) {
        return 50;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        NSString * startDate = [NSString getThisWeek:self.smodel.startDate ];
        NSString * endDate = [NSString getThisWeek:self.smodel.endDate];
        self.titleLabel.text = [NSString stringWithFormat:@"每%@ %@:00开始填写本周的汇报，%@ %@:00前提交为正常提交，之后提交为迟交",startDate,self.smodel.startTime,endDate,self.smodel.endTime];
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
            self.smodel.remindContext = text;
        }];
        return cell;
    }
    if (model.type == 1 || model.type == 4) {
        SFSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSwitchCellID forIndexPath:indexPath];
        cell.jmodel = model;
        @weakify(self)
        [cell setSelectClick:^(BOOL isOn) {
            
            @strongify(self)
            self.smodel.remindNotification = isOn;
            if (isOn) {
                [self requestData:YES with:YES];
            }else{
                [self requestData:YES with:NO];
            }
            
        }];
        return cell;
        
    }
    SFJournalSetCell * cell = [tableView dequeueReusableCellWithIdentifier:SFJournalSetCellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
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
            
        case 5:
            [self customArr:@[@"提前1小时提醒",@"提前2小时提醒",@"提前4小时提醒",@"提前8小时提醒"] withRow:indexPath.row];
            break;
        default:
            break;
    }
    
}

- (void)weekClick {
    
    CustomMyPickerView *customVC =[[CustomMyPickerView alloc] initWithComponentDataArray:@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"] titleDataArray:@[@"1:00",@"2:00",@"3:00",@"4:00",@"5:00",@"6:00",@"7:00",@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00"]];
    customVC.getPickerValue = ^(NSString *compoentString, NSString *titileString) {
        NSLog(@"zhelicom is = %@   title = %@",compoentString,titileString);
        if (self.model.type == 2) {
            self.model.destitle = [NSString stringWithFormat:@"%@   %@",compoentString,titileString];
            self.smodel.startDateTimeStr = [NSString stringWithFormat:@"%@ %@",compoentString,titileString];
//            self.smodel.startDate = compoentString ;
//            self.smodel.startTime = [titileString componentsSeparatedByString:@":"][0];
        }
        if (self.model.type == 3) {
            self.model.destitle = [NSString stringWithFormat:@"%@   %@",compoentString,titileString];
            self.smodel.endDateTimeStr = [NSString stringWithFormat:@"%@ %@",compoentString,titileString];
//            self.smodel.endDate = compoentString;
//            self.smodel.endTime = [titileString componentsSeparatedByString:@":"][0];
        }
        [self.tableView reloadData];
    };
    
    [LSKeyWindow addSubview:customVC];
}


- (void)savaJournalSetData{
    
    NSMutableDictionary * dic = (NSMutableDictionary *)[NSString dicFromObject:self.smodel];//[SFJournalModel pramJournalSetDayJson:self.dataArray];
    NSMutableDictionary * dict= dic.mutableCopy;
    NSArray * array = [NSString arrayOrDicWithObject:self.items];
    
    if (array.count == 0 || [self.name isEqualToString:@""]) {
        [UIAlertController alertTitle:@"温馨提示" mesasge:@"请先填写完整资料" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
            
        } viewController:self];
        
        return;
    }
    [dict setObject:array forKey:@"items"];
    [dict setValue:self.smodel.id forKey:@"id"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:@"WEEK" forKey:@"period"];
    [dict setValue:self.departmentId forKey:@"departmentId"];
    NSLog(@"%@",dict);
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFDataReportHttpModel addTemplateDataReport:dict success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"添加失败"];
    }];
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
        self.smodel.remindTime = @"60";
    }
    if ([text isEqualToString:@"提前2小时提醒"]) {
        self.smodel.remindTime = @"120";
    }
    if ([text isEqualToString:@"提前4小时提醒"]) {
        self.smodel.remindTime = @"240";
    }
    if ([text isEqualToString:@"提前8小时提醒"]) {
        self.smodel.remindTime = @"480";
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
