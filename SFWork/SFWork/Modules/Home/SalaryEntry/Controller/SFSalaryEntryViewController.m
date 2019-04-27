//
//  SFSalaryEntryViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSalaryEntryViewController.h"
#import "SFSelectEmployeeViewController.h"
#import "SFSalarySetViewController.h"
#import "SFProfileViewController.h"
#import "SFDepSetViewController.h"
#import "SFPublicSearchView.h"
#import "SFPublicSelectView.h"
#import "SFOrganizationModel.h"
#import "SFTableViewCell.h"

static NSString * const SFOrganizationCellID = @"SFOrganizationCellID";
static NSString * const SFEmployeesCellID = @"SFEmployeesCellID";

@interface SFSalaryEntryViewController ()<UITableViewDelegate,UITableViewDataSource,SFTableViewCellDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * titArray;
@property (nonatomic,strong) SFPublicSearchView * headerView;
@property (nonatomic,strong) SFPublicSelectView * selectView;

//当前架构model
@property (nonatomic, strong) SFOrgListModel *currentModel;
//批量操作
@property (nonatomic, strong) UIButton *operation;

@property (nonatomic, strong) UIView * header;


@end

@implementation SFSalaryEntryViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)titArray{
    
    if (!_titArray) {
        _titArray = [NSMutableArray array];
    }
    return _titArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"薪资录入";
    
    [self initDrawUI];
    
    [self requestData];
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
        make.left.right.bottom.equalTo(self.view);
    }];
    
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.operation];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    @weakify(self)
    [self.selectView setDidSelectClick:^(NSInteger row,NSArray * array) {
        @strongify(self)
        
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        NSInteger reduce = array.count - row -1;
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-reduce]animated:YES];
    }];
    
    [[self.operation rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self moreOperation];
    }];
}

//批量操作
- (void)moreOperation {
    
    UIViewController * vc = [NSClassFromString(@"SFSalaryEntrySetViewController") new];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)requestData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.departmentId forKey:@"departmentId"];
    
    [SFOrganizationModel getOrganizationList:dict success:^(SFOrgListModel * _Nonnull model) {
        
        [self dealWithData:model];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)dealWithData:(SFOrgListModel *)model{
    
    self.currentModel = model;
    [self.titArray removeAllObjects];
    [self.titArray addObjectsFromArray:self.nameArray];
    [self.titArray addObject:model.name];
    self.selectView.nameArray = self.titArray;
    [self.selectView.collectionView reloadData];
    
    [self.dataArray removeAllObjects];
    NSMutableArray * dep = [NSMutableArray array];
    [dep addObjectsFromArray:model.children];
    [self.dataArray addObject:dep];
    NSMutableArray * eps = [NSMutableArray array];
    [eps addObjectsFromArray:model.employees];
    [self.dataArray addObject:eps];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return section == 0 ? self.currentModel.admins.count > 0 ? 10:self.currentModel.root == NO ? 60:10:10 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0 && self.currentModel.admins.count == 0 && self.currentModel.root == NO) {
        
        return self.header;
    }
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
        
        SFOrganizationCell * cell = [tableView dequeueReusableCellWithIdentifier:SFOrganizationCellID forIndexPath:indexPath];
        SFOrgListModel * model = array[indexPath.row];
        cell.model = model;
        return cell;
    }
    
    SFTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFEmployeesCellID forIndexPath:indexPath];
    SFEmployeesModel * model = array[indexPath.row];
    cell.delegate = self;
    cell.model = model;
    cell.salaryLabel.text = !model.salary ?@"未设置":[NSString stringWithFormat:@"%@元",model.salary];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * array = self.dataArray[indexPath.section];
    if (indexPath.section == 0) {
        SFOrgListModel * model = array[indexPath.row];
        
        SFSalaryEntryViewController * vc = [SFSalaryEntryViewController new];
        vc.departmentId = model._id;
        vc.departName = model.name;
        vc.parentModel = self.currentModel;
        vc.nameArray = self.titArray;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma SFOrgBottomView

- (void)orgBottomVuewClick:(UIButton *)sender{
    
    if(sender.tag == 1000){
        
        //添加员工
        SFProfileViewController * vc = [NSClassFromString(@"SFProfileViewController") new];
        [vc setValue:@(YES) forKey:@"isOrg"];
        [vc setValue:self.currentModel.companyId  forKey:@"companyId"];
        [vc setValue:self.currentModel._id forKey:@"departmentId"];
        [vc setValue:self.currentModel.name forKey:@"departmentName"];
        @weakify(self)
        [vc setDidSaveClick:^{
            @strongify(self)
            [self requestData];
        }];
        SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nvs animated:YES completion:nil];
        
    }else if (sender.tag == 1001){
        
       
    }else{
        //设置部门
        SFDepSetViewController * vc = [NSClassFromString(@"SFDepSetViewController") new];
        [vc setValue:self.parentModel._id  forKey:@"parentId"];
        [vc setValue:self.parentModel.name forKey:@"parentName"];
        [vc setValue:self.currentModel forKey:@"model"];
        @weakify(self)
        [vc setDidSaveClick:^{
            @strongify(self)
            [self requestData];
        }];
        SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nvs animated:YES completion:nil];
    }
    
}

