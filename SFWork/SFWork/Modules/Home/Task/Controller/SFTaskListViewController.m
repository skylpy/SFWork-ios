//
//  SFTaskListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTaskListViewController.h"
#import "SFSelectItemView.h"
#import "SFJournalBottomView.h"
#import "SFSuperSuborViewController.h"
#import "SFTaskHttpModel.h"
#import "SFTaskCell.h"

static NSString * const SFTaskCellID = @"SFTaskCellID";

@interface SFTaskListViewController ()<UITableViewDelegate,UITableViewDataSource,SFTaskCellDelegate,SFSuperSuborViewControllerDelagete>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *managerArray;

@property (nonatomic,strong) UIButton * addTaskButton;
@property (nonatomic, strong) SFSelectItemView *selectItemView;
@property (nonatomic, strong) SFTaskListModel *taskModel;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) SFJournalBottomView *bottomView;
@property (nonatomic, assign) BOOL isBranch;
@end

@implementation SFTaskListViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)managerArray{
    
    if (!_managerArray) {
        _managerArray = [NSMutableArray array];
    }
    return _managerArray;
}

- (SFJournalBottomView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [SFJournalBottomView shareBottomView];
        [_bottomView.myButton setTitle:@"我的任务" forState:UIControlStateNormal];
        [_bottomView.myButton setTitle:@"我的任务" forState:UIControlStateSelected];
        [_bottomView.brancdButton setTitle:@"直属员工" forState:UIControlStateNormal];
        [_bottomView.brancdButton setTitle:@"直属员工" forState:UIControlStateSelected];
        
        @weakify(self)
        [_bottomView setSelectTag:^(NSInteger tag) {
            @strongify(self)
            if (tag == 0) {
                //下属
                self.isBranch = YES;
                
                [self.tableView reloadData];
            }
            if (tag == 1) {
                //我的
                self.isBranch = NO;
                [self.tableView reloadData];
            }
        }];
    }
    return _bottomView;
}

- (UIButton *)addTaskButton{
    
    if (!_addTaskButton) {
        
        _addTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addTaskButton setImage:[UIImage imageNamed:@"btn_oval_add_green"] forState:UIControlStateNormal];
    }
    return _addTaskButton;
}

- (SFSelectItemView *)selectItemView {
    
    if (!_selectItemView) {
        _selectItemView = [SFSelectItemView shareSFSelectItemView];
    }
    return _selectItemView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务管理";
    [self setDrawUI];
    
    if (!isSuper) {
        [self myTaskData];
    }
    
    if (isDeMgr||isSuper) {
        [self managerList];
    }
    
}

