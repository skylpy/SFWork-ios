//
//  SFLocationInforViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFLocationInforViewController.h"
#import "SFAddClockTimeViewController.h"
#import "SFPunchPositionViewController.h"
#import "SFPunchClockTimeCell.h"

static NSString * const SFPunchClockTimeCellID = @"SFPunchClockTimeCellID";

@interface SFLocationInforViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton * saveButton;

@end

@implementation SFLocationInforViewController


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"位置列表";
    [self setDrawUI];
}

- (void)setArray:(NSArray *)array{
    _array = array;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
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
    
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFPunchClockTimeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPunchClockTimeCellID forIndexPath:indexPath];
    SFAddressModel * model = self.dataArray[indexPath.row];
    cell.amodel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AttendanceDateModel * model = self.dataArray[indexPath.row];
    !self.selectTimeClick?:self.selectTimeClick(model);
    [self.navigationController popViewControllerAnimated:YES];
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
        [button setTitle:@" 添加位置" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [button setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
        button.frame = CGRectMake(15, 0, kWidth-30, 40);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [footerView addSubview:button];
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            SFPunchPositionViewController *vc = [[SFPunchPositionViewController alloc] init];
            vc.selectedEvent = ^(CLLocationCoordinate2D coordinate, NSString *addressName, NSString *province, NSString *city, NSString *distract, NSString *address,NSString * distance) {
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:address forKey:@"addresskeyword"];
                [dict setValue:addressName forKey:@"address"];
                [dict setValue:@(coordinate.longitude) forKey:@"longitude"];
                [dict setValue:@(coordinate.latitude) forKey:@"latitude"];
                [dict setValue:distance forKey:@"scope"];
                [dict setValue:[NSDate stringFromDate:[NSDate new] withFormatter:@"yyyy-MM-dd hh:mm:ss"] forKey:@"createTime"];
                
                SFAddressModel * model = [SFAddressModel modelWithJSON:dict];
                [self.dataArray addObject:model];
                
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        _tableView.tableFooterView = footerView;
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
            
            !self.selectTimeClick?:self.selectTimeClick(self.dataArray);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _saveButton;
}

@end
