//
//  SFTaskItemViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTaskItemViewController.h"
#import "SFTaskSearchViewController.h"
#import "SFTaskCell.h"

static NSString * const SFTaskCellID = @"SFTaskCellID";

@interface SFTaskItemViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation SFTaskItemViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.isBranch ? @"下属任务":@"我的任务";
    [self setDrawUI];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setArray:(NSArray<TaskListModel *> *)array{
    _array = array;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kHeight-60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTaskCellID forIndexPath:indexPath];
    
    cell.array = self.dataArray;
    cell.isBranch = self.isBranch;
    cell.titleLabel.text = self.titles;
    cell.openButton.hidden = YES;
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFTaskCell" bundle:nil] forCellReuseIdentifier:SFTaskCellID];
    }
    return _tableView;
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"详细搜索" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            SFTaskSearchViewController * vc = [NSClassFromString(@"SFTaskSearchViewController") new];
            [vc setTaskSearchClick:^(NSArray<TaskListModel *> * _Nonnull list) {
                
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:list];
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _rightButton;
}

@end
