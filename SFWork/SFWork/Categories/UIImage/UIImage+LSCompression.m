//
//  UIImage+LSCompression.m
//  LittleSix
//
//  Created by Jim huang on 17/4/1.
//  Copyright © 2017年 ZhiHua Shen. All rights reserved.
//

#import "UIImage+LSCompression.h"

@implementation UIImage (LSCompression)

+(NSData *)compressionImage:(UIImage *)image {
    
    if (!image) {
        return nil;
    }
    

    NSData * AllImageData = UIImageJPEGRepresentation(image, 1);
    int maxDataLength = 2 * 1024 * 1024;
    NSData *imageData;
    
    if (AllImageData.length<maxDataLength) {
        return  AllImageData;
    }else{
        CGFloat compression = 0.95f;
        CGFloat maxCompression = 0.1f;
        imageData = UIImageJPEGRepresentation(image, compression);
        while ([imageData length] > maxDataLength && compression > maxCompression) {
            compression -= 0.05;
            imageData = UIImageJPEGRepresentation(image, compression);
        }
        
        return imageData;
    }
}

+ (UIImage *) imageFromURLString: (NSString *) urlstring {
    
    UIImage * image = [UIImage imageWithData:[NSData  dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
    
    return image;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    
    
    // 设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    
    return scaledImage;
    
}

-(UIImage*)imageWithCornerRadius:(CGFloat)radius{
    
    // 开始图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 设置一个范围
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    // 根据radius的值画出路线
    CGContextAddPath(ctx, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    // 裁剪
    CGContextClip(ctx);
    // 将原照片画到图形上下文
    [self drawInRect:rect];
    // 从上下文上获取剪裁后的照片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)borderImage:(UIImage *)image {
    //1.加载图片
 
    //2.边框宽度
    CGFloat borderW = 2;
    //3.开启图片上下文
    CGSize size = CGSizeMake(image.size.width+2*borderW, image.size.height+2*borderW);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //4.先描述一个大圆作为填充
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    [[UIColor redColor] set];
    [path fill];
    //5.在添加一个小圆设为剪裁区域
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderW, borderW, image.size.width, image.size.height)];
    [path addClip];
    //6.把图片绘制上下文
    [image drawInRect:CGRectMake(borderW, borderW, image.size.width, image.size.height)];
    //7.生成图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //8.关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
    




@end
