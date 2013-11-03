//
//  ImageAnnotationView.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/30/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "ImageAnnotationView.h"

@implementation ImageAnnotationView

- (void)setIconImage:(UIImage *)iconImage
{
    [_iconImageView removeFromSuperview];
    
    _iconImage = [UIImage imageNamed:@"skylineMarker"];
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                             self.iconImage.size.width, self.iconImage.size.height);
    
    _iconImageView = [[UIImageView alloc] initWithImage:self.iconImage];
    [self addSubview:_iconImageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
