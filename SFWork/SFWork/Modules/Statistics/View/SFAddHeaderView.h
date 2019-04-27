//
//  SFAddHeaderView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDataReportHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAddHeaderView : UIView
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (nonatomic, strong) ItemsModel *item;
+ (instancetype)shareSFAddHeaderView;

@end

NS_ASSUME_NONNULL_END
