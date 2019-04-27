//
//  SFAssessmentRuleViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAssessmentRuleViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFAssessmentSetModel.h"
#import "SFAddAssessmentCell.h"
#import "SFAssessmentItemCell.h"
#import "SFAssessSelectEmpCell.h"
#import "SFAddDataFooterView.h"
#import "SFWorkAssessHttpModel.h"
#import "SFPickerView.h"
#import "SFSwitchCell.h"
#import "SFTipDesView.h"

static NSString * const SFAssessmentRuleCellID = @"SFAssessmentRuleCellID";
static NSString * const SFAddAssessmentCellID = @"SFAddAssessmentCellID";
static NSString * const SFAssessmentItemCellID = @"SFAssessmentItemCellID";
static NSString * const SFAssessSelectEmpCellID = @"SFAssessSelectEmpCellID";
static NSString * const SFSwitchCellID = @"SFSwitchCellID";

@interface SFAssessmentRuleViewController ()<UITableViewDelegate,UITableViewDataSource,SFPickerViewDelegate,DateTimePickerViewDelegate,SFAllEmployeeViewControllerDelagete>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SFTipDesView *tipDesView;
@property (nonatomic, strong) SFAddDataFooterView *footerView;
@property (nonatomic, strong) SFAssessmentSetModel * model;
@property (nonatomic, strong) NSMutableArray *copyArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *employeeIds;

@property (nonatomic, strong) ItemSubListModel *item;

@end

@implementation SFAssessmentRuleViewController

- (NSMutableArray *)employeeIds{
    
    if (!_employeeIds) {
        _employeeIds = [NSMutableArray array];
    }
    return _employeeIds;
}

- (NSMutableArray *)itemArray{
    
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (SFAddDataFooterView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [SFAddDataFooterView shareSFAddDataFooterView];
        [_footerView.cancelButton setTitle:@"删除" forState:UIControlStateNormal];
    }
    return _footerView;
}

- (NSMutableArray *)copyArray{
    
    if (!_copyArray) {
        _copyArray = [NSMutableArray array];
    }
    return _copyArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (SFTipDesView *)tipDesView{
    
    if (!_tipDesView) {
        _tipDesView = [SFTipDesView shareSFTipDesView];
        _tipDesView.titleLabel.text = @"请设置好薪资录入，否则请假、早退和旷工是不扣分的";
    }
    return _tipDesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = [self.module isEqualToString:@"REPORT"]?
    @"汇报规则设置":[self.module isEqualToString:@"ATTENDANCE"]?
    @"考勤规则设置":[self.module isEqualToString:@"TASK"]?
    @"任务规则设置":[self.module isEqualToString:@"DAILY"]?
    @"日报规则设置":[self.module isEqualToString:@"VISIT"]?
    @"拜访规则设置":@"自定义规则设置";
    
    [self setDrawUI];
    [self requestData];
    [self getItemData];
}

- (void)getItemData {
    
    [SFWorkAssessHttpModel workAssessCheckModule:self.module success:^(NSArray<SFWorkCheckItemModel *> * _Nonnull list) {
        
        [self.itemArray removeAllObjects];
        [self.itemArray addObjectsFromArray:list];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestData {
    
    if (self.isEditor) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[SFAssessmentSetModel shareAssessmentSetDateil:self.smodel]];
        
        for (RuleModulesItemModel * mod in self.smodel.ruleItemDTOList) {
            [self.dataArray insertObject:[SFAssessmentSetModel addModel:mod.itemName WithDestitle:@"" withValue:mod.itemNum  withArr:(SFWorkCheckItemModel *)mod] atIndex:self.dataArray.count - 1];
        }
        [self.employeeIds removeAllObjects];
        for (RulePersonModel * p in self.smodel.rulePersonDTOList) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setValue:p.id forKey:@"employeeId"];
            [self.employeeIds addObject:dict];
        }
        
        [self.tableView reloadData];
    }else{
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[SFAssessmentSetModel shareAssessmentSetModel]];
        [self.tableView reloadData];
    }
    
}

