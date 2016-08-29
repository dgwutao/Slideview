//
//  AdsScrollView.m
//  Widget
//
//  Created by bita on 16/4/28.
//  Copyright © 2016年 Axel. All rights reserved.
//

#import "AdsScrollView.h"
#import "UIImageView+WebCache.h"
#import "AMPageControl.h"

#define kAdViewWidth  _adScrollView.bounds.size.width
#define kAdViewHeight  _adScrollView.bounds.size.height
#define HIGHT _adScrollView.bounds.origin.y

@interface AdsScrollView ()
{
    UILabel *_centerAdLabel;
    CGFloat _adMoveTime;
    UIImageView *_leftImageView;
    UIImageView *_centerImageView;
    UIImageView *_rightImageView;
    UIView *_maskView;
    BOOL _isTimeup;
}

@property (assign, nonatomic) NSInteger centerImageIndex;
@property (assign, nonatomic) NSInteger leftImageIndex;
@property (assign, nonatomic) NSInteger rightImageIndex;
@property (assign, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@end

@implementation AdsScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _adMoveTime = 3.0;
        _adScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _adScrollView.bounces = NO;
        _adScrollView.delegate = self;
        _adScrollView.pagingEnabled = YES;
        _adScrollView.showsVerticalScrollIndicator = NO;
        _adScrollView.showsHorizontalScrollIndicator = NO;
        _adScrollView.backgroundColor = [UIColor whiteColor];
        _adScrollView.contentOffset = CGPointMake(kAdViewWidth, 0);
        _adScrollView.contentSize = CGSizeMake(kAdViewWidth * 3, kAdViewHeight);
        _adScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAdViewWidth, kAdViewHeight)];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAdViewWidth, 0, kAdViewWidth, kAdViewHeight)];
        _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _centerImageView.userInteractionEnabled = YES;
        [_centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAdViewWidth*2, 0, kAdViewWidth, kAdViewHeight)];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [_adScrollView addSubview:_leftImageView];
        [_adScrollView addSubview:_centerImageView];
        [_adScrollView addSubview:_rightImageView];

        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0,  kAdViewHeight - 30, kAdViewWidth * 3, 30)];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.bounds = _maskView.bounds;
        gradientLayer.borderWidth = 0;
        gradientLayer.frame = _maskView.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[[UIColor clearColor] CGColor],
                                (id)[[UIColor blackColor] CGColor], nil];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        [_maskView.layer insertSublayer:gradientLayer atIndex:0];
        _maskView.alpha = 0.7;
        [_adScrollView addSubview:_maskView];
        _isNeedCycleRoll = YES;
        [self addSubview:_adScrollView];
    }
    return self;
}

- (void)setupTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (_isNeedCycleRoll && _imageLinkURL.count > 1){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_adMoveTime target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        _isTimeup = NO;
    }
}

- (void)setIsNeedCycleRoll:(BOOL)isNeedCycleRoll
{
    _isNeedCycleRoll = isNeedCycleRoll;
    if (!_isNeedCycleRoll) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

+ (id)adScrollViewWithFrame:(CGRect)frame imageLinkURL:(NSArray *)imageLinkURL placeHoderImageName:(NSString *)imageName pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if(imageLinkURL.count == 0) return nil;
    AdsScrollView *adView = [[AdsScrollView alloc]initWithFrame:frame];
    adView.placeHolder = imageName;
    [adView setimageLinkURL:imageLinkURL];
    [adView setPageControlShowStyle:PageControlShowStyle];
    return adView;
}

+ (id)adScrollViewWithFrame:(CGRect)frame localImageLinkURL:(NSArray *)imageLinkURL pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if(imageLinkURL.count == 0) return nil;
    NSMutableArray *imagePaths = [[NSMutableArray alloc]init];
    for(NSString *imageName in imageLinkURL){
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        NSAssert(path, @"图片名对应的图片不存在");
        NSURL *imageURL = [NSURL fileURLWithPath:path];
        [imagePaths addObject:imageURL];
    }
    AdsScrollView *adView = [[AdsScrollView alloc]initWithFrame:frame];
    [adView setimageLinkURL:imagePaths];
    [adView setPageControlShowStyle:PageControlShowStyle];
    return adView;
}

- (void)setimageLinkURL:(NSArray *)imageLinkURL
{
    _imageLinkURL = imageLinkURL;
    self.leftImageIndex = _imageLinkURL.count - 1;
    self.centerImageIndex = 0;
    self.rightImageIndex = 1;
    if (_imageLinkURL.count < 2) {
        _adScrollView.scrollEnabled = NO;
        self.rightImageIndex = 0;
        if (self.centerImageIndex < _imageLinkURL.count) {
            [_centerImageView sd_setImageWithURL:_imageLinkURL[self.centerImageIndex] placeholderImage:[UIImage imageNamed:self.placeHolder]];
        }
    }else{
        _adScrollView.scrollEnabled = YES;
        [self renderImages];
    }
    [self setupTimer];
}

- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle
{
    _adTitleArray = adTitleArray;
    if (_centerAdLabel) {
        [_centerAdLabel removeFromSuperview];
        _centerAdLabel = nil;
    }
    if(adTitleStyle == AdTitleShowStyleNone || _adTitleArray.count == 0) return;
    _centerAdLabel = [[UILabel alloc]init];
    _centerAdLabel.backgroundColor = [UIColor clearColor];
    _centerAdLabel.textColor = [UIColor colorWithHexValue:0xFFFFFF alpha:1.0];
    _centerAdLabel.numberOfLines = 1;
    _centerAdLabel.font = [UIFont boldSystemFontOfSize:12];
    _centerAdLabel.textAlignment = NSTextAlignmentLeft;
    if (self.centerImageIndex < _adTitleArray.count) {
        _centerAdLabel.text = _adTitleArray[self.centerImageIndex];
    }
    NSInteger spacing = 0;
    if (_pageControl) {
        spacing = _pageControl.frame.size.width;
    }
    _centerAdLabel.frame = CGRectMake(10, kAdViewHeight - 25, kAdViewWidth - spacing - 22, 20);
    [self addSubview:_centerAdLabel];
}

- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (_pageControl) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    if (PageControlShowStyle == UIPageControlShowStyleNone || _imageLinkURL.count < 2) return;
    
    _pageControl = [[AMPageControl alloc]init];
    _pageControl.numberOfPages = _imageLinkURL.count;
    if (PageControlShowStyle == UIPageControlShowStyleLeft) {
        _pageControl.frame = CGRectMake(0, kAdViewHeight - 20, 20 * _pageControl.numberOfPages, 20);
    }
    else if (PageControlShowStyle == UIPageControlShowStyleCenter) {
        _pageControl.frame = CGRectMake(0, 0, 20*_pageControl.numberOfPages, 20);
        _pageControl.center = CGPointMake(kAdViewWidth/2.0, kAdViewHeight - 10);
    }
    else if (PageControlShowStyle == UIPageControlShowStyleRight) {
        _pageControl.frame = CGRectMake(kAdViewWidth - 10 - _pageControl.dotsWidth, kAdViewHeight - 17, _pageControl.dotsWidth, 7);
    }
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
}

- (void)timerTick:(NSTimer*)timer
{
    [_adScrollView setContentOffset:CGPointMake(kAdViewWidth * 2, 0) animated:YES];
    _isTimeup = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_adScrollView.contentOffset.x == 0){
        self.centerImageIndex--;
        self.leftImageIndex--;
        self.rightImageIndex--;
        if (self.leftImageIndex < 0) {
            self.leftImageIndex = _imageLinkURL.count - 1;
        }
        if (self.centerImageIndex < 0){
            self.centerImageIndex = _imageLinkURL.count - 1;
        }
        if (self.rightImageIndex < 0){
            self.rightImageIndex = _imageLinkURL.count - 1;
        }
    }else if(_adScrollView.contentOffset.x == kAdViewWidth * 2) {
        self.centerImageIndex++;
        self.leftImageIndex++;
        self.rightImageIndex++;
        if (self.leftImageIndex >= _imageLinkURL.count) {
            self.leftImageIndex = 0;
        }
        if (self.centerImageIndex >= _imageLinkURL.count){
            self.centerImageIndex = 0;
        }
        if (self.rightImageIndex >= _imageLinkURL.count){
            self.rightImageIndex = 0;
        }
    }else {
        return;
    }
    
    [self renderImages];
    
    _pageControl.currentPage = self.centerImageIndex;
    if (_adTitleArray && _adTitleArray.count > 0){
        if (self.centerImageIndex < _adTitleArray.count){
            _centerAdLabel.text = _adTitleArray[self.centerImageIndex];
        }
    }
    _adScrollView.contentOffset = CGPointMake(kAdViewWidth, 0);
    if (!_isTimeup) {
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_adMoveTime]];
    }
    _isTimeup = NO;
}

- (void)renderImages
{
    if (self.leftImageIndex < _imageLinkURL.count) {
        [_leftImageView sd_setImageWithURL:_imageLinkURL[self.leftImageIndex] placeholderImage:[UIImage imageNamed:self.placeHolder]];
    }
    
    if (self.centerImageIndex < _imageLinkURL.count) {
        [_centerImageView sd_setImageWithURL:_imageLinkURL[self.centerImageIndex] placeholderImage:[UIImage imageNamed:self.placeHolder]];
    }
    
    if (self.rightImageIndex < _imageLinkURL.count) {
        [_rightImageView sd_setImageWithURL:_imageLinkURL[self.rightImageIndex] placeholderImage:[UIImage imageNamed:self.placeHolder]];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}

-(void)tap
{
    if (_callBack){
        _callBack(self.centerImageIndex);
    }
}
@end
