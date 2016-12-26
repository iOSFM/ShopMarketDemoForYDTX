//
//  SDCycleDispalyView.m
//  SDNews
//
//  Created by JW on 16/5/24.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "SDCycleDispalyView.h"

#import "UIImageView+WebCache.h"

//#import "UIImageView+Extension.h"

@interface SDCycleDispalyView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UIImageView *middleImageView;
@property (nonatomic, weak) UIImageView *rightImageView;
@property (nonatomic, weak) UIView *bottomContianerView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UILabel *titleLabel;

@end


@implementation SDCycleDispalyView
#pragma mark 初始化View
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

#pragma mark 初始化子控件
- (void)initialization {
    //初始化scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.frame = self.bounds;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*3, 0);
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    //初始化scrollView上的左中右三张imageView,
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView addSubview:imageView];
        if (i==0) {
            self.leftImageView = imageView;
        } else if (i==1) {
            self.middleImageView = imageView;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMiddleImageView)]];
            
        } else if (i==2) {
            self.rightImageView = imageView;
        }
    }
    
    //初始化View下方的存放titleLabel和pageControl的contianerView
    CGFloat kBottomContianerViewlHeight = 30;
    UIView *bottomContianerView = [[UIView alloc] init];
    self.bottomContianerView = bottomContianerView;
    bottomContianerView.frame = CGRectMake(0, self.bounds.size.height -kBottomContianerViewlHeight, self.bounds.size.width, kBottomContianerViewlHeight);
    bottomContianerView.backgroundColor = [UIColor clearColor];
    bottomContianerView.alpha = 0.8;
    [self addSubview:bottomContianerView];
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    self.pageControl  = pageControl;
    
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.224 green:0.741 blue:0.922 alpha:1.000];
    
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    CGFloat kPageControlWidth = [pageControl sizeForNumberOfPages:3].width;
    CGFloat margin = 10;
    pageControl.frame = CGRectMake(YDTXScreenW*0.5 -2*margin, 0, kPageControlWidth, bottomContianerView.frame.size.height);
    
    [bottomContianerView addSubview:pageControl];
    //
    //    //初始化titleLabel
    //    UILabel *titleLabel = [[UILabel alloc] init];
    //    self.titleLabel = titleLabel;
    //    titleLabel.frame = CGRectMake(0, 0, bottomContianerView.frame.size.width - kPageControlWidth - 2*margin, bottomContianerView.frame.size.height);
    //    titleLabel.textAlignment = NSTextAlignmentLeft;
    //    titleLabel.textColor = [UIColor whiteColor];
    //    titleLabel.backgroundColor = [UIColor darkGrayColor];
    //    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //    [bottomContianerView addSubview:titleLabel];
    //
}

#pragma mark UIScrollViewDelegate scrollView开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

#pragma mark UIScrollViewDelegate scrollView将要停止拖动（即手指将离开屏幕）
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self addTimer];
}

#pragma mark UIScrollViewDelegate scrollView将要停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (self.imageUrls == nil || self.imageUrls.count == 0 ) return;
        
        if (scrollView.contentOffset.x>=scrollView.frame.size.width) {//向右滑动
            self.currentMiddleImageViewIndex = (self.currentMiddleImageViewIndex + 1)%self.imageUrls.count;
        } else {//向左滑动
            self.currentMiddleImageViewIndex = (self.currentMiddleImageViewIndex - 1 + self.imageUrls.count)%self.imageUrls.count;
        }
        
        [self updateImageViewsAndTitleLabel];
    }
}

#pragma mark 数据刷新后更新imageView和TitleLabel
- (void)updateImageViewsAndTitleLabel {
    if (self.imageUrls == nil || self.imageUrls.count == 0 ) return;
    
    NSInteger leftIndex = (self.currentMiddleImageViewIndex - 1 + self.imageUrls.count)%self.imageUrls.count;
    NSURL *leftURL =[SXPublicTool getImageURLByURLString:self.imageUrls[leftIndex]];
    [self.leftImageView sd_setImageWithURL:leftURL placeholderImage:[UIImage imageNamed:@"zwt"]];
    
    
    
    NSURL *middleURL =[SXPublicTool getImageURLByURLString:self.imageUrls[_currentMiddleImageViewIndex]];
    [self.middleImageView sd_setImageWithURL:middleURL placeholderImage:[UIImage imageNamed:@"zwt"]];
    
    
    NSInteger rightIndex = (self.currentMiddleImageViewIndex + 1)%self.imageUrls.count;
    NSURL *rightURL =[SXPublicTool getImageURLByURLString:self.imageUrls[rightIndex]];
    [self.rightImageView sd_setImageWithURL:rightURL placeholderImage:[UIImage imageNamed:@"zwt"]];
    
    
    self.pageControl.numberOfPages = self.imageUrls.count;
    self.pageControl.currentPage = self.currentMiddleImageViewIndex;
    //重新设置scrollView的contentOffset,即将滑动后的imageView显示在最中间
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
}

#pragma mark 添加定时器
- (void)addTimer {
    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(nextNews) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}

#pragma mark 移除定时器
- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark scrollView轮播到下一个ImageView
- (void)nextNews {
    [UIView animateWithDuration:0.5 animations:^{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x+[UIScreen mainScreen].bounds.size.width, 0)];
    }];
    [self scrollViewDidEndDecelerating:self.scrollView];
}

#pragma mark 点击了中间的ImageView即当前显示的ImageView
- (void)clickMiddleImageView {
    if ([self.delegate respondsToSelector:@selector(clickCurrentImageViewInImageCyclePlay)]) {
        [self.delegate clickCurrentImageViewInImageCyclePlay];
    }
}




-(void)updateToDaySkinMode {
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:243/255.0 green:75/255.0 blue:80/255.0 alpha:1.0];
    self.titleLabel.textColor = [UIColor whiteColor];
}

-(void)updateToNightSkinMode {
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.titleLabel.textColor = [UIColor lightGrayColor];
}


@end