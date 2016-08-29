//
//  AdsScrollView.h
//  Widget
//
//  Created by bita on 16/4/28.
//  Copyright © 2016年 Axel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMPageControl.h"

typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};

@interface AdsScrollView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *adScrollView;
@property (strong, nonatomic) AMPageControl *pageControl;
@property (strong, nonatomic) NSArray *imageLinkURL;
@property (strong, nonatomic) NSArray *adTitleArray;
@property (assign, nonatomic) UIPageControlShowStyle PageControlShowStyle;
@property (assign, nonatomic) AdTitleShowStyle adTitleStyle;
@property (copy, nonatomic) NSString *placeHolder;
@property (assign, nonatomic) BOOL isNeedCycleRoll;
@property (assign, nonatomic) CGFloat  adMoveTime;
@property (strong, nonatomic) UILabel *centerAdLabel;
@property (copy, nonatomic) void (^callBack)(NSInteger index);

- (void)setimageLinkURL:(NSArray *)imageLinkURL;
- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle;
- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle;
+ (id)adScrollViewWithFrame:(CGRect)frame imageLinkURL:(NSArray *)imageLinkURL placeHoderImageName:(NSString *)imageName pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle;

@end