//
//  SFRealTimeView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFRealTimeView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (instancetype)shareSFRealTimeView ;

@end

NS_ASSUME_NONNULL_END
