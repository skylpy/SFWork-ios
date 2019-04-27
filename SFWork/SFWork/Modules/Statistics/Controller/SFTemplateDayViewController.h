//
//  SFTemplateDayViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFTemplateDayViewController : SFBaseViewController

@property (nonatomic, copy) NSArray *datas;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *departmentId;
- (void)savaJournalSetData;

@end

NS_ASSUME_NONNULL_END
