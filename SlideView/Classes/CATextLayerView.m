//
//  CaTextLayerView.m
//  SlideView
//
//  Created by Ghost on 8/29/16.
//  Copyright © 2016 axel. All rights reserved.
//

#import "CaTextLayerView.h"

@interface CATextLayerView()
@property (strong, nonatomic) CATextLayer *textLayer;
@end

@implementation CATextLayerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initLayerWithFrame:frame];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initLayerWithFrame:CGRectZero];
    }
    return self;
}

-(void) initLayerWithFrame:(CGRect)frame{
    self.textLayer = [CATextLayer layer];
    self.textLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.textLayer.foregroundColor = [UIColor blackColor].CGColor;
    self.textLayer.alignmentMode = kCAAlignmentLeft;
    self.textLayer.wrapped = YES;
    UIFont *font = [UIFont systemFontOfSize:15];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.textLayer.font = fontRef;
    self.textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    self.backgroundColor = [UIColor whiteColor];
    [self.layer addSublayer:self.textLayer];
}

- (void)setString:(NSString *)string{
    _string = string;
    self.textLayer.string = string;
}

-(void)setFont:(UIFont *)font{
    _font = font;
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.textLayer.font = fontRef;
    CGFontRelease(fontRef);
}

-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    self.textLayer.fontSize = fontSize;
}

-(void)setForgroundColor:(UIColor *)forgroundColor{
    _forgroundColor = forgroundColor;
    self.textLayer.foregroundColor = forgroundColor.CGColor;
}


@end
