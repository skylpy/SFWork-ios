//
//  SFChatInfoViewController.m
//  SFWork
//
//  Created by fox on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFChatInfoViewController.h"
#import "SFChatHistoryViewController.h"
#import "SFAllContactListViewController.h"
#import "SFChatPersonlInfoCell.h"
#import "SFSelectSwitchBtnCell.h"

@interface SFChatInfoViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSDictionary * infoDic;
@property (nonatomic,strong) NSArray * titleArray;
@end

@implementation SFChatInfoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"聊天信息";
    [self initUI];
}

- (void)initUI{
    self.titleArray = @[@[@""],@[@"置顶聊天",@"消息免打扰"],@[@"查找聊天记录",@"清除聊天记录"]];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self requestData];
}

#pragma mark 获取数据
- (void)requestData{
    NSString * url = [NSString stringWithFormat:@"/org/employee/%@",self.conversationModel.targetId];
    [SFBaseModel BGET:BASE_URL(url) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        self.infoDic = model.result;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
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
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectSwitchBtnCell" bundle:nil] forCellReuseIdentifier:@"SFSelectSwitchBtnCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SFChatPersonlInfoCell" bundle:nil] forCellReuseIdentifier:@"SFChatPersonlInfoCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if(indexPath.row == 0){
            SFChatHistoryViewController * svc = [SFChatHistoryViewController new];
            svc.conversationModel = _conversationModel;
            [self.navigationController pushViewController:svc animated:YES];
        }else{
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
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * array = self.titleArray[section];

    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SFChatPersonlInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFChatPersonlInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.addBtnActionBlock = ^{
            SFAllContactListViewController * allContactVC = [SFAllContactListViewController new];
            allContactVC.currChatName = self->_conversationModel.conversationTitle;
            allContactVC.currChatId = self->_conversationModel.targetId;
            allContactVC.title = @"选择成员";
            [self.navigationController pushViewController:allContactVC animated:YES];
        };
        if (self.infoDic) {
            [cell.headIMG setImageWithURL:[NSURL URLWithString:self.infoDic[@"smallAvatar"]] placeholder:DefaultImage];
            cell.nameLB.text = self.infoDic[@"name"];
        }
        return cell;
    }
    SFSelectSwitchBtnCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFSelectSwitchBtnCell"];
    if (self.conversationModel.isTop&&indexPath.section == 1 && indexPath.row == 0) {
        cell.swithBtn.selected = YES;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:self.conversationModel.conversationType targetId:self.conversationModel.targetId success:^(RCConversationNotificationStatus nStatus) {
            if (nStatus == DO_NOT_DISTURB) {//当前处于免打扰模式
                cell.swithBtn.selected = YES;
            }else{//(新消息提醒)当前处于非免打扰模式
                cell.swithBtn.selected = NO;
            }
        } error:^(RCErrorCode status) {
            
        }];
    }
    cell.topBtnBlock = ^(BOOL isOpen) {
        //设置置顶
        if (indexPath.section == 1 && indexPath.row == 0) {
            [[RCIMClient sharedRCIMClient] setConversationToTop:self.conversationModel.conversationType targetId:self.conversationModel.targetId isTop:isOpen];
            if (isOpen) {
                [MBProgressHUD showSuccessMessage:@"置顶成功"];
            }else{
                [MBProgressHUD showSuccessMessage:@"取消置顶"];
            }
        }else if (indexPath.section == 1 && indexPath.row ==1){ //
            BOOL newStates = !isOpen;
            [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:self.conversationModel.conversationType targetId:self.conversationModel.targetId isBlocked:!newStates success:^(RCConversationNotificationStatus nStatus) {
                NSLog(@"==============>>>>>>>>>>>>设置消息%@状态成功",newStates?@"新消息提醒":@"免打扰");
            } error:^(RCErrorCode status) {
                
            }];
            
        }
    };
    NSArray * array = self.titleArray[indexPath.section];
    cell.titleLB.text = array[indexPath.row];
    cell.swithBtn.hidden = NO;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 2) {
        cell.swithBtn.hidden = YES;
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 116;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

@end