- (void)setDrawUI {
    
//    [self.view addSubview:self.tipDesView];
//    [self.tipDesView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.offset(35);
//    }];
    
    
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    @weakify(self)
    [self.footerView setSureClick:^(NSInteger index) {
        @strongify(self)
        
        if (index == 1) {
            [self saveData];
        }else{
            
            if (self.isEditor) {
                [UIAlertController alertTitle:@"温馨提示" mesasge:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *alertAction) {
                    
                    [self deleteData];
                    
                } cancleHandler:^(UIAlertAction *alert) {
                    
                } viewController:self];
                
            }else{
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
        
    }];
}

- (void)deleteData {
    [MBProgressHUD showActivityMessageInView:@""];
    [SFWorkAssessHttpModel workAssessDeleteCheckModule:self.smodel.id success:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:@"删除成功"];
        !self.addAssessmentClick?:self.addAssessmentClick();
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:@"删除失败"];
    }];
}

- (void)saveData {
    
    NSMutableDictionary * dict = [SFAssessmentSetModel pramAssessmentSetJson:self.dataArray];
    [dict setValue:[SFInstance shareInstance].userInfo.companyId forKey:@"companyId"];
    [dict setValue:self.module forKey:@"checkModule"];
    [dict setValue:@"EXECUTING" forKey:@"checkRuleStatus"];
    [dict setValue:self.employeeIds forKey:@"rulePersonDTOList"];
    if (self.isEditor) {
        [dict setValue:self.smodel.id forKey:@"id"];
    }
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray * arr in self.dataArray) {
        
        for (SFAssessmentSetModel * mod in arr) {
            if (mod.type == 7) {
                [array addObject:mod.mod];
            }
        }
    }
    NSArray * ruleArr = [NSString arrayOrDicWithObject:array];
    [dict setValue:ruleArr forKey:@"ruleItemDTOList"];
    if (ruleArr.count == 0 || self.employeeIds.count == 0 || [dict[@"name"] isEqualToString:@""]|| [dict[@"startDate"] isEqualToString:@""]|| [dict[@"endDate"] isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInView:@"请填写完整资料" timer:2];
        return;
    }
    NSLog(@"%@",dict);
    [MBProgressHUD showActivityMessageInView:@""];
    [SFWorkAssessHttpModel addWorkAssessCheck:dict success:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:@"提交成功"];
        !self.addAssessmentClick?:self.addAssessmentClick();
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:@"提交失败"];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFAssessmentSetModel * model = array[indexPath.row];
    if (model.type == 7) {
        
        return model.mod.itemSubList.count * 55 + 55;
    }
    if (model.type == 5) {
        
        return [model.value calculateHeightWithFont:[UIFont fontWithName:kRegFont size:13] Width:kWidth-30]+45;
    }
    return 45;
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
    
    NSArray * array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFAssessmentSetModel * model = array[indexPath.row];
    if (model.type == 1) {
        SFSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSwitchCellID forIndexPath:indexPath];
        @weakify(self)
        [cell setSelectClick:^(BOOL isOn) {
            @strongify(self)
            
            if (isOn) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:self.copyArray];
            }else{
                [self.copyArray removeAllObjects];
                [self.copyArray addObjectsFromArray:self.dataArray];
                [self.dataArray removeAllObjects];
                [self.dataArray addObject:[SFAssessmentSetModel isOn]];
            }
            [self.tableView reloadData];
        }];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 5) {
        SFAssessSelectEmpCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAssessSelectEmpCellID forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    if (model.type == 6) {
        
        SFAddAssessmentCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddAssessmentCellID forIndexPath:indexPath];

        return cell;
    }
    
    if (model.type == 7) {
        
        SFAssessmentItemCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAssessmentItemCellID forIndexPath:indexPath];
        cell.model = model;
        @weakify(self)
        
        [cell setSelectClick:^(ItemSubListModel * _Nonnull model) {
            @strongify(self)
            self.item = model;
            [self customArr:@[@"每天",@"每周",@"每月"] withRow:1];
        }];
        
        [cell setDeleteClick:^(SFAssessmentSetModel * _Nonnull mod) {
            @strongify(self)
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 处理耗时操作的代码块...
                
                NSMutableArray * data = [NSMutableArray arrayWithArray:self.dataArray];
                for (NSArray * arr in data) {
                    
                    NSMutableArray * array = arr.mutableCopy;
                    if ([array containsObject:mod]) {
                        
                        [self.dataArray removeObject:array];
                    }
                    
                }
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [self.tableView reloadData];
                });
                
            });
            
            
        }];
        return cell;
    }
    SFAssessmentRuleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAssessmentRuleCellID forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray * array = self.dataArray[indexPath.section];
    SFAssessmentSetModel * model = array[indexPath.row];
    self.model = model;
    if (model.type == 5) {
        SFAllEmployeeViewController * vc = [NSClassFromString(@"SFAllEmployeeViewController") new];
        vc.delagete = self;
        vc.type = multipleType;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (model.type == 6) {
        
        NSMutableArray * array = [NSMutableArray array];
        for (SFWorkCheckItemModel * item in self.itemArray) {
            
            [array addObject:item.itemName];
        }
        [self customArr:array withRow:indexPath.row];
    }
    if (model.type == 4 || model.type == 3) {
        
        [self selectTime:DatePickerViewDateMode];
    }
}

