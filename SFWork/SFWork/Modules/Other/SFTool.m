//
//  SFTool.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/15.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTool.h"

@implementation SFTool

+ (void)openImageArr:(NSArray *)images withController:(UIView *)controller withRow:(NSInteger)row{
    
    NSMutableArray<YYPhotoGroupItem *> *items = [NSMutableArray array];
    
    for (NSString * constrainURL in images) {
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.largeImageURL = [NSURL URLWithString:[NSString getAliOSSConstrainURL:constrainURL]];
        
        [items addObject:item];
    }
    
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
   
    [v presentFromImageView:controller toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}

@end
