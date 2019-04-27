//
//  SFPostionBottomView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/17.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFPostionBottomView : UIView

+ (instancetype)shareSFPostionBottomView;
@property (weak, nonatomic) IBOutlet UILabel *disLabel;

@end

NS_ASSUME_NONNULL_END
