//
//  SFChatHistoryViewController.m
//  SFWork
//
//  Created by fox on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFChatHistoryViewController.h"
#import "SFGroupChatViewController.h"
#import "SFConversationViewController.h"
#import "SFHistoryMessageListCell.h"

@interface SFChatHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic,strong) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray * messageListArray;

@end

@implementation SFChatHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}

- (void)initUI{
    self.title = @"聊天记录";
    self.searchTF.delegate = self;
    self.messageListArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)searchHistoryListByKeyWord:(NSString *)keyWord{
    NSArray * array = [[RCIMClient sharedRCIMClient] searchMessages:self.conversationModel.conversationType targetId:self.conversationModel.targetId keyword:keyWord count:20 startTime:0];
    [self.messageListArray removeAllObjects];
    [self.messageListArray addObjectsFromArray:array];
    [self.tableView reloadData];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:@"SFHistoryMessageListCell" bundle:nil] forCellReuseIdentifier:@"SFHistoryMessageListCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.messageListArray.count>indexPath.row) {
        RCMessage * message = self.messageListArray[indexPath.row];
        RCConversationViewController * conversationVC;
        if (message.conversationType == ConversationType_PRIVATE) {
            SFGroupChatViewController * gvc = [[SFGroupChatViewController alloc]init];
            gvc.conversationModel = _conversationModel;
            conversationVC = gvc;
        }else if (message.conversationType == ConversationType_GROUP) {
            SFConversationViewController * pvc = [[SFConversationViewController alloc]init];
            pvc.conversationModel = _conversationModel;
            conversationVC = pvc;
        }
        //聊天界面的聊天类型
        conversationVC.conversationType = _conversationModel.conversationType;
        //需要打开和谁聊天的会话界面,和谁聊天其实是通过TargetId来联系的。
        conversationVC.targetId = _conversationModel.targetId;
        conversationVC.title = _conversationModel.conversationTitle;
        conversationVC.enableNewComingMessageIcon = YES;
        conversationVC.locatedMessageSentTime = message.sentTime;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFHistoryMessageListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFHistoryMessageListCell"];
    RCMessage * message = self.messageListArray[indexPath.row];
    cell.message = message;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self searchHistoryListByKeyWord:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchHistoryListByKeyWord:textField.text];
    return YES;
}

@end
