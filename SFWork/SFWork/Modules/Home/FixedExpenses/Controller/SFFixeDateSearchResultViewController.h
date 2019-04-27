//
//  SFFixeDateSearchResultViewController.h
//  SFWork
//
//  Created by fox on 2019/4/26.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFFixeDateSearchResultViewController : SFRootViewController
@property (copy, nonatomic) NSString * startDateStr;
@property (copy, nonatomic) NSString * endDateStr;
@property (copy, nonatomic) NSMutableDictionary * reuestDic;
@property (copy, nonatomic) NSString * titleStr;
@end

NS_ASSUME_NONNULL_END
