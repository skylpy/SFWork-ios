//
//  SFJournalViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFJournalViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFJournalHttpModel.h"
#import "SFJournalBottomView.h"
#import "SFJournalCell.h"
#import "SFJournalSetCell.h"

static NSString * const SFJournalCellID = @"SFJournalCellID";
static NSString * const SFJournalSetCellID = @"SFJournalSetCellID";

@interface SFJournalViewController ()<UITableViewDelegate,UITableViewDataSource,SFSuperSuborViewControllerDelagete,DateTimePickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *managerArray;
@property (nonatomic,strong) UIButton * addFileButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) SFJournalBottomView *bottomView;
@property (nonatomic, assign) BOOL isBranch;
@property (nonatomic, strong) DateTimePickerView *timePickerView;
@property (nonatomic, strong) SFJournalModel * model;
//创建人id
@property (nonatomic, copy) NSString *createId;
//时间筛选
@property (nonatomic, copy) NSString *qCreateTime;
@end

@implementation SFJournalViewController

- (SFJournalBottomView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [SFJournalBottomView shareBottomView];
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

- (NSMutableArray *)selectArray{
    
    if (!_selectArray) {
        
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (NSMutableArray *)managerArray{
    
    if (!_managerArray) {
        _managerArray = [NSMutableArray array];
    }
    return _managerArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日报管理";
    [self setDrawUI];
    self.createId = @"";
    self.qCreateTime = @"";
    [self getManagerList];
    [self getOwerJournal];
}

- (void)getManagerList{
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFJournalHttpModel getManagerLists:nil success:^(NSArray<SFJournalListModel *> * _Nonnull list) {
        [MBProgressHUD hideHUD];
        [self.managerArray removeAllObjects];
        [self.selectArray removeAllObjects];
        [self.selectArray addObjectsFromArray:[SFJournalModel selectList]];
        [self.managerArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)getOwerJournal{
    
    [SFJournalHttpModel getMyDailyLists:nil success:^(NSArray<SFJournalListModel *> * _Nonnull list) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isBranch&&indexPath.section == 0) {
        
        return 45;
    }
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.isBranch?self.managerArray.count+1: self.dataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isBranch&&section == 0) {
        
        return self.selectArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isBranch&&indexPath.section == 0) {
        SFJournalSetCell * cell = [tableView dequeueReusableCellWithIdentifier:SFJournalSetCellID forIndexPath:indexPath];
        SFJournalModel * model = self.selectArray[indexPath.row];
        cell.model = model;
        return cell;
    }
    
    SFJournalCell * cell = [tableView dequeueReusableCellWithIdentifier:SFJournalCellID forIndexPath:indexPath];
    
    SFJournalListModel * model = self.isBranch?self.managerArray[indexPath.section-1]: self.dataArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
    
    if (self.isBranch&&(indexPath.section == 0)) {
        SFJournalModel * model = self.selectArray[indexPath.row];
        self.model = model;
        if (indexPath.row == 0) {
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.delagete = self;
            vc.type = singleType;
            vc.isSubor = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            
            [self selectTime:DatePickerViewDateMode];
        }
        return;
    }
    SFJournalListModel * model = self.isBranch?self.managerArray[indexPath.section-1]: self.dataArray[indexPath.section];
    [self updateStatue:model];
    UIViewController * vc = [NSClassFromString(@"SFJournalDateilViewController") new];
    [vc setValue:model forKey:@"model"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateStatue:(SFJournalListModel *)model {
    
    if (self.isBranch && [model.dailyStatus isEqualToString:@"UNREAD"]) {
        
        [self updateS:model];
    }
}

- (void)updateS:(SFJournalListModel *)model{
    
    [SFJournalHttpModel putDailyUpdate:model._id success:^{
        
        model.dailyStatus = @"READ";
        [self.tableView reloadData];
    } failure:nil];
}

- (void)selectTime:(DatePickerViewMode)type{
    
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    self.timePickerView = pickerView;
    pickerView.delegate = self;
    pickerView.pickerViewMode = type;
    [LSKeyWindow addSubview:pickerView];
    [pickerView showDateTimePickerView];
}
#pragma mark - delegate

- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSLog(@"%@",date);
    self.model.destitle = date;
    self.qCreateTime = date;
    if (self.model.type == 2) {
//        self.smodel.startTime = date;
    }
    if (self.model.type == 3) {
//        self.smodel.endTime = date;
    }
    [self.tableView reloadData];
    
    [self getSearchDailyLists];
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    
    self.model.destitle = employee.name;
    self.createId = employee._id;
    [self getSearchDailyLists];
}

- (void)getSearchDailyLists{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (![self.createId isEqualToString:@""]) {
        [dict setValue:self.createId forKey:@"createId"];
    }
    if (![self.qCreateTime isEqualToString:@""]) {
        [dict setValue:self.qCreateTime forKey:@"qCreateTime"];
    }
    
    [SFJournalHttpModel getSearchDailyList:dict success:^(NSArray<SFJournalListModel *> * _Nonnull list) {
        
        [self.managerArray removeAllObjects];
        [self.managerArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


- (void)setDrawUI {
    
    self.isBranch = isSuper ? YES: NO;
   
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    if (!isSuper) {
        [self.view addSubview:self.addFileButton];
        [self.addFileButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(55);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.bottom.equalTo(self.view.mas_bottom).offset(-52);
        }];
        
        
        @weakify(self)
        [[self.addFileButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            UIViewController * vc = [NSClassFromString(@"SFAddJournalViewController") new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    NSLog(@"%@",[SFInstance shareInstance].userInfo.role);
    if (isDeMgr) {
        [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.offset(50);
        }];
        
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
        
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"日报设置" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            UIViewController * vc = [[UIStoryboard storyboardWithName:@"Journal" bundle:nil] instantiateViewControllerWithIdentifier:@"SFJournalSet"];
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _rightButton;
}

- (UIButton *)addFileButton{
    
    if (!_addFileButton) {
        
        _addFileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addFileButton setImage:[UIImage imageNamed:@"btn_oval_add_green"] forState:UIControlStateNormal];
    }
    return _addFileButton;
}


#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerNib:[UINib nibWithNibName:@"SFJournalCell" bundle:nil] forCellReuseIdentifier:SFJournalCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFJournalSetCell" bundle:nil] forCellReuseIdentifier:SFJournalSetCellID];
    }
    return _tableView;
}

@end
