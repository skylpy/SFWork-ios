
//
//  SFAssessmentSetViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAssessmentSetViewController.h"
#import "SFAssessmentListViewController.h"
#import "SFAssessmentSetListCell.h"
#import "SFWorkAssessHttpModel.h"

static NSString * const SFAssessmentSetListCellID = @"SFAssessmentSetListCellID";

@interface SFAssessmentSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFAssessmentSetViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考核设置";
    
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    [MBProgressHUD showActivityMessageInView:@""];
    [SFWorkAssessHttpModel workAssessCheckList:nil success:^(NSArray<SFWorkAssessItemModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFAssessmentSetListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAssessmentSetListCellID forIndexPath:indexPath];
    SFWorkAssessItemModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFWorkAssessItemModel * model = self.dataArray[indexPath.row];
    SFAssessmentListViewController * vc = [SFAssessmentListViewController new];
    vc.module = model.code;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFAssessmentSetListCell" bundle:nil] forCellReuseIdentifier:SFAssessmentSetListCellID];
        
    }
    return _tableView;
}

@end
