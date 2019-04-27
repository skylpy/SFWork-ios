//
//  SFSelectEmployeeViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAllEmployeeViewController.h"
#import "SFPublicSearchView.h"
#import "SFPublicSelectView.h"
#import "SFOrganizationModel.h"
#import "SFOrganizationViewController.h"
#import "SFTableViewCell.h"
#import "SFDevTableCell.h"
#import "SFEmployeeCell.h"
#import "SFSelectEmpView.h"

static NSString * const SFDevTableCellID = @"SFDevTableCellID";
static NSString * const SFEmployeeCellID = @"SFEmployeeCellID";

@interface SFAllEmployeeViewController ()<UITableViewDelegate,UITableViewDataSource,SFEmployeeCellDelegate>

@property (nonatomic,strong) SFPublicSearchView * headerView;
@property (nonatomic,strong) SFPublicSelectView * selectView;
@property (nonatomic, strong) SFSelectEmpView *selectEmpView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SFOrgListModel *orgModel;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation SFAllEmployeeViewController

- (NSMutableArray *)selectArray{
    
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择员工";
    [self initDrawUI];
    [self requestData];
}

-(void)requestData{
    
//    @"departmentId":@"402880086950ab4c016950da0b7c000d"
    [SFOrganizationModel getOrganizationAllList:@{} success:^(SFOrgListModel * _Nonnull model) {
        
        self.orgModel = model;
        [self.selectView.nameArray addObject:model.name];
        [self.selectView.collectionView reloadData];
        [self.dataArray removeAllObjects];
        [self.titleArray removeAllObjects];
        [self.titleArray addObject:model];
        [self.dataArray addObject:model.children == nil ? @[]:model.children];
        [self.dataArray addObject:model.employees == nil ? @[]:model.employees];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(43);
        make.top.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(45);
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.selectView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(self.type == multipleType ? -50:0);
    }];
    
   
    if (self.type == multipleType) {
        [self.view addSubview:self.selectEmpView];
        [self.selectEmpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    
    
    @weakify(self)
    [self.selectView setDidSelectClick:^(NSInteger row,NSArray * array) {
        @strongify(self)
        NSLog(@"%ld",row);

        NSArray * sarray = self.titleArray.mutableCopy;
     
        [self.titleArray removeAllObjects];
        [self.selectView.nameArray removeAllObjects];
        for (int i = 0; i < row+1; i ++) {

            SFOrgListModel * mod = sarray[i];
            [self.titleArray addObject:mod];
            [self.selectView.nameArray addObject:mod.name];
        }
        [self.selectView.collectionView reloadData];
        SFOrgListModel * models = self.titleArray[row];
        [self.dataArray removeAllObjects];
        
        [self.dataArray addObject:models.children == nil ? @[]:models.children];
        [self.dataArray addObject:models.employees == nil ? @[]:models.employees];
        [self.tableView reloadData];
    }];
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
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array = self.dataArray[section];
    
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    if (indexPath.section == 0) {
        
        SFDevTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFDevTableCellID forIndexPath:indexPath];
        SFOrgListModel * models = array[indexPath.row];
        cell.model = models;
        @weakify(self)
        [cell setNextClick:^(SFOrgListModel * _Nonnull model) {
            @strongify(self)
            [self.dataArray removeAllObjects];
            [self.titleArray addObject:model];
            [self.selectView.nameArray addObject:model.name];
            [self.selectView.collectionView reloadData];
            [self.dataArray addObject:model.children == nil ? @[]:model.children];
            [self.dataArray addObject:model.employees == nil ? @[]:model.employees];
            [self.tableView reloadData];
        }];
        return cell;
    }
    
    SFEmployeeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFEmployeeCellID forIndexPath:indexPath];
    SFEmployeesModel * model = array[indexPath.row];
    cell.type = self.type;
    cell.delegate = self;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == multipleType || indexPath.section == 0) return;
    NSArray * array = self.dataArray[indexPath.section];
    SFEmployeesModel * model = array[indexPath.row];
     [self.navigationController popViewControllerAnimated:YES];
    if (self.delagete && [self.delagete respondsToSelector:@selector(singleSelectEmoloyee:)]) {
        
        [self.delagete singleSelectEmoloyee:model];
    }
   
}

- (void)selectEmployee:(SFEmployeesModel *)model{
    
    if (model.isSelect && ![self.selectArray containsObject:model]) {
        
        [self.selectArray addObject:model];
    }
    if (!model.isSelect) {
        
        [self.selectArray removeObject:model];
    }
    NSLog(@"%ld",self.selectArray.count);
}

- (SFPublicSearchView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [SFPublicSearchView shareSFPublicSearchView];
        
    }
    return _headerView;
}

- (SFPublicSelectView *)selectView {
    
    if (!_selectView) {
        
        _selectView = [SFPublicSelectView loadNibView];
    }
    return _selectView;
}

- (SFSelectEmpView *)selectEmpView{
    
    if (!_selectEmpView) {
        
        _selectEmpView = [SFSelectEmpView shareSFSelectEmpView];
        @weakify(self)
        [_selectEmpView setSelectEmpClick:^(NSArray * _Nonnull list) {
            @strongify(self)
            if (self.delagete && [self.delagete respondsToSelector:@selector(multipleSelectEmoloyee:)]) {
                
                [self.delagete multipleSelectEmoloyee:self.selectArray];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _selectEmpView;
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFDevTableCell" bundle:nil] forCellReuseIdentifier:SFDevTableCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFEmployeeCell" bundle:nil] forCellReuseIdentifier:SFEmployeeCellID];
    }
    return _tableView;
}

@end
