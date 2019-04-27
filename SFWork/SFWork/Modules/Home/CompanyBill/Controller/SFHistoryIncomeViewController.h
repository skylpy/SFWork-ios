//
//  SFHistoryIncomeViewController.h
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFHistoryIncomeViewController : SFRootViewController
@property (copy, nonatomic) NSString * showDetailStr;
@property (copy, nonatomic) NSString * bizTypes;
@property (copy, nonatomic) NSMutableDictionary * params;
@end

NS_ASSUME_NONNULL_END
