
//
//  SFAboutMeViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAboutMeViewController.h"
#import "SFWebViewController.h"
#import "SFAboutTableCell.h"
#import "SFAboutMeModel.h"
#import "SFAboutHeaderView.h"

static NSString * const SFAboutTableCellID = @"SFAboutTableCellID";

@interface SFAboutMeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, strong) SFAboutHeaderView *headerView;

@end

@implementation SFAboutMeViewController


- (SFAboutHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [SFAboutHeaderView shareSFAboutHeaderView];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    [self initDrawUI];
    [self initData];
}

- (void)initData{
    
    NSArray * array = [SFAboutMeModel shareAboutModel];
    
    [self.dataArray addObjectsFromArray:array];
    
    [self.tableView reloadData];
}

-(void)initDrawUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 236;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFAboutTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAboutTableCellID forIndexPath:indexPath];
    SFAboutMeModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFAboutMeModel * model = self.dataArray[indexPath.row];
    if (model.type == 0) {
        SFWebViewController * vc = [SFWebViewController new];
        NSString * url = [NSString stringWithFormat:@"http://%@",model.detitle];
        vc.urlString = url;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (model.type == 1) {
        SFWebViewController * vc = [SFWebViewController new];
        
        vc.urlString = BASE_URL(@"/common/protocol.html");
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (model.type == 3) {
        
        NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@",model.detitle];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];

    }
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFAboutTableCell" bundle:nil] forCellReuseIdentifier:SFAboutTableCellID];
        
    }
    return _tableView;
}


@end
