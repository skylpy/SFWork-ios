//
//  SFSelectDepEmpViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectDepEmpViewController.h"
#import "SFOrganizationModel.h"
#import "SFEmployeeCell.h"

static NSString * const SFEmployeeCellID = @"SFEmployeeCellID";

@interface SFSelectDepEmpViewController ()<UITableViewDelegate,UITableViewDataSource,SFEmployeeCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation SFSelectDepEmpViewController

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

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 40, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _rightButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择部门员工";
    [self initDrawUI];
}

- (void)setOrgModel:(SFOrgListModel *)orgModel{
    _orgModel = orgModel;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:orgModel.employees];
    [self.tableView reloadData];
}


-(void)initDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    if (self.type == multipleType) {
        
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
        
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFEmployeeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFEmployeeCellID forIndexPath:indexPath];
    SFEmployeesModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.type = self.type;
    cell.delegate = self;
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == multipleType) return;
    
    SFEmployeesModel * model = self.dataArray[indexPath.row];
    
    !self.selectEmoClick?:self.selectEmoClick(model);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFEmployeeCell" bundle:nil] forCellReuseIdentifier:SFEmployeeCellID];
    }
    return _tableView;
}
@end
