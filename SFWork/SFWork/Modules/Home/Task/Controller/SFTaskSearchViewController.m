//
//  SFTaskSearchViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/20.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTaskSearchViewController.h"
#import "SFAddTaskViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFDateTimePickerView.h"
#import "SFTaskHttpModel.h"
#import "SFSetTypeModel.h"
#import "SFPickerView.h"
#import "SFTaskModel.h"


static NSString * const SFAddTaskCellID = @"SFAddTaskCellID";

@interface SFTaskSearchViewController ()<UITableViewDelegate,UITableViewDataSource,SFPickerViewDelegate,SFDateTimePickerViewDelegate,SFSuperSuborViewControllerDelagete>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) NSMutableArray *taskArray;
@property (nonatomic, strong) SFTaskModel * model;

@property (nonatomic, strong) SFDateTimePickerView *timePickerView;
@property (nonatomic, copy) NSString *createStartTime;
@property (nonatomic, copy) NSString *createEndTime;

@property (nonatomic, copy) NSString *endStartTime;
@property (nonatomic, copy) NSString *endEndTime;
@end

@implementation SFTaskSearchViewController

- (NSMutableArray *)taskArray{
    
    if (!_taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详细搜索";
    [self setDrawUI];
    [self getData];
    [self initData];
}

- (void)initData{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    [SFSetTypeModel getCompanySetting:@"TASK_TYPE" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.taskArray removeAllObjects];
        [self.taskArray addObjectsFromArray:list];
        
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)getData {
    
    [self.dataArray addObjectsFromArray:[SFTaskModel shareTaskSearchModel]];
    [self.tableView reloadData];
    
}

- (void)setDrawUI {
    
    self.createStartTime = @"";
    self.createEndTime = @"";
    self.endStartTime = @"";
    self.endEndTime = @"";
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SFAddTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddTaskCellID forIndexPath:indexPath];
    SFTaskModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFTaskModel * model = self.dataArray[indexPath.row];
    self.model = model;
    
    switch (model.type) {
        case 2:
        {
            //客户类型
            NSMutableArray * array = [NSMutableArray array];
            for (SFSetTypeModel * model in self.taskArray) {
                [array addObject:model.name];
            }
            [self customArr:array withRow:indexPath.row];
        }
            break;
        case 3:
            [self selectTime:DatePickerViewDateMode];
            break;
        case 4:
            [self selectTime:DatePickerViewDateMode];
            break;
        case 5:
            [self customArr:@[@"非常紧急",@"紧急",@"普通"] withRow:indexPath.row];
            break;
        case 6:
        {
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.isSubor = NO;
            vc.delagete = self;
            vc.type = singleType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.isSubor = NO;
            vc.delagete = self;
            vc.type = singleType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:
        {
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.isSubor = YES;
            vc.delagete = self;
            vc.type = singleType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    
    self.model.destitle = employee.name;
    self.model.value = employee._id;
    
    [self.tableView reloadData];
}

- (void)customArr:(NSArray *)array withRow:(NSInteger)row{
    
    SFPickerView *picker = [[SFPickerView alloc] initWithFrame:self.view.bounds];
    picker.delegate = self ;
    picker.row = row;
    picker.customArr = array;
    [LSKeyWindow addSubview:picker];
}
#pragma mark- SFPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text withRow:(NSInteger)row withSelectIndex:(NSInteger)selectIndex{
    
    self.model.destitle = text;
    NSInteger index = [pickerView selectedRowInComponent:0];
    if (self.model.type == 2) {
        SFSetTypeModel * model = self.taskArray[row-1];
        self.model.value = model._id;
    }
    [self.tableView reloadData];
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
    
    self.model.destitle = [NSString stringWithFormat:@"%@至%@",startDate,endDate];
    if (self.model.type == 3) {
        self.createStartTime = startDate;
        self.createEndTime = endDate;
    }
    if (self.model.type == 4) {
        self.endStartTime = startDate;
        self.endEndTime = endDate;
    }
    [self.tableView reloadData];
}

- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSLog(@"%@",date);
    self.model.destitle = date;
    //    self.qCreateTime = date;
    if (self.model.type == 2) {
        //        self.smodel.startTime = date;
    }
    if (self.model.type == 3) {
        //        self.smodel.endTime = date;
    }
    [self.tableView reloadData];
    
    //    [self getSearchDailyLists];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFAddTaskCell class] forCellReuseIdentifier:SFAddTaskCellID];
    }
    return _tableView;
}


- (UIButton *)saveButton{
    
    if (!_saveButton) {
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(0, 0, 60, 30);
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        [_saveButton setTitle:@"搜索" forState:UIControlStateNormal];
        _saveButton.backgroundColor = defaultColor;
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            [self searchButton];
        }];
    }
    return _saveButton;
}

- (void)searchButton {
    
    NSMutableDictionary * dict = [SFTaskModel pramTaskSearchJson:self.dataArray];
    [dict setValue:self.createStartTime forKey:@"createStartTime"];
    [dict setValue:self.createEndTime forKey:@"createEndTime"];
    [dict setValue:self.endStartTime forKey:@"endStartTime"];
    [dict setValue:self.endEndTime forKey:@"endEndTime"];
    
    [SFTaskHttpModel searchOfficeTask:dict success:^(NSArray<TaskListModel *> * _Nonnull list) {
        
        NSLog(@"%@",list);
        !self.taskSearchClick?:self.taskSearchClick(list);
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
}

@end
