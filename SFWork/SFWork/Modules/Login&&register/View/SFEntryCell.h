//
//  SFEntryCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/17.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFForGetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFEntryCell : UITableViewCell

@property (nonatomic, strong) SFForGetModel * model;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

NS_ASSUME_NONNULL_END
