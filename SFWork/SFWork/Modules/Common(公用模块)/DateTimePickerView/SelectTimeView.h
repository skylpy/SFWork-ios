//
//  SelectTimeView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/20.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectTimeView : UIView

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

+ (instancetype)shareSelectTimeView ;

@end

NS_ASSUME_NONNULL_END
