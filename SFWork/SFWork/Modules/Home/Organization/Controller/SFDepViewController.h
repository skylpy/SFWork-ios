//
//  SFDepViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFDepViewController : UIViewController

@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *parentName;

@property (nonatomic,copy) void (^didSaveClick)(void);

@end

NS_ASSUME_NONNULL_END
