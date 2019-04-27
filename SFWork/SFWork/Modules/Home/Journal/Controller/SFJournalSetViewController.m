//
//  SFJournalSetViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFJournalSetViewController.h"
#import "SFJournalHttpModel.h"
#import "SFJournalSetModel.h"

@interface SFJournalSetViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *journalSetLayoutW;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SFJournalSetViewController

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.journalSetLayoutW.constant = kWidth*3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日报设置";
    
    [self requestData];
}
- (IBAction)selectSeg:(UISegmentedControl *)sender {
    
    NSLog(@"%ld",sender.selectedSegmentIndex);
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
            break;
        case 1:
            [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
            break;
        case 2:
            [self.scrollView setContentOffset:CGPointMake(kWidth*2, 0)];
            break;
        default:
            break;
    }
}

- (void)requestData {
    
    [SFJournalHttpModel getMyTemplateListsSuccess:^(SFJournalSetModel * _Nonnull model) {
        
        SFJournalSetModel * smodel = [SFJournalSetModel shareManager];
        smodel = model;
        smodel._id = model._id;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyTemplateID" object:model._id];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}




@end
