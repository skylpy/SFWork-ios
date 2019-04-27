//
//  SFMassageCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSystemMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFMassageCell : RCConversationBaseCell
@property (nonatomic,copy)SystemMessageModel * systemMsgModel;
@end

NS_ASSUME_NONNULL_END
