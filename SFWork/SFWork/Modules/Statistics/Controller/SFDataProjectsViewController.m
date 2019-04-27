//
//  SFDataProjectsViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFDataProjectsViewController.h"
#import "SFAddDataAssViewController.h"
#import "SFDataProjectsCell.h"
#import "SFAddDatasCell.h"
#import "SFSaveButtonCell.h"
#import "SFSelectTemplateCell.h"

#import "SFDataReportHttpModel.h"
#import "SFPickerView.h"


static NSString * const SFDataProjectsCellID = @"SFDataProjectsCellID";
static NSString * const SFAddDataCellID = @"SFAddDataCellID";
static NSString * const SFSaveButtonCellID = @"SFSaveButtonCellID";
static NSString * const SFSelectTemplateCellID = @"SFSelectTemplateCellID";

@interface SFDataProjectsViewController ()<UITableViewDelegate,UITableViewDataSource,SFPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation SFDataProjectsViewController

- (NSMutableArray *)datas{
    
    if (!_datas) {
        
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"制定数据项目";
    
    [self setDrawUI];
}

- (void)setArray:(NSArray *)array{
    _array = array;
    [self.dataArray addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
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
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return self.dataArray.count+1;
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.dataArray.count) {
        SFAddDatasCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddDataCellID forIndexPath:indexPath];
        
        
        return cell;
    }
    SFDataProjectsCell * cell = [tableView dequeueReusableCellWithIdentifier:SFDataProjectsCellID forIndexPath:indexPath];
    ItemsModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.dataArray.count) {
        SFAddDataAssViewController * vc = [SFAddDataAssViewController new];
        @weakify(self)
        [vc setCompleteClick:^(ItemsModel * _Nonnull item) {
            @strongify(self)
            [self.dataArray addObject:item];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        ItemsModel * model = self.dataArray[indexPath.row];
        SFAddDataAssViewController * vc = [SFAddDataAssViewController new];
        vc.model = model;
        @weakify(self)
        [vc setCompleteClick:^(ItemsModel * _Nonnull item) {
            @strongify(self)
            if (item == model) {
                [self.dataArray replaceObjectAtIndex:indexPath.row withObject:item];
            }else{
                [self.dataArray addObject:item];
            }
            
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
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
    
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFDataProjectsCell" bundle:nil] forCellReuseIdentifier:SFDataProjectsCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFAddDatasCell" bundle:nil] forCellReuseIdentifier:SFAddDataCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSaveButtonCell" bundle:nil] forCellReuseIdentifier:SFSaveButtonCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectTemplateCell" bundle:nil] forCellReuseIdentifier:SFSelectTemplateCellID];
        
    }
    return _tableView;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#01B38B");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            !self.datasClick?:self.datasClick(self.dataArray);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _saveButton;
}

@end
