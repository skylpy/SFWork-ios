//
//  SFBillSearchResultViewController.h
//  SFWork
//
//  Created by fox on 2019/4/23.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFBillSearchResultViewController : SFRootViewController
@property (copy, nonatomic) NSString * startDateStr;
@property (copy, nonatomic) NSString * endDateStr;
@property (copy, nonatomic) NSString * titleStr;
@end

NS_ASSUME_NONNULL_END
