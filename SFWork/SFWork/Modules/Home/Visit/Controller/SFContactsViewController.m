//
//  SFContactsViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/23.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFContactsViewController.h"
#import "SFContactsCell.h"
#import "SFVisitHttpModel.h"

static NSString * const SFContactsCellID = @"SFContactsCellID";

@interface SFContactsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFContactsViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客户联系人";
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    [SFVisitHttpModel getClientsContacts:self.uid success:^(NSArray<ContactsModel *> * _Nonnull list) {
        
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

    SFContactsCell * cell = [tableView dequeueReusableCellWithIdentifier:SFContactsCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ContactsModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactsModel * model = self.dataArray[indexPath.row];
    !self.selectItemClick?:self.selectItemClick(model);
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFContactsCell" bundle:nil] forCellReuseIdentifier:SFContactsCellID];
        
    }
    return _tableView;
}
@end