- (void)myTaskData{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[SFInstance shareInstance].userInfo._id forKey:@"executorId"];
    
    [SFTaskHttpModel getMyTaskList:dict success:^(SFTaskListModel * _Nonnull model) {
        
        NSArray * PROCEED = model.PROCEED;
        NSArray * UNPROVED = model.UNPROVED;
        NSArray * ACCOMPLISH = model.ACCOMPLISH;
        NSArray * UNACCOMPLISHED = model.UNACCOMPLISHED;
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:PROCEED];
        [self.dataArray addObject:UNPROVED];
        [self.dataArray addObject:ACCOMPLISH];
        [self.dataArray addObject:UNACCOMPLISHED];
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)managerList{
    
    [SFTaskHttpModel getMyTaskManagerListSuccess:^(SFTaskListModel * _Nonnull model) {
        
        NSArray * PROCEED = model.PROCEED;
        NSArray * RESULT = model.RESULT;
        NSArray * APPROVED = model.APPROVED;
    
        [self.managerArray removeAllObjects];
        [self.managerArray addObject:PROCEED];
        [self.managerArray addObject:RESULT];
        [self.managerArray addObject:APPROVED];
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
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

    return 250;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.isBranch?self.managerArray.count: self.dataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTaskCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.isBranch = self.isBranch;
    if (self.isBranch) {
        NSArray * array = self.managerArray[indexPath.section];
        cell.array = array;
        switch (indexPath.section) {
            case 0:
                cell.titleLabel.text = [NSString stringWithFormat:@"员工任务进行中：(%ld)",array.count];
                break;
            case 1:
                cell.titleLabel.text = [NSString stringWithFormat:@"任务结果待处理：(%ld)",array.count];
                break;
            case 2:
                cell.titleLabel.text = [NSString stringWithFormat:@"任务已审批：(%ld)",array.count];
                break;
            default:
                break;
        }
    }else{
        NSArray * array = self.dataArray[indexPath.section];
        cell.array = array;
        
        switch (indexPath.section) {
            case 0:
                cell.titleLabel.text = [NSString stringWithFormat:@"进行中(%ld)",array.count];
                break;
            case 1:
                cell.titleLabel.text = [NSString stringWithFormat:@"待进行(%ld)",array.count];
                break;
            case 2:
                cell.titleLabel.text = [NSString stringWithFormat:@"已完成(%ld)",array.count];
                break;
            case 3:
                cell.titleLabel.text = [NSString stringWithFormat:@"未完成(%ld)",array.count];
                break;
            default:
                break;
        }
    }
    
    @weakify(self)
    [cell setOpenTaskClick:^(NSArray<TaskListModel *> * _Nonnull array) {
        @strongify(self)
        
        UIViewController * vc = [NSClassFromString(@"SFTaskItemViewController") new];
        [vc setValue:array forKey:@"array"];
        [vc setValue:@(self.isBranch) forKey:@"isBranch"];
        NSString * title = @"";
        if (self.isBranch) {
            switch (indexPath.section) {
                case 0:
                    title = [NSString stringWithFormat:@"员工任务进行中：(%ld)",array.count];
                    break;
                case 1:
                    title = [NSString stringWithFormat:@"任务结果待处理：(%ld)",array.count];
                    break;
                case 2:
                    title = [NSString stringWithFormat:@"任务已审批：(%ld)",array.count];
                    break;
                default:
                    break;
            }
        }else{
            switch (indexPath.section) {
                case 0:
                    title = [NSString stringWithFormat:@"进行中(%ld)",array.count];
                    break;
                case 1:
                    title = [NSString stringWithFormat:@"待进行(%ld)",array.count];
                    break;
                case 2:
                    title = [NSString stringWithFormat:@"已完成(%ld)",array.count];
                    break;
                case 3:
                    title = [NSString stringWithFormat:@"未完成(%ld)",array.count];
                    break;
                default:
                    break;
            }
        }
        [vc setValue:title forKey:@"titles"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    return cell;
}

#pragma SFTaskCellDelegate
- (void)selectTaskItem:(TaskListModel *)model{
    
    UIViewController * vc = [[UIStoryboard storyboardWithName:@"SFTask" bundle:nil] instantiateViewControllerWithIdentifier:@"SFTaskDateil"];
    [vc setValue:model._id forKey:@"taskId"];
    [self.navigationController pushViewController:vc animated:YES];
}
//长按操作
- (void)LongPressGestureTaskItem:(TaskListModel *)model{
    
    NSLog(@"======");
    if (!self.isBranch) {
        ModelComfirm *item0 = [ModelComfirm comfirmModelWith:[NSString stringWithFormat:@"修改 %@.%@ 任务状态",model.taskNumber,model.taskTypeName] titleColor:Color(@"#0B0B0B") fontSize:16];
        ModelComfirm *item1 = [ModelComfirm comfirmModelWith:@"进行中" titleColor:Color(@"#0B0B0B") fontSize:16];
        ModelComfirm *item2 = [ModelComfirm comfirmModelWith:@"待进行" titleColor:Color(@"#0B0B0B") fontSize:16];
        ModelComfirm *item3 = [ModelComfirm comfirmModelWith:@"已完成" titleColor:Color(@"#0B0B0B") fontSize:16];
        ModelComfirm *item4 = [ModelComfirm comfirmModelWith:@"未完成" titleColor:Color(@"#0B0B0B") fontSize:16];
        ModelComfirm *cancelItem = [ModelComfirm comfirmModelWith:@"取消" titleColor:Color(@"#0B0B0B") fontSize:16];
        [ComfirmView showInView:LSKeyWindow cancelItemWith:cancelItem dataSource:@[item0, item1 ,item2,item3,item4] actionBlock:^(ComfirmView *view, NSInteger index) {
            
            switch (index) {
                case 1:
                    [self updateTaskId:model._id withStatus:@"PROCEED"];
                    break;
                case 2:
                     [self updateTaskId:model._id withStatus:@"UNPROVED"];
                    break;
                case 3:
                     [self updateTaskId:model._id withStatus:@"ACCOMPLISH"];
                    break;
                case 4:
                     [self updateTaskId:model._id withStatus:@"UNACCOMPLISHED"];
                    break;
                default:
                    break;
            }
        }];
    }
}


- (void)updateTaskId:(NSString *)taskId withStatus:(NSString *)status{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:taskId forKey:@"id"];
    [dict setValue:status forKey:@"taskStatus"];
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFTaskHttpModel putMyTaskManager:dict success:^{
        
        [self myTaskData];
        [MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    
    self.isBranch = NO;
    if (isSuper) {
        self.isBranch = YES;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    if (isDeMgr) {
        [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.offset(50);
        }];
        
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
        
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    if (!isSuper) {
        
        [self.view addSubview:self.addTaskButton];
        [self.addTaskButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(55);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.bottom.equalTo(self.view.mas_bottom).offset(-52);
        }];
        
        
        @weakify(self)
        [[self.addTaskButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            if (isEmployee) {
                
                UIViewController * vc = [NSClassFromString(@"SFAddTaskViewController") new];
                [vc setValue:@(YES) forKey:@"isSelf"];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                
                [self.selectItemView showFromView:LSKeyWindow withTitle:@"请问您要新增任务给谁？" withData:@[@"自己",@"员工",@"取消"] selectClick:^(NSString * _Nonnull type) {
                    
                    if (![type isEqualToString:@"取消"]) {
                        BOOL isSelf = [type isEqualToString:@"自己"]?YES:NO;
                        UIViewController * vc = [NSClassFromString(@"SFAddTaskViewController") new];
                        [vc setValue:@(isSelf) forKey:@"isSelf"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
            }
        }];
    }
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
//        _tableView.backgroundColor = bgColor;
        
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
        [_rightButton setTitle:@"查看员工" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.delagete = self;
            vc.type = singleType;
            vc.isSubor = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _rightButton;
}
//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    
    
}

@end
