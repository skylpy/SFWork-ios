//
//  SFSearchResultViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/15.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSearchResultViewController.h"
#import "SFCustomerCell.h"

static NSString * const SFCustomerCellID = @"SFCustomerCellID";

@interface SFSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SFSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    
    [self setDrawUI];
}
- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.resultArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFCustomerCell * cell = [tableView dequeueReusableCellWithIdentifier:SFCustomerCellID forIndexPath:indexPath];
    SFClientModel * model = self.resultArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFClientModel * model = self.resultArr[indexPath.row];
    UIViewController * vc = [NSClassFromString(@"SFCBDateilViewController") new];
    [vc setValue:model forKey:@"model"];
    [vc setValue:@(self.type) forKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
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
