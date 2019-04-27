//
//  SFGroupManagerViewController.h
//  ClassForEvery
//
//  Created by Adam on 2019/4/2.
//  Copyright © 2019年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFGroupManagerViewController : UIViewController
@property (strong, nonatomic) RCConversationModel * conversationModel;
@property (strong, nonatomic) SFGroupInfoModel * groupInfoModel;
@end

NS_ASSUME_NONNULL_END
