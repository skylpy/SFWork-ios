//
//  SFAddContactsViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/14.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddContactsViewController.h"
#import "SFAddDataViewController.h"
#import "DateTimePickerView.h"
#import "SFCustomerModel.h"
#import "SFProfileTableCell.h"
#import "SFTextViewCell.h"
#import "SFSwitchCell.h"

static NSString * const SFAddDataCellID = @"SFAddDataCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFSwitchCellID = @"SFSwitchCellID";

@interface SFAddContactsViewController ()<DateTimePickerViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) DateTimePickerView *datePickerView;
//当前model
@property (nonatomic, strong) SFCustomerModel * cmodel;

@end

@implementation SFAddContactsViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.backgroundColor = Color(@"#01B38B");
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self saveUpload];
        }];
    }
    return _saveButton;
}

- (void)saveUpload{
    
    NSMutableDictionary * dict = [SFCustomerModel pramContactsJson:self.dataArray];
    
    NSString * phone = dict[@"tel"];
    if (![NSString valiMobile:phone]) {
        [UIAlertController alertTitle:@"温馨提示" mesasge:@"请输入正确的电话号码！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
            
        } viewController:self];
        return;
    }
    if ([dict[@"name"] isEqualToString:@""]) {
        [UIAlertController alertTitle:@"温馨提示" mesasge:@"请输入正确的名字！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
            
        } viewController:self];
        return;
    }
    
    NSLog(@"%@",dict);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getContacts:)]) {
        
        [self.delegate getContacts:dict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增联系人";
    [self setDrawUI];
    [self getData];
}

- (void)getData {
    
    [self.dataArray addObjectsFromArray:[SFCustomerModel shareContactsModel]];
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = bgColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
    }];
}

//批量操作
- (void)addGender:(SFCustomerModel *)model {
    
    ModelComfirm *item1 = [ModelComfirm comfirmModelWith:@"男" titleColor:Color(@"#0B0B0B") fontSize:16];
    ModelComfirm *item2 = [ModelComfirm comfirmModelWith:@"女" titleColor:Color(@"#0B0B0B") fontSize:16];
    ModelComfirm *cancelItem = [ModelComfirm comfirmModelWith:@"取消" titleColor:Color(@"#0B0B0B") fontSize:16];
    [ComfirmView showInView:LSKeyWindow cancelItemWith:cancelItem dataSource:@[ item1 ,item2] actionBlock:^(ComfirmView *view, NSInteger index) {
        
        
        model.destitle = index == 0 ? @"男":@"女";
        model.value = index == 0 ? @"MALE":@"FEMALE";
        [self.tableView reloadData];
    }];
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
    
    SFCustomerModel * model = self.dataArray[indexPath.row];
    if (model.type == 11) {
        
        return 203;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFCustomerModel * model = self.dataArray[indexPath.row];
    
    if (model.type == 11) {
        
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    if (model.type == 2) {
        SFSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSwitchCellID forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    
    SFAddDataCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddDataCellID forIndexPath:indexPath];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFCustomerModel * model = self.dataArray[indexPath.row];
    self.cmodel = model;
    if (model.type == 3) {
        [self addGender:model];
    }
    if (model.type == 10) {
        
        [self clickButton];
    }
}

- (void)clickButton{
    
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    self.datePickerView = pickerView;
    pickerView.delegate = self;
    pickerView.pickerViewMode = DatePickerViewDateMode;
    [LSKeyWindow addSubview:pickerView];
    [pickerView showDateTimePickerView];
    
}

#pragma mark - delegate

- (void)didClickFinishDateTimePickerView:(NSString *)date{
    
    NSLog(@"%@",date);
    
    self.cmodel.destitle = date;
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
        
        [_tableView registerClass:[SFAddDataCell class] forCellReuseIdentifier:SFAddDataCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSwitchCell" bundle:nil] forCellReuseIdentifier:SFSwitchCellID];
        
    }
    return _tableView;
}

@end
