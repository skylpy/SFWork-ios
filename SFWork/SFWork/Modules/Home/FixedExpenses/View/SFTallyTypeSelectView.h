//
//  SFTallyTypeSelectView.h
//  SFWork
//
//  Created by fox on 2019/4/21.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFTallyTypeSelectView : UIView
@property (copy, nonatomic) void (^addBlock)(void);
@property (copy, nonatomic) void (^sureBlock)(NSString *name);
@end

NS_ASSUME_NONNULL_END
