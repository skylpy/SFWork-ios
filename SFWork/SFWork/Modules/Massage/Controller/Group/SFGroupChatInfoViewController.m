//
//  SFGroupChatInfoViewController.m
//  ClassForEvery
//
//  Created by Adam on 2019/4/2.
//  Copyright © 2019年 Adam. All rights reserved.
//

#import "SFGroupChatInfoViewController.h"
#import "SFGroupManagerViewController.h"
#import "SFGroupMemberListViewController.h"
#import "SFChatHistoryViewController.h"
#import "SFChangeGroupNameViewController.h"
#import "SFAllContactListViewController.h"
#import "SFGroupSwithBtnWithTipCell.h"
#import "SFAddGroupMemberCell.h"
#import "SFAddMemberCell.h"
#import "SFSelectSwitchBtnCell.h"
#import "SFGroupMemberModel.h"

@interface SFGroupChatInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray * _titleArray;
    NSArray * _tipArray;
}
@property (strong, nonatomic) UIButton * dissolveBtn;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) SFGroupInfoModel * groupInfoModel;
@end

@implementation SFGroupChatInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"聊天信息";
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestGroupInfo];
}

- (void)initUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    [_tableView registerNib:[UINib nibWithNibName:@"SFAddGroupMemberCell" bundle:nil] forCellReuseIdentifier:@"SFAddGroupMemberCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SFAddMemberCell" bundle:nil] forCellReuseIdentifier:@"SFAddMemberCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SFSelectSwitchBtnCell" bundle:nil] forCellReuseIdentifier:@"SFSelectSwitchBtnCell"];
    [self.view addSubview:_tableView];
    
}

- (UIView *)createTableFootView{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70)];
    UIButton * dissolveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dissolveBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45);
    [dissolveBtn setTitle:@"退出群聊" forState:0];
    [dissolveBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:113/255.0 blue:90/255.0 alpha:1.0] forState:0];
    dissolveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    dissolveBtn.backgroundColor = [UIColor whiteColor];
    [dissolveBtn addTarget:self action:@selector(outGroup) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:dissolveBtn];
    _dissolveBtn = dissolveBtn;
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        SFGroupManagerViewController * groupManagerVC = [SFGroupManagerViewController new];
        groupManagerVC.groupInfoModel = self.groupInfoModel;
        groupManagerVC.conversationModel = _conversationModel;
        [self.navigationController pushViewController:groupManagerVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        SFGroupMemberListViewController * memberListVC = [SFGroupMemberListViewController new];
        if (self.groupInfoModel != nil) {
            memberListVC.groupInfoModel = self.groupInfoModel;
        }
        [self.navigationController pushViewController:memberListVC animated:YES];
    }else if (indexPath.section==4&&indexPath.row==0){
        SFChatHistoryViewController * svc = [SFChatHistoryViewController new];
        svc.conversationModel = _conversationModel;
        [self.navigationController pushViewController:svc animated:YES];
    }else if (indexPath.section==4&&indexPath.row==1){
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定清除当前聊天的消息记录？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了取消按钮");
            
        }];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了好的按钮");
            //                BOOL success = [[RCIMClient sharedRCIMClient] clearMessages:self.conversationModel.conversationType targetId:self.conversationModel.targetId];
            RCMessage * lastMessage = [[[RCIMClient sharedRCIMClient] getLatestMessages:self.conversationModel.conversationType targetId:self.conversationModel.targetId count:1] firstObject];
            [[RCIMClient sharedRCIMClient] deleteMessages:self.conversationModel.conversationType targetId:self.conversationModel.targetId success:^{
                NSLog(@"===========>>>>>>>>>>清理成功");
            } error:^(RCErrorCode status) {
                NSLog(@"===========>>>>>>>>>>清理失败");
            }];
            
            [[RCIMClient sharedRCIMClient] clearRemoteHistoryMessages:self.conversationModel.conversationType targetId:self.conversationModel.targetId recordTime:lastMessage.receivedTime success:^{
                
            } error:^(RCErrorCode status) {
                
            }];
            [MBProgressHUD showSuccessMessage:@"清理成功"];
        }];
        
        
        [alter addAction:cancleAction];
        [alter addAction:defaultAction];
        [self presentViewController:alter animated:YES completion:nil];
    }else if (indexPath.section==0){
        SFChangeGroupNameViewController * cvc = [SFChangeGroupNameViewController new];
        cvc.groupName = _groupInfoModel.name;
        cvc.groupID = _groupInfoModel.ID;
        UINavigationController * navc = [[UINavigationController alloc]initWithRootViewController:cvc];
        [self presentViewController:navc animated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * array = _titleArray[section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            SFAddMemberCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFAddMemberCell"];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.addActionBlock = ^{
                SFAllContactListViewController * selectVC = [SFAllContactListViewController new];
                selectVC.title = @"添加群成员";
                selectVC.isAddGroupMember = YES;
                selectVC.currChatId = self.groupInfoModel.ID;
                [self.navigationController pushViewController:selectVC animated:YES];
            };
            return cell;
        }
        SFAddGroupMemberCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFAddGroupMemberCell"];
        if (self.groupInfoModel != nil) {
            cell.groupInfoModel = self.groupInfoModel;
        }
        return cell;
    }
    NSArray * array = _titleArray[indexPath.section];
    SFSelectSwitchBtnCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFSelectSwitchBtnCell"];
    cell.titleLB.text = array[indexPath.row];
    cell.bottomLine.hidden = array.count>1?indexPath.row%2:YES;
    if (indexPath.section == 3) {
        cell.swithBtn.hidden = NO;
        cell.arrowRight.hidden = YES;
        cell.swithBtn.selected = NO;
        if (indexPath.row==0) {//置顶
            if (_conversationModel.isTop) {
                cell.swithBtn.selected = YES;
            }
        }else{//消息免扰
            [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:self.groupId success:^(RCConversationNotificationStatus nStatus) {
                if (nStatus == DO_NOT_DISTURB) {//当前处于免打扰模式
                    cell.swithBtn.selected = YES;
                }else{//(新消息提醒)当前处于非免打扰模式
                    cell.swithBtn.selected = NO;
                }
            } error:^(RCErrorCode status) {
                
            }];
        }
        cell.topBtnBlock = ^(BOOL isOpen) {
            if (indexPath.row==0) {//置顶
                [self setTopChat:isOpen];
            }else{//消息免扰
                [self setReciveMessageWithSound:isOpen];
            }
        };
    }else if (indexPath.section == 4 && indexPath.row == 1){
        cell.swithBtn.hidden = YES;
        cell.arrowRight.hidden = YES;
    }else{
        cell.swithBtn.hidden = YES;
        cell.arrowRight.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.rightSubTitleLB.hidden = NO;
        cell.rightSubTitleLB.text = self.groupInfoModel.name;
    }
    if (cell.titleLB.text.length==0) {
        cell.arrowRight.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return UITableViewAutomaticDimension;
    }
    NSArray * array = _titleArray[indexPath.section];
    NSString * title = array[indexPath.row];
    if (title.length==0) {
        return 0.001;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSArray * array = _titleArray[section];
    NSString * title = array[0];
    if (title.length==0) {
        return 0.001;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}


//置顶聊天
- (void)setTopChat:(BOOL)isTop{
    [[RCIMClient sharedRCIMClient] setConversationToTop:self.conversationModel.conversationType targetId:self.conversationModel.targetId isTop:isTop];
    if (isTop) {
        [MBProgressHUD showSuccessMessage:@"置顶成功"];
    }else{
        [MBProgressHUD showSuccessMessage:@"取消置顶"];
    }
}

//消息免扰
- (void)setReciveMessageWithSound:(BOOL)isNotSound{
    BOOL newStates = !isNotSound;
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:self.conversationModel.conversationType targetId:self.conversationModel.targetId isBlocked:!newStates success:^(RCConversationNotificationStatus nStatus) {
        NSLog(@"==============>>>>>>>>>>>>设置消息%@状态成功",newStates?@"新消息提醒":@"免打扰");
    } error:^(RCErrorCode status) {
        
    }];
}

