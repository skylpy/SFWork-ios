
//
//  SFFilesBottomView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFFilesBottomView.h"

@interface SFFilesBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *deleteaButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *renameButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//
@property (weak, nonatomic) IBOutlet UIButton *deleteButton1;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton1;
@property (weak, nonatomic) IBOutlet UIButton *sendButton1;

@property (weak, nonatomic) IBOutlet UIButton *removeButton1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;


//

@property (weak, nonatomic) IBOutlet UIButton *deleteButton2;
@property (weak, nonatomic) IBOutlet UIButton *renameButton2;
@property (weak, nonatomic) IBOutlet UIButton *removeButton2;

@end

@implementation SFFilesBottomView

+ (instancetype)shareAllBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFFilesBottomView" owner:self options:nil].firstObject;
}

+ (instancetype)shareFourBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFFilesBottomView" owner:self options:nil][1];
}

+ (instancetype)shareThereBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFFilesBottomView" owner:self options:nil].lastObject;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.deleteaButton setTitleEdgeInsets:
     UIEdgeInsetsMake(self.deleteaButton.frame.size.height/2,
                      (self.deleteaButton.frame.size.width-self.deleteaButton.titleLabel.intrinsicContentSize.width)/2-self.deleteaButton.imageView.frame.size.width,
                      0,
                      (self.deleteaButton.frame.size.width-self.deleteaButton.titleLabel.intrinsicContentSize.width)/2)];
    [self.deleteaButton setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.deleteaButton.frame.size.width-self.deleteaButton.imageView.frame.size.width)/2,
                      self.deleteaButton.titleLabel.intrinsicContentSize.height,
                      (self.deleteaButton.frame.size.width-self.deleteaButton.imageView.frame.size.width)/2)];
    
    
    [self.downloadButton setTitleEdgeInsets:
     UIEdgeInsetsMake(self.downloadButton.frame.size.height/2,
                      (self.downloadButton.frame.size.width-self.downloadButton.titleLabel.intrinsicContentSize.width)/2-self.downloadButton.imageView.frame.size.width,
                      0,
                      (self.downloadButton.frame.size.width-self.downloadButton.titleLabel.intrinsicContentSize.width)/2)];
    [self.downloadButton setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.downloadButton.frame.size.width-self.downloadButton.imageView.frame.size.width)/2,
                      self.downloadButton.titleLabel.intrinsicContentSize.height,
                      (self.downloadButton.frame.size.width-self.downloadButton.imageView.frame.size.width)/2)];

    [self.sendButton setTitleEdgeInsets:
     UIEdgeInsetsMake(self.sendButton.frame.size.height/2,
                      (self.sendButton.frame.size.width-self.sendButton.titleLabel.intrinsicContentSize.width)/2-self.sendButton.imageView.frame.size.width,
                      0,
                      (self.sendButton.frame.size.width-self.sendButton.titleLabel.intrinsicContentSize.width)/2)];
    [self.sendButton setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.sendButton.frame.size.width-self.sendButton.imageView.frame.size.width)/2,
                      self.sendButton.titleLabel.intrinsicContentSize.height,
                      (self.sendButton.frame.size.width-self.sendButton.imageView.frame.size.width)/2)];

    [self.renameButton setTitleEdgeInsets:
     UIEdgeInsetsMake(self.renameButton.frame.size.height/2,
                      (self.renameButton.frame.size.width-self.renameButton.titleLabel.intrinsicContentSize.width)/2-self.renameButton.imageView.frame.size.width,
                      0,
                      (self.renameButton.frame.size.width-self.renameButton.titleLabel.intrinsicContentSize.width)/2)];
    [self.renameButton setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.renameButton.frame.size.width-self.renameButton.imageView.frame.size.width)/2,
                      self.renameButton.titleLabel.intrinsicContentSize.height,
                      (self.renameButton.frame.size.width-self.renameButton.imageView.frame.size.width)/2)];

    [self.removeButton setTitleEdgeInsets:
     UIEdgeInsetsMake(self.removeButton.frame.size.height/2,
                      (self.removeButton.frame.size.width-self.removeButton.titleLabel.intrinsicContentSize.width)/2-self.removeButton.imageView.frame.size.width,
                      0,
                      (self.removeButton.frame.size.width-self.removeButton.titleLabel.intrinsicContentSize.width)/2)];
    [self.removeButton setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.removeButton.frame.size.width-self.removeButton.imageView.frame.size.width)/2,
                      self.removeButton.titleLabel.intrinsicContentSize.height,
                      (self.removeButton.frame.size.width-self.removeButton.imageView.frame.size.width)/2)];

    @weakify(self)
    [[self.deleteaButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(filesOpationType:)]) {
            
            [self.delegate filesOpationType:deleteType];
        }

    }];
    [[self.downloadButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(filesOpationType:)]) {
            
            [self.delegate filesOpationType:downloadType];
        }
    }];
    [[self.sendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(filesOpationType:)]) {
            
            [self.delegate filesOpationType:sendType];
        }
    }];
    [[self.renameButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(filesOpationType:)]) {
            
            [self.delegate filesOpationType:renameType];
        }
    }];
    [[self.removeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(filesOpationType:)]) {
            
            [self.delegate filesOpationType:removeType];
        }
    }];
    
    
    /**
     * des:
     * author:SkyWork
     */
    [self.deleteButton1 setTitleEdgeInsets:
     UIEdgeInsetsMake(self.deleteButton1.frame.size.height/2,
                      (self.deleteButton1.frame.size.width-self.deleteButton1.titleLabel.intrinsicContentSize.width)/2-self.deleteButton1.imageView.frame.size.width,
                      0,
                      (self.deleteButton1.frame.size.width-self.deleteButton1.titleLabel.intrinsicContentSize.width)/2)];
    [self.deleteButton1 setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.deleteButton1.frame.size.width-self.deleteButton1.imageView.frame.size.width)/2,
                      self.deleteButton1.titleLabel.intrinsicContentSize.height,
                      (self.deleteButton1.frame.size.width-self.deleteButton1.imageView.frame.size.width)/2)];
    
    
    [self.downloadButton1 setTitleEdgeInsets:
     UIEdgeInsetsMake(self.downloadButton1.frame.size.height/2,
                      (self.downloadButton1.frame.size.width-self.downloadButton1.titleLabel.intrinsicContentSize.width)/2-self.downloadButton1.imageView.frame.size.width,
                      0,
                      (self.downloadButton1.frame.size.width-self.downloadButton1.titleLabel.intrinsicContentSize.width)/2)];
    
    [self.downloadButton1 setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.downloadButton1.frame.size.width-self.downloadButton1.imageView.frame.size.width)/2,
                      self.downloadButton1.titleLabel.intrinsicContentSize.height,
                      (self.downloadButton1.frame.size.width-self.downloadButton1.imageView.frame.size.width)/2)];
    
    [self.sendButton1 setTitleEdgeInsets:
     UIEdgeInsetsMake(self.sendButton1.frame.size.height/2,
                      (self.sendButton1.frame.size.width-self.sendButton1.titleLabel.intrinsicContentSize.width)/2-self.sendButton1.imageView.frame.size.width,
                      0,
                      (self.sendButton1.frame.size.width-self.sendButton1.titleLabel.intrinsicContentSize.width)/2)];
    [self.sendButton1 setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.sendButton1.frame.size.width-self.sendButton1.imageView.frame.size.width)/2,
                      self.sendButton1.titleLabel.intrinsicContentSize.height,
                      (self.sendButton1.frame.size.width-self.sendButton1.imageView.frame.size.width)/2)];
    
    [self.removeButton1 setTitleEdgeInsets:
     UIEdgeInsetsMake(self.removeButton1.frame.size.height/2,
                      (self.removeButton1.frame.size.width-self.removeButton1.titleLabel.intrinsicContentSize.width)/2-self.removeButton1.imageView.frame.size.width,
                      0,
                      (self.removeButton1.frame.size.width-self.removeButton1.titleLabel.intrinsicContentSize.width)/2)];
    [self.removeButton1 setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.removeButton1.frame.size.width-self.removeButton1.imageView.frame.size.width)/2,
                      self.removeButton1.titleLabel.intrinsicContentSize.height,
                      (self.removeButton1.frame.size.width-self.removeButton1.imageView.frame.size.width)/2)];
    
    /**
     * des:
     * author:SkyWork
     */
    [self.deleteButton2 setTitleEdgeInsets:
     UIEdgeInsetsMake(self.deleteButton2.frame.size.height/2,
                      (self.deleteButton2.frame.size.width-self.deleteButton2.titleLabel.intrinsicContentSize.width)/2-self.deleteButton2.imageView.frame.size.width,
                      0,
                      (self.deleteButton2.frame.size.width-self.deleteButton2.titleLabel.intrinsicContentSize.width)/2)];
    [self.deleteButton2 setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.deleteButton2.frame.size.width-self.deleteButton2.imageView.frame.size.width)/2,
                      self.deleteButton2.titleLabel.intrinsicContentSize.height,
                      (self.deleteButton2.frame.size.width-self.deleteButton2.imageView.frame.size.width)/2)];
    
    
    [self.renameButton2 setTitleEdgeInsets:
     UIEdgeInsetsMake(self.renameButton2.frame.size.height/2,
                      (self.renameButton2.frame.size.width-self.renameButton2.titleLabel.intrinsicContentSize.width)/2-self.renameButton2.imageView.frame.size.width,
                      0,
                      (self.renameButton2.frame.size.width-self.renameButton2.titleLabel.intrinsicContentSize.width)/2)];
    
    [self.renameButton2 setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.renameButton2.frame.size.width-self.renameButton2.imageView.frame.size.width)/2,
                      self.renameButton2.titleLabel.intrinsicContentSize.height,
                      (self.renameButton2.frame.size.width-self.renameButton2.imageView.frame.size.width)/2)];
    
    [self.removeButton2 setTitleEdgeInsets:
     UIEdgeInsetsMake(self.removeButton2.frame.size.height/2,
                      (self.removeButton2.frame.size.width-self.removeButton2.titleLabel.intrinsicContentSize.width)/2-self.removeButton2.imageView.frame.size.width,
                      0,
                      (self.removeButton2.frame.size.width-self.removeButton2.titleLabel.intrinsicContentSize.width)/2)];
    [self.removeButton2 setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.removeButton2.frame.size.width-self.removeButton2.imageView.frame.size.width)/2,
                      self.removeButton2.titleLabel.intrinsicContentSize.height,
                      (self.removeButton2.frame.size.width-self.removeButton2.imageView.frame.size.width)/2)];
    
}

@end
