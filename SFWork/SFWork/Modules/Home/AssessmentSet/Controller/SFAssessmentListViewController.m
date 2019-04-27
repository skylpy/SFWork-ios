//
//  SFAssessmentListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAssessmentListViewController.h"
#import "SFAssessmentRuleViewController.h"
#import "SFAssessmentListCell.h"
#import "SFWorkAssessHttpModel.h"

static NSString * const SFAssessmentListCellID = @"FAssessmentListCellID";


@interface SFAssessmentListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation SFAssessmentListViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.module isEqualToString:@"REPORT"]?
    @"汇报":[self.module isEqualToString:@"ATTENDANCE"]?
    @"考勤":[self.module isEqualToString:@"TASK"]?
    @"任务":[self.module isEqualToString:@"DAILY"]?
    @"日报":[self.module isEqualToString:@"VISIT"]?
    @"拜访":@"自定义";
    
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@"1" forKey:@"pageNum"];
    [dict setValue:@"15" forKey:@"pageSize"];
    [dict setValue:@[self.module] forKey:@"checkModules"];
    [MBProgressHUD showActivityMessageInView:@""];
    [SFWorkAssessHttpModel workAssessCheckSearch:dict success:^(NSArray<SFWorkCheckItemModel *> * _Nonnull list) {
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(55);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-52);
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 105;
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
    
    SFAssessmentListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAssessmentListCellID forIndexPath:indexPath];
    SFWorkCheckItemModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFWorkCheckItemModel * model = self.dataArray[indexPath.section];
    SFAssessmentRuleViewController * vc = [NSClassFromString(@"SFAssessmentRuleViewController") new];
    [vc setValue:self.module forKey:@"module"];
    vc.smodel = model;
    vc.isEditor = YES;
    @weakify(self)
    [vc setAddAssessmentClick:^{
        @strongify(self)
        [self requestData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFAssessmentListCell" bundle:nil] forCellReuseIdentifier:SFAssessmentListCellID];
        
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
            SFAssessmentRuleViewController * vc = [NSClassFromString(@"SFAssessmentRuleViewController") new];
            
            [vc setValue:self.module forKey:@"module"];
            @weakify(self)
            [vc setAddAssessmentClick:^{
                @strongify(self)
                [self requestData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _addButton;
}


@end
