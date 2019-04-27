//
//  NSMutableAttributedString+SFUtil.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "NSMutableAttributedString+SFUtil.h"

@implementation NSMutableAttributedString (SFUtil)

+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textFont:(UIFont *)font textColor:(UIColor *)color  {
    
    NSRange hightlightTextRange = [text rangeOfString:rangeText];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    // 改变文字颜色
    if (hightlightTextRange.length > 0) {
        
        [attributeStr addAttribute:NSForegroundColorAttributeName
         
                             value:color
         
                             range:hightlightTextRange];
        
        [attributeStr addAttribute:NSFontAttributeName value:font range:hightlightTextRange];
        
        return attributeStr;
        
    }else {
        
        return [rangeText copy];
        
    }
    
}

@end
