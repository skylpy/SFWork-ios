//
//  SFJoBottomView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFJoBottomView : UIView

+ (instancetype)shareBottomView;

@property (nonatomic, copy) void (^selectIndex)(NSInteger tap);

@end

NS_ASSUME_NONNULL_END
