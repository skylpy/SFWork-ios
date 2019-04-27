//
//  SFConversationViewController.h
//  SFWork
//
//  Created by fox on 2019/3/24.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SFConversationViewController : RCConversationViewController <BackButtonHandlerProtocol>
@property (nonatomic) BOOL isBackToRoot;
@property (strong, nonatomic) RCConversationModel * conversationModel;
@end

NS_ASSUME_NONNULL_END
