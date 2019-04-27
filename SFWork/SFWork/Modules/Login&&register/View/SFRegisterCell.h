//
//  SFRegisterCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRegisterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFRegisterCell : UITableViewCell

@property (nonatomic,strong) SFRegisterModel * model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

NS_ASSUME_NONNULL_END
