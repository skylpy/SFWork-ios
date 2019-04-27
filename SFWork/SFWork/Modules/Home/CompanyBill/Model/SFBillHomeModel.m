//
//  SFBillHomeModel.m
//  SFWork
//
//  Created by fox on 2019/4/22.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFBillHomeModel.h"

@implementation SFBillHomeModel
// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"billSumList" : [SFBillListModel class],@"billList" : [SFBillListModel class]};
}
@end