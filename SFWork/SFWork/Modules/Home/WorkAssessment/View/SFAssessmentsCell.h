//
//  SFAssessmentsCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import <UIKit/UIKit.h>
#import "SFWorkAssessPersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAssessmentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) ScoreListModel *model;

@end

NS_ASSUME_NONNULL_END
