//
//  SFAlertInputView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, LSXKeyboardType) {
    
    LSXKeyboardTypeDefault  = 0,                // Default type for the current input metho
    LSXKeyboardTypeURL  = 1,                    // A type optimized for URL entry (shows . / .com prominently).
    LSXKeyboardTypeNumberPad = 2,              // A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.
    LSXKeyboardTypePhonePad = 3,               // A phone pad (1-9, *, 0, #, with letters under the numbers).
    LSXKeyboardTypeNamePhonePad = 4,           // A type optimized for entering a person's name or phone number.
};

@interface SFAlertInputView : UIView

/***
 参数：title         //标题
 参数：PlaceholderText//默认提示语句
 **/
-(instancetype)initWithTitle:(NSString *)title PlaceholderText:(NSString *)PlaceholderText WithKeybordType:(LSXKeyboardType)bordtype CompleteBlock:(void(^)(NSString * contents))completeBlock;
//字数限制默认不限
@property (nonatomic , assign) int  num;
/**
 显示
 **/
-(void)show;

@end

@interface SFPlacehoderTextView : UITextView

@property (nonatomic, strong) NSString *placeholders;

@end

NS_ASSUME_NONNULL_END
