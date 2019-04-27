//
//  SFDepartViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFDepartViewController : UIViewController

- (void)requestData:(NSDictionary *)dict;
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
