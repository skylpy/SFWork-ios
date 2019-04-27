//
//  SFCustomerCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCustomerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFCustomerCell : UITableViewCell

@property (nonatomic, strong) SFClientModel *model;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end

NS_ASSUME_NONNULL_END
