//
//  SFGroupChatViewController.h
//  SFWork
//
//  Created by fox on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFGroupChatViewController : RCConversationViewController
@property (nonatomic) BOOL isBackToRoot;
@property (strong, nonatomic) RCConversationModel * conversationModel;
@end

NS_ASSUME_NONNULL_END