//修改员工资料
- (void)edirtPersonModel:(SFEmployeesModel *)model{
    
    //设置薪资
    SFSalarySetViewController * vc = [NSClassFromString(@"SFSalarySetViewController") new];
    [vc setValue:model._id  forKey:@"empId"];
    [vc setValue:model.name forKey:@"empName"];
    [vc setValue:model.salary forKey:@"salary"];
    @weakify(self)
    [vc setDidSaveClick:^{
        @strongify(self)
        [self requestData];
        
    }];
    SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nvs animated:YES completion:nil];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerClass:[SFOrganizationCell class] forCellReuseIdentifier:SFOrganizationCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFTableViewCell" bundle:nil] forCellReuseIdentifier:SFEmployeesCellID];
    }
    return _tableView;
}

//设置管理员
- (void)mangerClick{
    
    SFSelectEmployeeViewController * vc = [NSClassFromString(@"SFSelectEmployeeViewController") new];
    [vc setValue:self.currentModel forKey:@"model"];
    [vc setValue:@(3) forKey:@"type"];
    @weakify(self)
    [vc setDidSaveClick:^{
        @strongify(self)
        [self requestData];
    }];
    SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nvs animated:YES completion:nil];
}

- (UIView *)header{
    
    if (!_header) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
        header.backgroundColor = [UIColor clearColor];
        _header = header;
        UIView * boby = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kWidth, 50)];
        boby.backgroundColor = Color(@"#FFF5E4");
        [header addSubview:boby];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mangerClick)];
        [boby addGestureRecognizer:tap];
        
        UILabel * titleLabel = [UILabel createALabelText:@"此部门还没设置管理员" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#F96A0E")];
        titleLabel.frame = CGRectMake(15, 5, 200, 15);
        [boby addSubview:titleLabel];
        
        UILabel * desLabel = [UILabel createALabelText:@"管理员是部门领导，负责底下员工的审批、查看和操作" withFont:[UIFont fontWithName:kRegFont size:11] withColor:Color(@"#F96A0E")];
        desLabel.numberOfLines = 2;
        [boby addSubview:desLabel];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(boby.mas_left).offset(15);
            make.right.equalTo(boby.mas_right).offset(-90);
            make.top.equalTo(titleLabel.mas_bottom).offset(2);
            
        }];
        
        UIImageView * iconImage = [UIImageView new];
        iconImage.image = [UIImage imageNamed:@"arrow_right_middle_gray"];
        [boby addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(boby.mas_right).offset(-15);
            make.width.offset(7);
            make.height.offset(14);
            make.centerY.equalTo(boby);
        }];
        
    }
    return _header;
}

- (UIButton *)operation{
    
    if (!_operation) {
        
        _operation = [UIButton buttonWithType:UIButtonTypeCustom];
        _operation.frame = CGRectMake(0, 0, 80, 20);
        [_operation setTitle:@"薪资规则设置" forState:UIControlStateNormal];
        [_operation setTitleColor:defaultColor forState:UIControlStateNormal];
        _operation.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
    }
    return _operation;
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


@end
