//
//  SFVisitSeachViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitSeachViewController.h"
#import "SFAddVisitViewController.h"
#import "SFSelCustomerViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFContactsViewController.h"
#import "SFCustomerModel.h"
#import "SFVisitModel.h"
#import "SFPickerView.h"
#import "SFSetTypeModel.h"

static NSString * const SFAddVisitCellID = @"SFAddVisitCellID";

@interface SFVisitSeachViewController ()<UITableViewDelegate,UITableViewDataSource,SFPickerViewDelegate,DateTimePickerViewDelegate,SFSuperSuborViewControllerDelagete>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) SFVisitModel * model;
//客户model
@property (nonatomic, strong) SFClientModel *cmodel;
@property (nonatomic, strong) DateTimePickerView *timePickerView;
@property (nonatomic, strong) NSMutableArray *visitArray;
//客户ID
@property (nonatomic, copy) NSString *cid;

@end

@implementation SFVisitSeachViewController

- (NSMutableArray *)visitArray{
    
    if (!_visitArray) {
        
        _visitArray = [NSMutableArray array];
    }
    return _visitArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"拜访客户详细搜索";
    [self setDrawUI];
    [self getData];
    [self initData];
}

- (void)getData {
    
    [self.dataArray addObjectsFromArray:[SFVisitModel shareSeachVisitModel]];
    [self.tableView reloadData];
    
}

- (void)initData{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    [SFSetTypeModel getCompanySetting:@"TASK_TYPE" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.visitArray removeAllObjects];
        [self.visitArray addObjectsFromArray:list];
        
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SFAddVisitCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddVisitCellID forIndexPath:indexPath];
    SFVisitModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFVisitModel * model = self.dataArray[indexPath.row];
    self.model = model;
    switch (model.type) {
        case 1:
        {
            SFSelCustomerViewController * vc = [NSClassFromString(@"SFSelCustomerViewController") new];
            @weakify(self)
            [vc setSelCustomerClick:^(SFClientModel * _Nonnull cmodel) {
                @strongify(self)
                self.cmodel = cmodel;
                self.cid = cmodel._id;
                model.destitle = cmodel.name;
                model.value = cmodel._id;
                
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            if (!self.cid) {
                [UIAlertController alertTitle:@"温馨提示" mesasge:@"请选择客户！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
                    
                } viewController:self];
                return;
            }
            SFContactsViewController * vc = [SFContactsViewController new];
            vc.uid = self.cid;
            @weakify(self)
            [vc setSelectItemClick:^(ContactsModel * _Nonnull model) {
                @strongify(self)
                
                self.model.destitle =model.name;
                self.model.value = model._id;
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            //客户类型
            NSMutableArray * array = [NSMutableArray array];
            for (SFSetTypeModel * model in self.visitArray) {
                [array addObject:model.name];
            }
            [self customArr:array withRow:indexPath.row];
        }
            break;
        case 4:
            [self selectTime:DatePickerViewDateTimeMode];
            break;
        case 5:
            [self selectTime:DatePickerViewDateTimeMode];
            break;
        case 6:
        {
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.isSubor = YES;
            vc.delagete = self;
            vc.type = singleType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.isSubor = YES;
            vc.delagete = self;
            vc.type = singleType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:
            [self customArr:@[@"已创建",@"已完成",@"已取消"] withRow:indexPath.row];
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
#pragma mark- SFPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text withRow:(NSInteger)row withSelectIndex:(NSInteger)selectIndex{
    
    self.model.destitle = text;
    self.model.value = [text isEqualToString:@"已创建"]?
    @"CREATED":[text isEqualToString:@"已完成"]?@"VISITED":@"CANCELED";
//    NSInteger index = [pickerView selectedRowInComponent:0];
   
    [self.tableView reloadData];
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    
    NSLog(@"%@",employee._id);
    self.model.destitle = employee.name;
    self.model.value = employee._id;
    [self.tableView reloadData];
}
//多选
- (void)multiplesSelectEmoloyee:(NSArray <SFEmployeesModel *> *)employees{
    NSLog(@"%ld",employees.count);
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
        [_tableView registerClass:[SFAddVisitCell class] forCellReuseIdentifier:SFAddVisitCellID];
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
            
            [self dealWealData];
        }];
    }
    return _saveButton;
}

- (void)dealWealData{
    
    NSMutableDictionary * dict = [SFVisitModel pramSeachVisitJson:self.dataArray];
    
    NSLog(@"%@",dict);
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFVisitHttpModel clientVisitList:dict success:^(NSArray<SFVisitListModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        UIViewController * vc = [NSClassFromString(@"SFSeachListViewController") new];
        [vc setValue:list forKey:@"data"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
    
}


@end
