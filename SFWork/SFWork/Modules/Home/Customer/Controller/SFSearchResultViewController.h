//
//  SFSearchResultViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/15.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCustomerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFSearchResultViewController : UIViewController

@property (nonatomic, strong) NSArray *resultArr;
@property (nonatomic, assign) CustomerType type;

@end

NS_ASSUME_NONNULL_END
