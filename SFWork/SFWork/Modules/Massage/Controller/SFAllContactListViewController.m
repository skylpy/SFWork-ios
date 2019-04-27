//
//  SFAllContactListViewController.m
//  SFWork
//
//  Created by fox on 2019/3/31.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAllContactListViewController.h"
#import "SFConversationViewController.h"
#import "SFSelectCOntactCell.h"


@interface SFAllContactListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * selectArray;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectCountLB;
@end

@implementation SFAllContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.dataArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    [self initDrawUI];
    
    if (_isShowBan || _isShowNoBan) {
        [self requestBanListWithKeyWord:@""];
    }else if (_isAddGroupMember){
        [self initDataWithKeyWord:@""];
    }else{
        [self initDataWithKeyWord:@""];
    }
}

//搜索
- (void)initDataWithKeyWord:(NSString *)keyWord{
    
    [SFMailHttpModel getMailEmployeeContacts:@{@"searchText":keyWord} success:^(NSArray<ContactsList *> * _Nonnull list) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark 从群管理进来
- (void)requestBanListWithKeyWord:(NSString *)keyWord{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:_currChatId forKey:@"groupId"];
    [params setObject:keyWord forKey:@"searchText"];
    if (_isShowBan) {
        if (self.isBan.integerValue == 1) {
            [params setObject:@(1) forKey:@"isIgnoreBanAll"];
        }else{
            [params setObject:@(1) forKey:@"isBan"];
        }
    }else{
        if (self.isBan.integerValue == 1) {
            [params setObject:@(0) forKey:@"isIgnoreBanAll"];
        }else{
            [params setObject:@(0) forKey:@"isBan"];
        }
    }
    
    [SFBaseModel BPOST:BASE_URL(@"/message/chat/group/searchMember") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[SFGroupMemberModel class] json:model.result]];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

//确定创建
- (IBAction)sureBtnAction:(UIButton *)sender {
    //如果是添加群成员的

    if (_isShowBan || _isShowNoBan) {
        if (self.selectArray.count != 0) {
            if (self.selectSureBlock) {
                self.selectSureBlock(self.selectArray);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (_isAddGroupMember) { //如果是添加群成员的
        if (self.selectArray.count == 0) {
            [MBProgressHUD showInfoMessage:@"至少选择1个用户"];
            return;
        }
        [self addGroupMemberRequest];
    }else{
        if (self.selectArray.count < 1) {
            [MBProgressHUD showInfoMessage:@"至少选择两个用户"];
            return;
        }
        [self createGroupChat];
    }
    
}

//创建群聊
- (void)createGroupChat{
    [MBProgressHUD showActivityMessageInWindow:@""];
    if (self.selectArray.count>0) {
        NSMutableArray * idArray = [NSMutableArray array];
        NSMutableString * nameStr = [NSMutableString string];
        for (ContactsList * model in self.selectArray) {
            
            [idArray addObject:model.rongCloudId];
            if (nameStr.length == 0) {
                [nameStr appendString:model.name];
            }else{
                [nameStr appendFormat:@",%@",model.name];
            }
        }
        
        [nameStr appendFormat:@",%@",_currChatName];
        [idArray addObject:_currChatId];
        [nameStr appendFormat:@",%@",[SFInstance shareInstance].userInfo.name];
        [idArray addObject:[SFInstance shareInstance].userInfo.rongCloudId];
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setObject:idArray forKey:@"memberIds"];
        [params setObject:nameStr forKey:@"name"];
        [SFBaseModel BPOST:BASE_URL(@"/message/chat/group") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
            [MBProgressHUD hideHUD];
            NSDictionary * infoDic = model.result;
            if (infoDic[@"id"] != nil) {
                RCGroup * info = [[RCGroup alloc]init];
                info.groupId = infoDic[@"id"];
                info.groupName = nameStr;
                [[RCIM sharedRCIM] refreshGroupInfoCache:info withGroupId:info.groupId];
                SFConversationViewController *conversationVC = [[SFConversationViewController alloc]init];
                
                //聊天界面的聊天类型
                conversationVC.conversationType = ConversationType_GROUP;
                conversationVC.conversationModel.conversationTitle = nameStr;
                //需要打开和谁聊天的会话界面,和谁聊天其实是通过TargetId来联系的。
                conversationVC.targetId = infoDic[@"id"];
                conversationVC.title = nameStr;
                conversationVC.isBackToRoot = YES;
                conversationVC.enableNewComingMessageIcon = YES;
                NSLog(@"===========targetId = %@",infoDic[@"id"]);
                [self.navigationController pushViewController:conversationVC animated:YES];
                
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [MBProgressHUD showErrorMessage:error.domain];
            [MBProgressHUD hideHUD];
        }];
    }
    
}

//添加群成员
- (void)addGroupMemberRequest{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:_currChatId forKey:@"id"];
    NSMutableArray * idArray = [NSMutableArray array];
    for (ContactsList * model in self.selectArray) {
        [idArray addObject:model.rongCloudId];
    }
    [params setObject:idArray forKey:@"memberIds"];
    
    [SFBaseModel BPOST:BASE_URL(@"/message/chat/group/join") parameters:params success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD showInfoMessage:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD showInfoMessage:@"添加失败"];
    }];
}

-(void)initDrawUI {
    self.searchTF.delegate = self;
    self.sureBtn.layer.cornerRadius = 3;
    self.sureBtn.clipsToBounds = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-50);
        make.top.mas_equalTo(44);
        make.left.right.equalTo(self.view);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 68;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFSelectCOntactCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SFSelectCOntactCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_isShowNoBan || _isShowBan) {
        SFGroupMemberModel * model = self.dataArray[indexPath.row];
        cell.groupMemberModel = model;
    }else{
        ContactsList * model = self.dataArray[indexPath.row];
        cell.model = model;
    }
    
    cell.selectBlock = ^(BOOL isSelect) {
        if (isSelect) {
            [self.selectArray addObject:self.dataArray[indexPath.row]];
        }else{
            [self.selectArray removeObject:self.dataArray[indexPath.row]];
        }
        self.selectCountLB.text = [NSString stringWithFormat:@"已选%ld人",self.selectArray.count];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark UITextFieldDelegate 搜索代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_isShowBan || _isShowNoBan) {
        [self requestBanListWithKeyWord:textField.text];
    }else{
        [self initDataWithKeyWord:textField.text];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_isShowBan || _isShowNoBan) {
        [self requestBanListWithKeyWord:textField.text];
    }else{
        [self initDataWithKeyWord:textField.text];
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectCOntactCell" bundle:nil] forCellReuseIdentifier:@"SFSelectCOntactCell"];
        
        
    }
    return _tableView;
}

@end
