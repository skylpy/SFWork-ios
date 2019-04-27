//
//  SFAnnotationView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAnnotationView.h"


@implementation SFAnnotationView


#define kCalloutWidth       80.0
#define kCalloutHeight      40.0

- (SFCalloutView *)calloutView{
    
    if (!_calloutView) {
        _calloutView = [[SFCalloutView alloc] init];
    }
    return _calloutView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            
        }
        
        self.calloutView.frame = CGRectMake(0, 0, kCalloutWidth, kCalloutHeight);
        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        
        
        
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (void)setCalltitle:(NSString *)calltitle{
    _calltitle = calltitle;
    self.calloutView.title = calltitle;
}

@end
