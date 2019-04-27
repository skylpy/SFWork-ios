//
//  SFIncomeHeadView.h
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFIncomeHeadView : UIView
@property (copy, nonatomic) void (^outBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIButton *outBtn;
@end

NS_ASSUME_NONNULL_END
