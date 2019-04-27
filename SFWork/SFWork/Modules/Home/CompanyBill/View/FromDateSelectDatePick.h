//
//  FromDateSelectDatePick.h
//  SPDateTimePickerViewDemo
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 罗盼. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface FromDateSelectDatePick : UIView
@property (copy, nonatomic) void (^sureBlock)(NSString * startDate,NSString * endDate);
@property (strong, nonatomic) NSString  * titleStr;
@property (nonatomic) BOOL onlyOneDateSelect;
- (void)initUI;
@end

NS_ASSUME_NONNULL_END
