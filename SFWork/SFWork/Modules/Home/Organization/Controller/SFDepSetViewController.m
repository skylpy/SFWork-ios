//
//  SFDepSetViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFDepSetViewController.h"
#import "SFProfileTableCell.h"
#import "SFOrganizationModel.h"

static NSString * const SFProfileTableCellID = @"SFProfileTableCellID";

@interface SFDepSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UIButton * bottomButton;

@property (nonatomic, strong) UIButton *letfButton;

@end

@implementation SFDepSetViewController

- (UIButton *)bottomButton{
    
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(0, 0, kWidth, 45);
        [_bottomButton setTitle:@"保存" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _bottomButton.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        _bottomButton.backgroundColor = Color(@"#01B38B");
        @weakify(self)
        [[_bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self saveDep];
            
        }];
    }
    return _bottomButton;
}

- (UIButton *)letfButton{
    
    if (!_letfButton) {
        
        _letfButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _letfButton.frame = CGRectMake(0, 0, 12, 20);
        [_letfButton setImage:[UIImage imageNamed:@"arrow_return_gray"] forState:UIControlStateNormal];
        @weakify(self)
        [[_letfButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _letfButton;
}


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"部门设置";
    
    [self initDrawUI];
    [self initData];
}

- (void)saveDep{
    
    NSMutableDictionary * dict = [SFProfileModel pramGetDepSetJson:self.dataArray];
    [dict setObject:self.model._id forKey:@"id"];
    [MBProgressHUD showActivityMessageInView:@"保存中"];
    [SFOrganizationModel updateCompanyDep:dict success:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"成功"];
        !self.didSaveClick?:self.didSaveClick();
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"失败"];
    }];
}


- (void)initData{
    
    NSArray * array = [SFProfileModel shareDepSetModel:self.model withDepName:self.parentName withParentId:self.parentId];
    
    [self.dataArray addObjectsFromArray:array];
    
    [self.tableView reloadData];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.bottomButton];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(45);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.letfButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFProfileTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFProfileTableCellID forIndexPath:indexPath];
    
    SFProfileModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
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
        
        
        UIView * buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 55)];
        buttomView.backgroundColor = [UIColor clearColor];
        
        UIButton * deleteButtom = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButtom.frame = CGRectMake(0, 10, kWidth, 45);
        deleteButtom.backgroundColor = [UIColor whiteColor];
        [deleteButtom setTitleColor:Color(@"#FF715A") forState:UIControlStateNormal];
        [deleteButtom setTitle:@"删除部门" forState:UIControlStateNormal];
        deleteButtom.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [buttomView addSubview:deleteButtom];
        @weakify(self)
        [[deleteButtom rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [UIAlertController alertTitle:@"温馨提示" mesasge:@"您要删除这个部门？" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *alertAction) {
                
                [self deleteDep];
            } cancleHandler:^(UIAlertAction * cancel) {
                
            } viewController:self];
        }];
        _tableView.tableFooterView = buttomView;
    }
    return _tableView;
}

- (void)deleteDep{
    
    [MBProgressHUD showActivityMessageInView:@""];
    [SFOrganizationModel deleteDepartments:self.model._id success:^{
        
        [MBProgressHUD hideHUD];
        !self.didDeleteClick?:self.didDeleteClick();
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

@end
