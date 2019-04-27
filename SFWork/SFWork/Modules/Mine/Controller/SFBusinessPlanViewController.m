//
//  SFBusinessPlanViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBusinessPlanViewController.h"
#import "SFBusinessPlanCell.h"
#import "SFBusinessPlanModel.h"
#import "SFTipDesView.h"

static NSString * const SFBusinessPlanCellID = @"SFBusinessPlanCellID";

@interface SFBusinessPlanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SFTipDesView *tipDesView;
@end

@implementation SFBusinessPlanViewController

- (SFTipDesView *)tipDesView{
    
    if (!_tipDesView) {
        _tipDesView = [SFTipDesView shareSFTipDesView];
        _tipDesView.titleLabel.text = @"请到网页端或安卓端购买套餐";
    }
    return _tipDesView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业套餐";
    [self initDrawUI];
    [self requestData];
}

- (void)requestData {
    
    [SFBusinessPlanModel getCompanyInfoBusinessPlanSuccess:^(SFBusinessPlanModel * _Nonnull model) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:model];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)initDrawUI {
    
    
    [self.view addSubview:self.tipDesView];
    [self.tipDesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.offset(35);
    }];
    
    self.view.backgroundColor = bgColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tipDesView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
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
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFBusinessPlanCell * cell = [tableView dequeueReusableCellWithIdentifier:SFBusinessPlanCellID forIndexPath:indexPath];
    SFBusinessPlanModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.layer.cornerRadius = 2;
    cell.clipsToBounds = YES;
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFBusinessPlanCell" bundle:nil] forCellReuseIdentifier:SFBusinessPlanCellID];
        
    }
    return _tableView;
}


@end
