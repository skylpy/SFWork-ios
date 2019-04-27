//
//  SFSelCustomerViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelCustomerViewController.h"
#import "SFCustomerHttpModel.h"
#import "SFCustomerCell.h"

static NSString * const SFCustomerCellID = @"SFCustomerCellID";

@interface SFSelCustomerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SFSelCustomerViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择客户";
    [self setDrawUI];
    [self myCustomerData];
}

- (void)myCustomerData {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@"CLIENT" forKey:@"clientGroup"];
    
    [SFCustomerHttpModel getMyCompanyClient:dic success:^(NSArray<SFClientModel *> * _Nonnull list) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.top.left.right.equalTo(self.view);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFCustomerCell * cell = [tableView dequeueReusableCellWithIdentifier:SFCustomerCellID forIndexPath:indexPath];
    SFClientModel * model =  self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFClientModel * model =  self.dataArray[indexPath.row];
    !self.selCustomerClick?:self.selCustomerClick(model);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerNib:[UINib nibWithNibName:@"SFCustomerCell" bundle:nil] forCellReuseIdentifier:SFCustomerCellID];
    }
    return _tableView;
}

@end
