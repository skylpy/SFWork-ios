//
//  SFConversationViewController.m
//  SFWork
//
//  Created by fox on 2019/3/24.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFConversationViewController.h"
#import "SFChatUserInfoViewController.h"
#import "SFChatInfoViewController.h"
#import "SFSystemMessageModel.h"
@interface SFConversationViewController ()<RCIMUserInfoDataSource>

@end
@implementation SFConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:RCLibDispatchReadReceiptNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
       
        
    }];
    
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    RCMessageCell * mcell = (RCMessageCell *)[self.conversationMessageCollectionView cellForItemAtIndexPath:indexPath];
    mcell.receiptView.hidden = YES;
    
 
}

- (void)initUI{
    
    UIButton * rightIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightIconBtn.frame = CGRectMake(0, 0, 60, 44);
    rightIconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightIconBtn setImage:[UIImage imageNamed:@"message_userIcon"] forState:0];
    [rightIconBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightIconBtn];
    
    [self.navigationController.navigationBar setBackIndicatorImage:[[UIImage imageNamed:@"arrow_return_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"arrow_return_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:0 image:[UIImage imageNamed:@"btn_app_photo_gray"] title:@"照片"];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:1 image:[UIImage imageNamed:@"btn_take_ptoto_gray"] title:@"拍摄"];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:2 image:[UIImage imageNamed:@"btn_add_file_gray"] title:@"文件"];
    self.chatSessionInputBarControl.pluginBoardView.pluginBoardDelegate = self;
}

- (void)rightBtnAction:(UIButton *)sender{
    SFChatInfoViewController * chatInfoVc = [SFChatInfoViewController new];
    chatInfoVc.conversationModel = _conversationModel;
    [self.navigationController pushViewController:chatInfoVc animated:YES];
}

//调用
- (BOOL)navigationShouldPopOnBackButton{
    if (_isBackToRoot) {
        NSLog(@"==============>>>>>>>popToRootViewControllerAnimated");
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    
    return YES;
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
    NSLog(@"=============>>>>>>>.来了获取用户信息的代理");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SFSystemMessageModel getNameAndAvatarList:userId success:^(UserInfoModel * _Nonnull mode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                return completion([[RCUserInfo alloc] initWithUserId:mode._id name:mode.name portrait:mode.avatar]);
            });
        } failure:nil];
    });
    
}

/*!
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



@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    if([self.viewControllers count] < [navigationBar.items count])
    {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)])
    {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }
    else
    {
        // 取消 pop 后，复原返回按钮的状态
        for(UIView *subview in [navigationBar subviews])
        {
            if(0.0 < subview.alpha && subview.alpha < 1.0)
            {
                [UIView animateWithDuration:0.25 animations:^{
                    subview.alpha = 1.0;
                }];
            }
        }
    }
    return NO;
}



@end
