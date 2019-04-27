//
//  SFTabBarViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SFTabModel;
@interface SFTabBarViewController : UITabBarController

@end

@interface SFTabModel : NSObject

/**
 * des:SFTabModel保存轨迹ID
 * author:SkyWork
 */
+(void)gaodeSaveTrids:(NSString *)Id
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure ;

@end

NS_ASSUME_NONNULL_END
