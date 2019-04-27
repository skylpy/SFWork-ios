//
//  SFAllManagerViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAllManagerViewController.h"
#import "SFAttendanceSetHttpModel.h"
#import "SFEmpSelectCell.h"
#import "SFEmployeeCell.h"

static NSString * const SFEmpSelectCellID = @"SFEmpSelectCellID";
static NSString * const SFEmployeeCellID = @"SFEmployeeCellID";

@interface SFAllManagerViewController ()<UITableViewDelegate,UITableViewDataSource,SFEmployeeCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation SFAllManagerViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)selectArray{
    
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理人员列表";
    [self initDrawUI];
    [self requestData];
}

-(void)requestData{
    
    [SFOrganizationModel getAllManagerListSuccess:^(NSArray<SFEmployeesModel *> * _Nonnull list) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)initDrawUI {

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset( 0);
    }];
    
    if (self.type != 0) {
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
        
        self.navigationItem.rightBarButtonItem = rightItem;
    }
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
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

    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

 
    if (self.type == 0 || self.type == 1) {
        SFEmployeeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFEmployeeCellID forIndexPath:indexPath];
        SFEmployeesModel * model = self.dataArray[indexPath.row];
        cell.type = (SelectEmpType) self.type;
        cell.delegate = self;
        cell.model = model;
        return cell;
    }
    SFEmpSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFEmpSelectCellID forIndexPath:indexPath];
    SFEmployeesModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    @weakify(self)
    [cell setSelectClick:^(SFEmployeesModel * _Nonnull model) {
        @strongify(self)
        if (model.isSelect && ![self.selectArray containsObject:model]) {

            [self.selectArray addObject:model];
        }
        if (!model.isSelect) {

            [self.selectArray removeObject:model];
        }
    
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFEmployeesModel * model = self.dataArray[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delagete && [self.delagete respondsToSelector:@selector(singleSelectAllManager:)]) {
        
        [self.delagete singleSelectAllManager:model];
    }
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            NSMutableArray * array = [NSMutableArray array];
            for (SFEmployeesModel * model in self.selectArray) {
                ReportUserModel * mod = [ReportUserModel new];
                mod.id = model._id;
                mod.name = model.name;
                mod.smallAvatar = model.smallAvatar;
                [array addObject:mod];
            }
            !self.selectAllClick?:self.selectAllClick(array);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _rightButton;
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFEmpSelectCell" bundle:nil] forCellReuseIdentifier:SFEmpSelectCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFEmployeeCell" bundle:nil] forCellReuseIdentifier:SFEmployeeCellID];
        
       
    }
    return _tableView;
}

@end