//获取群信息
- (void)requestGroupInfo{
    NSString * url = [NSString stringWithFormat:@"/message/chat/group/%@",_groupId];
    [SFBaseModel BGET:BASE_URL(url) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        self.groupInfoModel = [SFGroupInfoModel modelWithJSON:model.result];
        self.groupInfoModel.members = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[SFGroupMemberModel class] json:model.result[@"members"]]];
        RCGroup * info = [[RCGroup alloc]init];
        info.groupId = self.groupInfoModel.ID;
        info.groupName = self.groupInfoModel.name;
        [[RCIM sharedRCIM] refreshGroupInfoCache:info withGroupId:info.groupId];
        self->_titleArray = @[@[@"群聊名称"],@[@"群成员",@"添加成员"],[self.groupInfoModel.masterId isEqualToString:[SFInstance shareInstance].userInfo.rongCloudId]?@[@"群管理"]:@[@""],@[@"置顶聊天",@"消息免打扰"],@[@"查找聊天记录",@"清除聊天记录"]];
        self.tableView.tableFooterView = [self createTableFootView];
        [self.tableView reloadData];
        if ([self.groupInfoModel.masterId isEqualToString:[SFInstance shareInstance].userInfo.rongCloudId]) {
            [_dissolveBtn setTitle:@"解散群聊" forState:0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark 退出群聊
- (void)outGroup{
    UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"提示" message:[self.groupInfoModel.masterId isEqualToString:[SFInstance shareInstance].userInfo.rongCloudId]?@"确定解散该群？":@"确定退出该群？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消按钮");
    }];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.groupInfoModel.masterId isEqualToString:[SFInstance shareInstance].userInfo.rongCloudId]) {
            NSString * url = [NSString stringWithFormat:@"/message/chat/group/%@",self.groupInfoModel.ID];
            [SFBaseModel DELETE:BASE_URL(url) parameters:@{} success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
                [MBProgressHUD showSuccessMessage:@"解散成功"];
                [[RCIMClient sharedRCIMClient] removeConversation:self.conversationModel.conversationType targetId:self.conversationModel.targetId];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [MBProgressHUD showSuccessMessage:@"解散失败"];
            }];
        }else{
            NSString * url = [NSString stringWithFormat:@"/message/chat/group/quit/%@",self.groupInfoModel.ID];
            [SFBaseModel BPOST:BASE_URL(url) parameters:@{} success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
                [MBProgressHUD showSuccessMessage:@"退出成功"];
                [[RCIMClient sharedRCIMClient] removeConversation:self.conversationModel.conversationType targetId:self.conversationModel.targetId];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [MBProgressHUD showSuccessMessage:@"退出失败"];
            }];
        }
        
    }];

    [alter addAction:cancleAction];
    [alter addAction:defaultAction];
    [self presentViewController:alter animated:YES completion:nil];
}

@end
