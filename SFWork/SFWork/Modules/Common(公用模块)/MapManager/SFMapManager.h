//
//  SFMapManager.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFMapManager : NSObject

+(instancetype)sharedManager;
- (void)showSuperView:(UIView *)superView withFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
