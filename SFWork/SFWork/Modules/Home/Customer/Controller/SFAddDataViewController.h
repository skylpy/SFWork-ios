//
//  SFAddDataViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFCustomerModel.h"
#import "SFBaseTableCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAddDataViewController : SFBaseViewController

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) CustomerType type;

@property (nonatomic, strong) SFClientModel *cmodel;

@end

@interface SFAddDataCell : SFBaseTableCell

@property (nonatomic,strong) SFCustomerModel * model;

@end

NS_ASSUME_NONNULL_END
