//
//  SFSearchMgrViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/15.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSearchMgrViewController.h"
#import "SFCustomerHttpModel.h"
#import "SFProfileTableCell.h"

#import "SFSetTypeModel.h"
#import "SFPickerView.h"
#import "SFRegisterModel.h"

static NSString * const SFProfileTableCellID = @"SFProfileTableCellID";


@interface SFSearchMgrViewController ()<UITableViewDelegate,UITableViewDataSource,SFPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton * searchButton;
@property (nonatomic, strong) SFPickerView *pickerView;
@property (nonatomic, strong) SFCustomerModel * model;
@property (nonatomic, strong) NSMutableArray *clentTypeArr;
@property (nonatomic, strong) NSMutableArray *clentlevelArr;
@property (nonatomic, strong) NSMutableArray *intentionTypeArr;

@property (nonatomic, strong) SFAddressPicker *  addressPicker;

@end

@implementation SFSearchMgrViewController

- (NSMutableArray *)clentTypeArr{
    
    if (!_clentTypeArr) {
        _clentTypeArr = [NSMutableArray array];
    }
    return _clentTypeArr;
}

- (NSMutableArray *)clentlevelArr{
    
    if (!_clentlevelArr) {
        _clentlevelArr = [NSMutableArray array];
    }
    return _clentlevelArr;
}

- (NSMutableArray *)intentionTypeArr{
    
    if (!_intentionTypeArr) {
        _intentionTypeArr = [NSMutableArray array];
    }
    return _intentionTypeArr;
}


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    [self setDrawUI];
    [self getData];
    
    [self requestTypeData];
    [self getCity];
}

- (void)getCity{
    
    [SFRegHttpModel getCityDataSuccess:^(NSArray<AddressModel *> * _Nonnull address) {
        
        [self.addressPicker loadRequestData:address];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showErrorMessage:@"城市列表加载失败!"];
    }];
}

- (void)getData {
    
    [self.dataArray addObjectsFromArray:[SFCustomerModel shareSearchModel:0]];
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    
    [self.view addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
    }];
    
    self.addressPicker= [[SFAddressPicker alloc] init];
    [LSKeyWindow addSubview:self.addressPicker];
    self.addressPicker.delegate = self;
}

- (void)requestTypeData{
    
    [MBProgressHUD showActivityMessageInWindow:@"加载信息..."];
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFSetTypeModel getCompanySetting:@"CLIENT_TYPE" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
            
            [MBProgressHUD hideHUD];
            [self.clentTypeArr removeAllObjects];
            [self.clentTypeArr addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
            
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
            [MBProgressHUD hideHUD];
        }];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFSetTypeModel getCompanySetting:@"CLIENT_LEVEL" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
            
            [MBProgressHUD hideHUD];
            [self.clentlevelArr removeAllObjects];
            [self.clentlevelArr addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
            
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
            [MBProgressHUD hideHUD];
        }];
        
        return nil;
    }];
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFSetTypeModel getCompanySetting:@"INTENTION_TYPE" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
            
            [MBProgressHUD hideHUD];
            [self.intentionTypeArr removeAllObjects];
            [self.intentionTypeArr addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
            
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
            [MBProgressHUD hideHUD];
        }];
        
        return nil;
    }];
    
    RACSignal *signal4 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFSetTypeModel getCompanySetting:@"CLIENT_LEVEL" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
            
            //            [MBProgressHUD hideHUD];
            //            [self.clentArr removeAllObjects];
            //            [self.clentArr addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
            
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
            [MBProgressHUD hideHUD];
        }];
        
        return nil;
    }];
    
    [self rac_liftSelector:@selector(completedRequest1:request2:request3:request4:) withSignalsFromArray:@[signal1, signal2,signal3,signal4]];
    
}

