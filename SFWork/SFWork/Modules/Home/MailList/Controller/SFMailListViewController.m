//
//  SFMailListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMailListViewController.h"
#import "SFConversationViewController.h"
#import "SFMailListTableCell.h"
#import "SFMailHttpModel.h"
#import "SFSearchView.h"

static NSString * const SFMailListTableCellID = @"SFMailListTableCellID";

@interface SFMailListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation SFMailListViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    [self initData];
    [self initDrawUI];
}


- (void)initData{
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFMailHttpModel getMailEmployeeContacts:@{@"searchText":@""} success:^(NSArray<ContactsList *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

-(void)initDrawUI {
    
    SFSearchView * searchView = [SFSearchView shareSFSearchViewView];
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.offset(44);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(searchView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFMailListTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFMailListTableCellID forIndexPath:indexPath];
    ContactsList * model = self.dataArray[indexPath.row];
    cell.model = model;
    @weakify(self)
    [cell setTellPhoneClick:^(NSString * _Nonnull phone) {
        @strongify(self)
        NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }];
    [cell setChatClcik:^(ContactsList * _Nonnull mode) {
        @strongify(self)
        if (mode.rongCloudId == nil || mode.rongCloudId.length == 0) {
            [MBProgressHUD showErrorMessage:@"当前用户不存在!"];
            return;
        }
        SFConversationViewController *conversationVC = [[SFConversationViewController alloc]init];
        //聊天界面的聊天类型
        conversationVC.conversationType = ConversationType_PRIVATE;
        //需要打开和谁聊天的会话界面,和谁聊天其实是通过TargetId来联系的。
        conversationVC.targetId = mode.rongCloudId;
        conversationVC.title = mode.name;
        conversationVC.enableNewComingMessageIcon = YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count>indexPath.row) {
        ContactsList * model = self.dataArray[indexPath.row];
        
    }
    
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFMailListTableCell" bundle:nil] forCellReuseIdentifier:SFMailListTableCellID];
        
    
    }
    return _tableView;
}


@end
