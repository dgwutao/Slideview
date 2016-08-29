//
//  CaTextLayerView.h
//  SlideView
//
//  Created by Ghost on 8/29/16.
//  Copyright © 2016 axel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CATextLayerView : UIView
@property (copy, nonatomic) NSString *string;
@property (copy, nonatomic) UIFont *font;
@property (copy, nonatomic) UIColor *forgroundColor;
@property (assign, nonatomic) CGFloat fontSize;
@end
