//
//  StitchingImageView.m
//  SlideView
//
//  Created by Ghost on 8/30/16.
//  Copyright © 2016 axel. All rights reserved.
//

#import "StitchingImageView.h"

@implementation StitchingImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CALayer *layer = [[CALayer alloc]init];
        layer.contents = [UIImage imageNamed:@""];
        [self.layer addSublayer:layer];
    }
    return self;
}

@end
