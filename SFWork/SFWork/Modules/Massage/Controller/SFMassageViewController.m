//
//  SFMassageViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMassageViewController.h"
#import "SFConversationViewController.h"
#import "SFSystemMessageListViewController.h"
#import "SFGroupChatViewController.h"
#import "SFMassageCell.h"


static NSString * const SFMassageCellID = @"SFMassageCell";

@interface SFMassageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray * _titleArr;
}

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)SystemMessageModel * systemMsgModel;

@end

@implementation SFMassageViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
//                                          @(ConversationType_GROUP)]];
    
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self initDrawUI];
    [self initData];
    
    
}


- (void)initData{
    [MBProgressHUD showActivityMessageInView:@""];
    [SFBaseModel BGET:BASE_URL(@"/message/notification/findLast") parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD hideHUD];
        self.systemMsgModel = [SystemMessageModel modelWithJSON:model.result[@"last"]];
        self.systemMsgModel.count = [NSString stringWithFormat:@"%@",model.result[@"count"]];
        [self.conversationListTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
    
}

-(void)initDrawUI {

}

//插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{
    _titleArr = @[@"系统通知"];
    for (int i = 0; i<_titleArr.count; i++) {
        RCConversationModel *model = [[RCConversationModel alloc]init];
        model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        model.conversationTitle = _titleArr[i];
//        model.isTop = YES;
        [dataSource insertObject:model atIndex:i];
    }
    return dataSource;
}

#pragma mark - 设置cell的高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, 64, kWidth-15, 1)];
    line.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [cell.contentView  addSubview:line];
}

#pragma mark - 自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFMassageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RongYunListCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SFMassageCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.systemMsgModel) {
        cell.systemMsgModel = self.systemMsgModel;
    }
    return cell;
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
        SFSystemMessageListViewController * svc = [SFSystemMessageListViewController new];
        [self.navigationController pushViewController:svc animated:YES];
        return;
    }
    
    RCConversationViewController * conversationVC;
    if (model.conversationType == ConversationType_GROUP) {
        SFGroupChatViewController * gvc = [[SFGroupChatViewController alloc]init];
        gvc.conversationModel = model;
        conversationVC = gvc;
    }else{
        SFConversationViewController * pvc = [[SFConversationViewController alloc]init];
        pvc.conversationModel = model;
        conversationVC = pvc;
    }
    //聊天界面的聊天类型
    conversationVC.conversationType = model.conversationType;
    //需要打开和谁聊天的会话界面,和谁聊天其实是通过TargetId来联系的。
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    
    conversationVC.enableNewComingMessageIcon = YES;
    NSLog(@"===========targetId = %@",model.targetId);
    [self.navigationController pushViewController:conversationVC animated:YES];
}

#pragma mark - 设置cell的删除事件
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCConversationModel *model = [self.conversationListDataSource objectAtIndex:indexPath.row];
    if(model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    RCConversationModel * model = [self.conversationListDataSource objectAtIndex:indexPath.row];
    if(model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION){
        return @[];
    }
    // delete action
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                          {
                                              [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
                                              
                                              [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId];
                                              [self refreshConversationTableViewIfNeeded];
//                                              [self removeNotificationAction:index];
                                          }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    // read action
    // 根据cell当前的状态改变选项文字
    NSString *readTitle = model.isTop?@"取消置顶":@"置顶";
    
    // 创建action
    UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:readTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                        {
                                            model.isTop = YES;
                                            [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
//                                            [[NotificationManager instance] setRead:!isRead index:index];
                                        }];
    readAction.backgroundColor = [UIColor blueColor];
    return @[deleteAction, readAction];
}

@end
