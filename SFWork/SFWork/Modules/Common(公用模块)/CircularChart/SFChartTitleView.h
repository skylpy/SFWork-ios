//
//  SFChartTitleView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFChartTitleView : UIView

+ (instancetype)shareSFChartTitleView;

@property (weak, nonatomic) IBOutlet UILabel *normalLabel;
@property (weak, nonatomic) IBOutlet UILabel *abnormalLabel;

@end

NS_ASSUME_NONNULL_END
