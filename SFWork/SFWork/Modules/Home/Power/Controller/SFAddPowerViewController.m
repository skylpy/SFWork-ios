//
//  SFAddPowerViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddPowerViewController.h"
#import "SFSelectDepViewController.h"
#import "SFSelectDepEmpViewController.h"
#import "SFPowerAssignViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFPowerModel.h"
#import "SFAddPowerCell.h"

static NSString * const SFAddPowerCellID = @"SFAddPowerCellID";

@interface SFAddPowerViewController ()<UITableViewDelegate,UITableViewDataSource,SFSelectDepViewControllerDelagete,DateTimePickerViewDelegate,SFSuperSuborViewControllerDelagete>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray *selectPermission;
@property (nonatomic, strong) DateTimePickerView *timePickerView;
@property (nonatomic, strong) UIButton * saveButton;
@property (nonatomic, strong) SFPowerModel * pmodel;
@property (nonatomic, assign) BOOL isselectDep;
@property (nonatomic, strong) SFOrgListModel *depModel;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@end

@implementation SFAddPowerViewController

- (NSMutableArray *)selectPermission{
    
    if (!_selectPermission) {
        _selectPermission = [NSMutableArray array];
    }
    return _selectPermission;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加部门管理员";
    [self initDrawUI];
    
    [self requestData:self.model];
}


- (void)requestData:(SFPowerListModel *)model {
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray: [SFPowerModel shareAddPowerModel:model withType:self.type]];
    [self.tableView reloadData];
}


-(void)initDrawUI {
    
    self.isselectDep = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    if (self.model) {
        
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
        
        UIButton * footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        footerButton.frame = CGRectMake(0, 10, kWidth, 45);
        [footerButton setTitle:@"删除" forState:UIControlStateNormal];
        [footerButton setTitleColor:Color(@"#FF715A") forState:UIControlStateNormal];
        footerButton.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        footerButton.backgroundColor = Color(@"#FFFFFF");
        [footerView addSubview:footerButton];
        
        @weakify(self)
        [[footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self deleteThisItem];
        }];
        self.tableView.tableFooterView = footerView;
    }
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self.view);
        make.height.offset(43);
    }];
}

- (void)deleteThisItem {
    
    [SFPowerHttpModel deletePermissioneUser:self.model._id success:^{
        
        [MBProgressHUD showSuccessMessage:@"删除成功！"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showErrorMessage:@"s删除失败"];
    }];
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFAddPowerCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddPowerCellID forIndexPath:indexPath];
    SFPowerModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFPowerModel * pmodel = self.dataArray[indexPath.section];
    self.pmodel = pmodel;
    
    if ([pmodel.type isEqualToString:@"3"]) {
        //选择权限
        SFPowerAssignViewController * vc = [SFPowerAssignViewController new];
        vc.model = self.model;
        vc.type = self.type;
        @weakify(self)
        [vc setSelectAllClick:^(NSArray * _Nonnull list) {
            @strongify(self)
            [self.selectPermission addObjectsFromArray:list];
            self.pmodel.placeholder = [NSString stringWithFormat:@"已分配%ld项权限",list.count];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (self.model) return;
    if ([pmodel.type isEqualToString:@"1"]) {
        if ([self.type isEqualToString:@"DEPARTMENT"]) {
            
            //选择人员
            if (self.isselectDep) {
                SFSelectDepEmpViewController * vc = [SFSelectDepEmpViewController new];
                vc.type = singleType;
                vc.orgModel = self.depModel;
                @weakify(self)
                [vc setSelectEmoClick:^(SFEmployeesModel * _Nonnull model) {
                    @strongify(self)
                    self.pmodel.placeholder = model.name;
                    self.personId = model._id;
                    [self.tableView reloadData];
                }];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [UIAlertController alertTitle:@"温情提示" mesasge:@"请先选择部门！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
                    
                    
                } viewController:self];
            }
        }else{
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.delagete = self;
            vc.type = singleType;
            vc.isSubor = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    if ([pmodel.type isEqualToString:@"2"]) {
        //选择部门
        SFSelectDepViewController * vc = [SFSelectDepViewController new];
        vc.delagete = self;
        vc.type = singleDepType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([pmodel.type isEqualToString:@"4"]) {
        [self selectTime:DatePickerViewDateTimeMode];
    }
    if ([pmodel.type isEqualToString:@"5"]) {
        [self selectTime:DatePickerViewDateTimeMode];
    }
    
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    self.pmodel.placeholder = employee.name;
    self.personId = employee._id;
    [self.tableView reloadData];
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
    self.pmodel.placeholder = date;
    
    if ([self.pmodel.type isEqualToString:@"4"]) {
        
        self.startTime = date;
    }
    if ([self.pmodel.type isEqualToString:@"5"]) {
        
        self.endTime = date;
    }
    [self.tableView reloadData];
    
}

//单选
- (void)singleSelectEmoloyee:(SFOrgListModel *)employee{
    
    self.isselectDep = YES;
    self.depModel = employee;
    self.pmodel.placeholder = employee.name;
    [self.tableView reloadData];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFAddPowerCell" bundle:nil] forCellReuseIdentifier:SFAddPowerCellID];
        
        
    }
    return _tableView;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.backgroundColor = Color(@"#01B38B");
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            [self saveData];
        }];
    }
    return _saveButton;
}

- (void)saveData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (self.selectPermission.count == 0) {
        
        [UIAlertController alertTitle:@"温情提示" mesasge:@"请先选择权限！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
        
        } viewController:self];
        return;
    }
    
    if ([self.type isEqualToString:@"DEPARTMENT"]) {
        
        if (!self.depModel._id) {
            [UIAlertController alertTitle:@"温情提示" mesasge:@"请先选择部门！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
                
            } viewController:self];
            return;
        }
        [dict setValue:self.depModel._id forKey:@"departmentId"];
    }
    
    if (!self.personId) {
        [UIAlertController alertTitle:@"温情提示" mesasge:@"请先选择员工！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
            
        } viewController:self];
        return;
    }
    if ([self.type isEqualToString:@"TEMPORARY"]) {
        
        if (!self.startTime||!self.endTime) {
            [UIAlertController alertTitle:@"温情提示" mesasge:@"请先选择开始或结束时间！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
                
            } viewController:self];
            return;
        }
        [dict setValue:self.startTime forKey:@"startTime"];
        [dict setValue:self.endTime forKey:@"endTime"];
    }
    
    [dict setObject:self.selectPermission forKey:@"permissions"];
    [dict setValue:self.type forKey:@"type"];
    
    [dict setValue:self.personId forKey:@"employeeId"];
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFPowerHttpModel addPermissioneUser:dict success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"授权成功"];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"授权失败"];
    }];
}


@end