//多选
- (void)multipleSelectEmoloyee:(NSArray <SFEmployeesModel *> *)employees{
    
    NSString * title = @"";
    [self.employeeIds removeAllObjects];
    for (int i = 0; i < employees.count; i ++) {
        SFEmployeesModel * emp = employees[i];
        
        if (i == 0) {
            title = emp.name;
        }else{
            title = [NSString stringWithFormat:@"%@ %@",title,emp.name];
        }
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:emp._id forKey:@"employeeId"];
        [self.employeeIds addObject:dict];
    }
    
    
    self.model.destitle = [NSString stringWithFormat:@"已选%ld人",employees.count];
    self.model.value = title;
    [self.tableView reloadData];
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

- (void)customArr:(NSArray *)array withRow:(NSInteger)row{
    
    SFPickerView *picker = [[SFPickerView alloc] initWithFrame:self.view.bounds];
    picker.delegate = self ;
    picker.row = row;
    picker.customArr = array;
    [LSKeyWindow addSubview:picker];
}
#pragma mark- SFPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text withRow:(NSInteger)row withSelectIndex:(NSInteger)selectIndex{
    
    if (row == 1) {
        self.item.period = [text isEqualToString:@"每天"]?@"DAY":[text isEqualToString:@"每周"]?@"WEEK":@"MONTH";
    }else{
        SFWorkCheckItemModel * item = self.itemArray[selectIndex];
        [self.dataArray insertObject:[SFAssessmentSetModel addModel:text WithDestitle:@"" withValue:item.itemNum  withArr:item] atIndex:self.dataArray.count - 1];
        
    }
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerClass:[SFAssessmentRuleCell class] forCellReuseIdentifier:SFAssessmentRuleCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSwitchCell" bundle:nil] forCellReuseIdentifier:SFSwitchCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFAddAssessmentCell" bundle:nil] forCellReuseIdentifier:SFAddAssessmentCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFAssessmentItemCell" bundle:nil] forCellReuseIdentifier:SFAssessmentItemCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFAssessSelectEmpCell" bundle:nil] forCellReuseIdentifier:SFAssessSelectEmpCellID];
        
    }
    return _tableView;
}


@end


@interface SFAssessmentRuleCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * desTextField;

@end

@implementation SFAssessmentRuleCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    
    [self addSubview:self.startLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.desTextField];
    
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.offset(7);
        make.left.equalTo(self.mas_left).offset(6);
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.startLabel.mas_right).offset(6);
        make.centerY.equalTo(self);
    }];
    
    [self.desTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
        make.width.offset(200);
        make.height.offset(30);
    }];
    RACChannelTo(self, self.model.destitle) = RACChannelTo(self.desTextField, text);
    
    @weakify(self)
    [[self.desTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.model.destitle = x;
    }];
    
}

- (void)setModel:(SFAssessmentSetModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.startLabel.text = model.stars;
    self.desTextField.text = model.destitle ;
    self.desTextField.placeholder = model.placeholder;
    self.desTextField.enabled = model.isClick ;
    
}


- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [UILabel creatLabelWithFontName:kRegFont TextColor:Color(@"#333333") FontSize:14 Text:@"头像"];
    }
    
    return _titleLabel;
}

- (UILabel *)startLabel{
    
    if (!_startLabel) {
        _startLabel = [UILabel creatLabelWithFontName:kRegFont TextColor:[UIColor redColor] FontSize:14 Text:@"*"];
    }
    
    return _startLabel;
}

- (UITextField *)desTextField{
    
    if (!_desTextField) {
        UITextField * textField = [[UITextField alloc] init];
        _desTextField = textField;
        textField.textAlignment = NSTextAlignmentRight;
        textField.tintColor = Color(@"#333333");
        textField.font = [UIFont fontWithName:kRegFont size:14];
    }
    
    return _desTextField;
}

@end

