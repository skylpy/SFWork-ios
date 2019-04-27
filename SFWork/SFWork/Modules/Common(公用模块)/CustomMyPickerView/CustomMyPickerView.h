//
//  CustomMyPickerView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^customBlock)(NSString *compoentString,NSString *titileString);

@interface CustomMyPickerView : UIView
@property (nonatomic ,copy)NSString *componentString;
@property (nonatomic ,copy)NSString *titleString;
@property (nonatomic ,copy)customBlock getPickerValue;

@property (nonatomic ,copy)NSString *valueString;

- (instancetype)initWithComponentDataArray:(NSArray *)ComponentDataArray titleDataArray:(NSArray *)titleDataArray;
@end

NS_ASSUME_NONNULL_END
