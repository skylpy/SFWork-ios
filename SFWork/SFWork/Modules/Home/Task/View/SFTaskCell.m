//
//  SFTaskCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTaskCell.h"
#import "SFTaskListCell.h"
#import "SFBTaskListCell.h"

static NSString * const SFTaskListCellID = @"SFTaskListCellID";
static NSString * const SFBTaskListCellID = @"SFBTaskListCellID";

@interface SFTaskCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation SFTaskCell

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.clipsToBounds = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFTaskListCell" bundle:nil] forCellReuseIdentifier:SFTaskListCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFBTaskListCell" bundle:nil] forCellReuseIdentifier:SFBTaskListCellID];
    
    @weakify(self)
    [[self.openButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.openTaskClick?:self.openTaskClick(self.array);
    }];
    
}

- (void)setArray:(NSArray<TaskListModel *> *)array{
    _array = array;
    [self.dataArray removeAllObjects];
    
    [self.dataArray addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (void)setIsBranch:(BOOL)isBranch{
    _isBranch = isBranch;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isBranch) {
        
        return 90;
    }
    return 66;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isBranch) {
        SFBTaskListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFBTaskListCellID forIndexPath:indexPath];
        TaskListModel * model = self.dataArray[indexPath.section];
        cell.model = model;
        @weakify(self)
        [cell setGestureClick:^(TaskListModel * _Nonnull tmodel) {
            @strongify(self)
            [self LongPressGesture:tmodel];
        }];
        return cell;
    }
    SFTaskListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTaskListCellID forIndexPath:indexPath];
    TaskListModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    @weakify(self)
    [cell setGestureClick:^(TaskListModel * _Nonnull tmodel) {
        @strongify(self)
        [self LongPressGesture:tmodel];
    }];
    return cell;
}

- (void)LongPressGesture:(TaskListModel *)model{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LongPressGestureTaskItem:)]) {
        
        [self.delegate LongPressGestureTaskItem:model];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskListModel * model = self.dataArray[indexPath.section];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTaskItem:)]) {
        
        [self.delegate selectTaskItem:model];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
