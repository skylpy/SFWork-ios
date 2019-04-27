//
//  SFGroupChatViewController.m
//  SFWork
//
//  Created by fox on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFGroupChatViewController.h"
#import "SFChatUserInfoViewController.h"
#import "SFGroupChatInfoViewController.h"
#import "SFSystemMessageModel.h"

@interface SFGroupChatViewController ()<RCIMGroupInfoDataSource>

@end

@implementation SFGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
}

- (void)initUI{
    UIButton * rightIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightIconBtn.frame = CGRectMake(0, 0, 60, 44);
    rightIconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightIconBtn setImage:[UIImage imageNamed:@"message_userIcon"] forState:0];
    [rightIconBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightIconBtn];
    
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:0 image:[UIImage imageNamed:@"btn_app_photo_gray"] title:@"照片"];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:1 image:[UIImage imageNamed:@"btn_take_ptoto_gray"] title:@"拍摄"];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:2 image:[UIImage imageNamed:@"btn_add_file_gray"] title:@"文件"];
    self.chatSessionInputBarControl.pluginBoardView.pluginBoardDelegate = self;
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *groupInfo))completion{
    
    //根据存储联系人信息的模型，通过 userId 来取得对应的name和头像url，进行以下设置（此处因为项目接口尚未实现，所以就只能这样给大家说说，请见谅）
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SFSystemMessageModel getGroudNameAndAvatarList:groupId success:^(UserInfoModel * _Nonnull mode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                return completion([[RCGroup alloc] initWithGroupId:groupId groupName:mode.name portraitUri:mode.avatar]);
            });
        } failure:nil];
    });
}

- (void)rightBtnAction:(UIButton *)sender{
    SFGroupChatInfoViewController * chatInfoVc = [SFGroupChatInfoViewController new];
    chatInfoVc.groupId = _conversationModel.targetId;
    chatInfoVc.conversationModel = _conversationModel;
    [self.navigationController pushViewController:chatInfoVc animated:YES];
}

/**
 点击Cell中头像的回调
 @param userId  点击头像对应的用户ID
 */
- (void)didTapCellPortrait:(NSString *)userId{
    if (![userId isEqualToString:[SFInstance shareInstance].userInfo.rongCloudId]) {
        SFChatUserInfoViewController * chatInfoVc = [SFChatUserInfoViewController new];
        chatInfoVc.targetId = self.targetId;
        [self.navigationController pushViewController:chatInfoVc animated:YES];
    }
}

/*!
 扩展功能板的点击回调
 
 @param pluginBoardView 输入扩展功能板View
 @param tag             输入扩展功能(Item)的唯一标示
 */
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    if (tag == 1001) {
        [self.chatSessionInputBarControl openSystemAlbum];
    }else if (tag == 1002){
        [self.chatSessionInputBarControl openSystemCamera];
    }else if (tag == 1003){
        
    }
}

@end