- (void)completedRequest1:(NSString *)signal1 request2:(NSString *)signal2 request3:(NSString *)signal3 request4:(NSString *)signal4{
    
    if ([signal1 isEqualToString:@"1"] && [signal2 isEqualToString:@"1"]&& [signal3 isEqualToString:@"1"]&& [signal4 isEqualToString:@"1"] ) {
        
        [MBProgressHUD hideHUD];
    }else{
        [MBProgressHUD showErrorMessage:@"加载失败,请重新加载!"];
        [MBProgressHUD hideHUD];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFCustomerModel * model = self.dataArray[indexPath.row];
    
    
    SFProfileTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFProfileTableCellID forIndexPath:indexPath];
    
    cell.cmodel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFCustomerModel * model = self.dataArray[indexPath.row];
    self.model = model;
    switch (model.type) {
        case 2:
            //归属
            [self customArr:@[@"我的(私有)",@"部门(部门公有)"] withRow:indexPath.row];
            break;
        case 3:
        {
            //客户类型
            NSMutableArray * array = [NSMutableArray array];
            for (SFSetTypeModel * model in self.clentTypeArr) {
                [array addObject:model.name];
            }
            [self customArr:array withRow:indexPath.row];
        }
            break;
        case 4:
        {
            //客户类型
            NSMutableArray * array = [NSMutableArray array];
            for (SFSetTypeModel * model in self.clentlevelArr) {
                [array addObject:model.name];
            }
            [self customArr:array withRow:indexPath.row];
        }
            break;
        case 5:
            [self.addressPicker show];
            break;
        case 7:
        {
            //意向类型
            NSMutableArray * array = [NSMutableArray array];
            for (SFSetTypeModel * model in self.intentionTypeArr) {
                [array addObject:model.name];
            }
            [self customArr:array withRow:indexPath.row];
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
    NSInteger index = [pickerView selectedRowInComponent:0];
    
    switch (row) {
        case 3:
        {
            SFSetTypeModel * model = self.clentTypeArr[index];
            self.model.value = model._id;
        }
            break;
        case 4:
        {
            SFSetTypeModel * model = self.clentlevelArr[index];
            self.model.value = model._id;
        }
            break;
        
            
        case 7:
        {
            SFSetTypeModel * model = self.intentionTypeArr[index];
            self.model.value = model._id;
        }
            break;
        default:
            break;
    }
    
    
    NSLog(@"%@== %ld",text,[pickerView selectedRowInComponent:0]);
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerClass:[SFProfileTableCell class] forCellReuseIdentifier:SFProfileTableCellID];
       
        
    }
    return _tableView;
}

- (UIButton *)searchButton{
    
    if (!_searchButton) {
        
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.backgroundColor = Color(@"#01B38B");
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            [self seachRequst];
        }];
    }
    return _searchButton;
}

- (void)seachRequst{
    
    NSMutableDictionary * dict = [SFCustomerModel pramSearchJson:self.dataArray];
    NSString * clientGroup = self.type == businessType ? @"MERCHANT":@"CLIENT";
    [dict setValue:clientGroup forKey:@"clientGroup"];
    
    [SFCustomerHttpModel searchClients:dict success:^(NSArray<SFClientModel *> * _Nonnull list) {
        
        [self goResult:list];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)goResult:(NSArray *)arr{
    UIViewController * vc = [NSClassFromString(@"SFSearchResultViewController") new];
    [vc setValue:arr forKey:@"resultArr"];
    [vc setValue:@(self.type) forKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - AddressViewDelegate
- (void)cancelOnclick{
    [self.addressPicker hide];
}

- (void)viewDisappearance{
    [self.addressPicker hide];
}

- (void)completingTheSelection:(AddressModel *)province city:(AddressModel *)city area:(AddressModel *)area;{
    [self.addressPicker hide];
    
    [self.tableView reloadData];
    NSLog(@"province:%@,city:%@,area:%@",province.label,city.label,area.label);
    self.model.destitle = [NSString stringWithFormat:@"%@,%@,%@",province.label,city.label,area.label];
    self.model.value = area.value;
}

@end
