//
//  SFAnnounceHeaderView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFAnnounceHeaderView : UIView

+ (instancetype)shareSFAnnounceHeaderView ;

@property (nonatomic, copy) void (^selectItemClcik)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
