//
//  SFFixeSearchViewController.h
//  SFWork
//
//  Created by fox on 2019/4/25.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFFixeSearchViewController : UIViewController
//是不是添加页面
@property (nonatomic) BOOL isAdd;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) void (^fixeClick)(void);

@end

NS_ASSUME_NONNULL_END
