//
//  SFSystemMessageListViewController.m
//  SFWork
//
//  Created by fox on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSystemMessageListViewController.h"
#import "SFSystemMessageDetailViewController.h"

#import "SFSystemMessageCell.h"
#import "SFSystemMessageModel.h"

@interface SFSystemMessageListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSInteger pageNum;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * titleArray;

@end

@implementation SFSystemMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self requestData];
}

- (void)initUI{
    self.title = @"系统消息";
    self.titleArray = [NSMutableArray array];
    self.pageNum = 0;
    
    UIButton * redIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redIconBtn.frame = CGRectMake(0, 0, 65, 44);
    redIconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    redIconBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    redIconBtn.tag = 1000;
    [redIconBtn setTitle:@"全部已读" forState:0];
    [redIconBtn setTitleColor:[UIColor colorWithRed:40/255.0 green:179/255.0 blue:139/255.0 alpha:1.0] forState:0];
    [redIconBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * redItem = [[UIBarButtonItem alloc]initWithCustomView:redIconBtn];
    
    UIButton * rightIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightIconBtn.frame = CGRectMake(0, 0, 35, 44);
    rightIconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightIconBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightIconBtn setTitle:@"清空" forState:0];
    [rightIconBtn setTitleColor:[UIColor colorWithRed:40/255.0 green:179/255.0 blue:139/255.0 alpha:1.0] forState:0];
    [rightIconBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * clearItem = [[UIBarButtonItem alloc]initWithCustomView:rightIconBtn];
    self.navigationItem.rightBarButtonItems = @[clearItem,redItem];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerNib:[UINib nibWithNibName:@"SFSystemMessageCell" bundle:nil] forCellReuseIdentifier:@"SFSystemMessageCell"];
    }
    return _tableView;
}

//获取数据
- (void)requestData{
    NSMutableDictionary * prams = [NSMutableDictionary dictionary];
    [prams setObject:@(self.pageNum) forKey:@"pageNum"];
    [prams setObject:@"10" forKey:@"pageSize"];
    [SFSystemMessageModel getSystemMessageList:prams success:^(NSArray<SystemMessageModel *> * _Nonnull list) {
        [self.titleArray removeAllObjects];
        [self.titleArray addObjectsFromArray:list];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)rightBtnAction:(UIButton *)sender{
    if (sender.tag == 1000) {
        [SFBaseModel BPOST:BASE_URL(@"/message/notification/readAll") parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
            self.pageNum = 0;
            [self.titleArray removeAllObjects];
            [self requestData];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
        }];
    }else{
        [SFBaseModel DELETE:BASE_URL(@"/message/notification/clearAll") parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
            [self.titleArray removeAllObjects];
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
        }];
    }
//
//    [SFBaseModel BPOST:BASE_URL(@"/message/notification/createTestData") parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
//
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//
//    }];
}


#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemMessageModel * model = self.titleArray[indexPath.row];
    SFSystemMessageDetailViewController * svc = [SFSystemMessageDetailViewController new];
    svc.messageId = model.ID;
    svc.readBlock = ^{
        model.status = @"READ";
        SFSystemMessageCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.model = model;
    };
    [self.navigationController pushViewController:svc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFSystemMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFSystemMessageCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SystemMessageModel * model = self.titleArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

#pragma mark - 设置cell的删除事件
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    // delete action
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                          {
                                              SystemMessageModel * model = self.titleArray[indexPath.row];
                                              [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
                                              NSString * urlStr = [NSString stringWithFormat:@"/message/notification/%@",model.ID];
                                              [SFBaseModel DELETE:BASE_URL(urlStr) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
                                                  [self.titleArray removeObjectAtIndex:indexPath.row];
                                                  [self.tableView reloadData];
                                              } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                  
                                              }];
                                          }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    
    return @[deleteAction];
}

@end
