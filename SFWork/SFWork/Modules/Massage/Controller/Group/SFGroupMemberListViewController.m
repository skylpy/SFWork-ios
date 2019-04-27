//
//  SFGroupMemberListViewController.m
//  ClassForEvery
//
//  Created by Adam on 2019/4/2.
//  Copyright © 2019年 Adam. All rights reserved.
//

#import "SFGroupMemberListViewController.h"
#import "SFMemberListCell.h"
#import "SFGroupMemberModel.h"

@interface SFGroupMemberListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray * memberList;
@end

@implementation SFGroupMemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)setGroupInfoModel:(SFGroupInfoModel *)groupInfoModel{
    if (groupInfoModel != nil) {
        _groupInfoModel = groupInfoModel;
        self.title = [NSString stringWithFormat:@"群成员(%ld)",groupInfoModel.members.count];
        [self.memberList removeAllObjects];
        [self.memberList addObjectsFromArray:_groupInfoModel.members];
        [self.tableView reloadData];
    }
    
}

- (void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    [_tableView registerNib:[UINib nibWithNibName:@"SFMemberListCell" bundle:nil] forCellReuseIdentifier:@"SFMemberListCell"];
    [self.view addSubview:_tableView];
    
}

- (NSMutableArray *)memberList{
    if (_memberList==nil) {
        _memberList = [NSMutableArray array];
    }
    
    return _memberList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _memberList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFMemberListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFMemberListCell"];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (_memberList.count>indexPath.row) {
        SFGroupMemberModel * model = _memberList[indexPath.row];
        [cell.headIMG setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:DefaultImage];
        cell.nameLB.text = model.name;
        if ([model.employeeId isEqualToString:self.groupInfoModel.masterId]) {
            cell.departMentLB.text = @"群主";
            cell.departMentLB.hidden = NO;
        }else{
            cell.departMentLB.hidden = YES;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
#pragma mark - 设置cell的删除事件
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFGroupMemberModel * model = self.memberList[indexPath.row];
    if ([model.employeeId isEqualToString:self.groupInfoModel.masterId]) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SFGroupMemberModel * model = self.memberList[indexPath.row];
    if ([model.employeeId isEqualToString:self.groupInfoModel.masterId]) {
        return @[];
    }
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                          {
                                              [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
                                            
                                              //                                              [self removeNotificationAction:index];
                                              if (self.memberList.count>indexPath.row) {
                                                  [self removeGroupMember:model.employeeId Row:indexPath.row];
                                              }
                                          }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction];
}

- (void)removeGroupMember:(NSString *)memberId Row:(NSInteger)row{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@[memberId] forKey:@"memberIds"];
    [params setObject:_groupInfoModel.ID forKey:@"id"];
    [SFBaseModel BPOST:BASE_URL(@"/message/chat/group/quit") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD showInfoMessage:@"删除成功"];
        [self.memberList removeObjectAtIndex:row];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD showInfoMessage:@"删除失败"];
    }];
}

@end
