//
//  SFContactsViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/23.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ContactsModel;
@interface SFContactsViewController : UIViewController

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) void (^selectItemClick)(ContactsModel * model);;

@end

NS_ASSUME_NONNULL_END
