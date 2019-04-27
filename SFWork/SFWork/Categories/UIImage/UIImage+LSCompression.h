//
//  UIImage+LSCompression.h
//  LittleSix
//
//  Created by Jim huang on 17/4/1.
//  Copyright © 2017年 ZhiHua Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LSCompression)

+(NSData *)compressionImage:(UIImage *)image;
+ (UIImage *) imageFromURLString: (NSString *) urlstring;
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
-(UIImage*)imageWithCornerRadius:(CGFloat)radius;
- (UIImage*)borderImage:(UIImage *)image;

@end
