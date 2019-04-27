//
//  SFTipDesView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/30.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFTipDesView : UIView

+ (instancetype)shareSFTipDesView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
