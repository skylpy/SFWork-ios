//
//  SFAssessmentRuleViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFAssessmentSetModel.h"
#import "SFWorkAssessHttpModel.h"
#import "SFBaseTableCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAssessmentRuleViewController : SFBaseViewController

@property (nonatomic, copy) NSString *module;
@property (nonatomic, strong) SFWorkCheckItemModel * smodel;
@property (nonatomic, assign) BOOL isEditor;

@property (nonatomic, copy) void (^addAssessmentClick)(void);


@end

@interface SFAssessmentRuleCell : SFBaseTableCell

@property (nonatomic, strong) SFAssessmentSetModel *model;
@property (nonatomic, copy) void (^inputChacneClick) (NSString * value);


@end

NS_ASSUME_NONNULL_END
