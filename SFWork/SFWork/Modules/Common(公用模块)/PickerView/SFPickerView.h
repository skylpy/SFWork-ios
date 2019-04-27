//
//  SFPickerView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SFPickerViewDelegate <NSObject>

- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text withRow:(NSInteger)row withSelectIndex:(NSInteger)selectIndex;

@end
@interface SFPickerView : UIView

@property (nonatomic,assign) NSInteger row;
@property (nonatomic, strong) NSArray *customArr;
@property (nonatomic, weak) id <SFPickerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
