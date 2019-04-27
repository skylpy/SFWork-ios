//
//  SFSelectCOntactCell.h
//  SFWork
//
//  Created by fox on 2019/3/31.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMailHttpModel.h"
#import "SFGroupMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSelectCOntactCell : UITableViewCell
@property (copy, nonatomic) void (^selectBlock)(BOOL isSelect);
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic, copy) ContactsList *model;
@property (nonatomic, copy) SFGroupMemberModel * groupMemberModel;
@end

NS_ASSUME_NONNULL_END
