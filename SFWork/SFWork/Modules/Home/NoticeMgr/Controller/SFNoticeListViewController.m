
//
//  SFNoticeListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFNoticeListViewController.h"
#import "SFAnnounceDateilViewController.h"
#import "SFAnnounceHeaderView.h"
#import "SFAnnounceHttpModel.h"
#import "SFNoticeListCell.h"

static NSString * const SFNoticeListCellID = @"SFNoticeListCellID";

@interface SFNoticeListViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *undataArray;
@property (nonatomic, strong) NSMutableArray *dataedArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SFAnnounceHeaderView *announceHeaderView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) BOOL publish;
@property (nonatomic, assign) NSInteger pagedNum;
@property (nonatomic, assign) NSInteger upageNum;

@end

@implementation SFNoticeListViewController

- (NSMutableArray *)dataedArray{
    
    if (!_dataedArray) {
        _dataedArray = [NSMutableArray array];
    }
    return _dataedArray;
}

- (NSMutableArray *)undataArray{
    
    if (!_undataArray) {
        _undataArray = [NSMutableArray array];
    }
    return _undataArray;
}

- (SFAnnounceHeaderView *)announceHeaderView{
    
    if (!_announceHeaderView) {
        
        _announceHeaderView = [SFAnnounceHeaderView shareSFAnnounceHeaderView];
        @weakify(self)
        [_announceHeaderView setSelectItemClcik:^(NSInteger index) {
            @strongify(self)
            if (index == 0) {
                self.publish = YES;
                if (self.dataedArray.count == 0) {
                    [self getListData];
                }
            }else{
                self.publish = NO;
                if (self.undataArray.count == 0) {
                    [self getListData];
                }
            }
            [self.tableView reloadData];
        }];
    }
    return _announceHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    [self getListData];
}

- (void)headerLoading{
    
    if (self.publish) {
        self.pagedNum = 1;
    }else{
        self.upageNum = 1;
    }
    [self getListData];
}

- (void)footerLoading{
    
    if (self.publish) {
        self.pagedNum ++;
    }else{
        self.upageNum ++;
    }
    [self getListData];
}

- (void)getListData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (self.publish) {
        [dict setValue:@(self.pagedNum) forKey:@"pageNum"];
    }else{
        [dict setValue:@(self.upageNum) forKey:@"pageNum"];
    }
    
    [dict setValue:@"15" forKey:@"pageSize"];
    [dict setValue:@(self.publish) forKey:@"publish"];
    [dict setValue:self.date forKey:@"qCreateTime"];
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFAnnounceHttpModel getAnnounceList:dict success:^(NSArray<SFAnnounceListModel *> * _Nonnull list) {
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if (self.publish) {
            [self.dataedArray removeAllObjects];
            [self.dataedArray addObjectsFromArray:list];
        }else{
            [self.undataArray removeAllObjects];
            [self.undataArray addObjectsFromArray:list];
        }
       
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setDrawUI {
    
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.date = [NSDate dateWithFormat:@"yyyy-MM-dd"];
    self.publish = YES;
    self.pagedNum = 1;
    self.upageNum = 1;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerLoading)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoading)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (!isEmployee) {
            make.top.equalTo(self.view.mas_top).offset(46);
            make.left.right.bottom.equalTo(self.view);
        }else{
            make.top.left.right.bottom.equalTo(self.view);
        }

    }];
    
    if (!isEmployee) {
        [self.view addSubview:self.announceHeaderView];
        [self.announceHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.offset(46);
        }];
    }
    
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(55);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-52);
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.publish ? self.dataedArray.count : self.undataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFNoticeListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFNoticeListCellID forIndexPath:indexPath];
    SFAnnounceListModel * model = self.publish ? self.dataedArray[indexPath.section] : self.undataArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFAnnounceListModel * model = self.publish ? self.dataedArray[indexPath.section] : self.undataArray[indexPath.section];
    SFAnnounceDateilViewController * vc = [SFAnnounceDateilViewController new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFNoticeListCell" bundle:nil] forCellReuseIdentifier:SFNoticeListCellID];
    }
    return _tableView;
}

- (UIButton *)addButton{
    
    if (!_addButton) {
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"btn_oval_add_green"] forState:UIControlStateNormal];
        @weakify(self)
        [[_addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            UIViewController * vc = [NSClassFromString(@"SFAddAnnounceViewController") new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _addButton;
}


- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"日期筛选" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            [self selectTime:DatePickerViewDateMode];
        }];
    }
    return _rightButton;
}

- (void)selectTime:(DatePickerViewMode)type{
    
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    
    pickerView.delegate = self;
    pickerView.pickerViewMode = type;
    [LSKeyWindow addSubview:pickerView];
    [pickerView showDateTimePickerView];
}
#pragma mark - delegate

- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSLog(@"%@",date);
    self.date = date;
    
    [self getListData];
}

@end
