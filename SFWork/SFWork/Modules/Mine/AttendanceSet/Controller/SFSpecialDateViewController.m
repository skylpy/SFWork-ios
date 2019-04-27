//
//  SFSpecialDateViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSpecialDateViewController.h"
#import "SFAddClockTimeViewController.h"
#import "SFSpecialTimeViewController.h"
#import "SFNoClockDateViewController.h"
#import "SFPunchClockTimeCell.h"

static NSString * const SFPunchClockTimeCellID = @"SFPunchClockTimeCellID";

@interface SFSpecialDateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionArray1;
@property (nonatomic, strong) NSMutableArray *sectionArray2;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic,strong) UIButton * saveButton;
@end

@implementation SFSpecialDateViewController

- (NSMutableArray *)sectionArray1{
    
    if (!_sectionArray1) {
        _sectionArray1 = [NSMutableArray array];
    }
    return _sectionArray1;
}

- (NSMutableArray *)sectionArray2{
    
    if (!_sectionArray2) {
        _sectionArray2 = [NSMutableArray array];
    }
    return _sectionArray2;
}

- (NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"必须打卡的日期",@"不需打卡的日期", nil];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"特殊日期";
    [self setDrawUI];
}

- (void)setArray:(NSArray *)array{
    _array = array;
    [self.sectionArray1 removeAllObjects];
    [self.sectionArray2 removeAllObjects];
    for (SpecialDateModel * mod in array) {
        
        if ([mod.specialDateType isEqualToString:@"CHECKIN"] ) {
            [self.sectionArray1 addObject:mod];
        }else{
            [self.sectionArray2 addObject:mod];
        }
    }
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.top.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    footerView.backgroundColor = Color(@"#FFFFFF");
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_add_sheet_green"] forState:UIControlStateNormal];
    [button setTitle:@" 添加" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
    [button setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
    button.frame = CGRectMake(15, 0, kWidth-30, 50);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [footerView addSubview:button];
    @weakify(self)
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (section == 0) {
            SFSpecialTimeViewController * vc = [SFSpecialTimeViewController new];
            @weakify(self)
            [vc setAddTimeClick:^(SpecialDateModel * _Nonnull model) {
                @strongify(self)
                [self.sectionArray1 addObject:model];
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            SFNoClockDateViewController * vc = [SFNoClockDateViewController new];
            @weakify(self)
            [vc setAddTimeClick:^(SpecialDateModel * _Nonnull model) {
                @strongify(self)
                [self.sectionArray2 addObject:model];
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:self.titleArray[section] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kRegFont size:12];
    [button setTitleColor:Color(@"#999999") forState:UIControlStateNormal];
    button.frame = CGRectMake(15,10, kWidth-30, 40);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [footerView addSubview:button];
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return self.sectionArray1.count;
    }
    return self.sectionArray2.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFPunchClockTimeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPunchClockTimeCellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        SpecialDateModel * model = self.sectionArray1[indexPath.row];
        cell.smodel = model;
    }else{
        SpecialDateModel * model = self.sectionArray2[indexPath.row];
        cell.smodel = model;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFPunchClockTimeCell" bundle:nil] forCellReuseIdentifier:SFPunchClockTimeCellID];
        
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
        footerView.backgroundColor = Color(@"#FFFFFF");
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"btn_add_sheet_green"] forState:UIControlStateNormal];
        [button setTitle:@" 添加打卡时间" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [button setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
        button.frame = CGRectMake(15, 0, kWidth-30, 40);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [footerView addSubview:button];
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            SFAddClockTimeViewController * vc = [NSClassFromString(@"SFAddClockTimeViewController") new];
            @weakify(self)
            [vc setAddTimeClick:^(AttendanceDateModel * _Nonnull model) {
                @strongify(self)
                
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
//        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"提交" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#01B38B");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            NSMutableArray * array = [NSMutableArray array];
            for (SpecialDateModel * model  in self.sectionArray1) {
                [array addObject:model];
            }
            for (SpecialDateModel * model  in self.sectionArray2) {
                [array addObject:model];
            }
            !self.selectAllClick?:self.selectAllClick(array);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _saveButton;
}


@end
