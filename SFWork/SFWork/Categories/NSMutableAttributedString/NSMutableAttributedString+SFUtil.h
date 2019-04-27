//
//  NSMutableAttributedString+SFUtil.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (SFUtil)

+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textFont:(UIFont *)font textColor:(UIColor *)color ;

@end

NS_ASSUME_NONNULL_END
