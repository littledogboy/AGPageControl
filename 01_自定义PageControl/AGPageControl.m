//
//  AGPageControl.m
//  01_自定义PageControl
//
//  Created by 吴书敏 on 15/10/13.
//  Copyright © 2015年 littledogboy. All rights reserved.
//

#import "AGPageControl.h"


#define kDotDiameter  4.0f  // 圆点默认直径4个点
#define kDotSpace 12.0f // 圆点默认间距12个点
#define kTop  2.0f // 上边距 2
#define kLeft  22.0f // 左边距 22 ,高度默认为 2 * kLeft

@implementation AGPageControl


#pragma mark-
#pragma mark init -  初始化方法

// 重写 init 方法
- (instancetype)init
{
    self = [super initWithFrame:CGRectZero]; // frame 0
    return self;
}

// 重写 initWithFrame 方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero]; // frame 0
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


// 实现 initWithType 方法
- (instancetype)initWithType:(AGPageControlType)type
{
    self = [self initWithFrame:CGRectZero]; // frame 0
    
    if (self) {
        self.type = type;
    }
    
    return self;
}


#pragma mark-
#pragma mark Accessors - 属性访问器

//  currentPage setter  需要绘制
- (void)setCurrentPage:(NSInteger)currentPage
{
    if (_currentPage != currentPage) {
        
        // 0<= currentPage <= numberOfPages - 1
        _currentPage = MIN(MAX(0, MAX(0, currentPage)), _numberOfPages -1 );
        
        if (self.defersCurrentPageDisplay == NO) {
            [self setNeedsDisplay]; // setNeedsDisplay 会调用 drawRect 方法
        }
        
    }
}


// setNumbersOfPage setter
- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    if (_numberOfPages != numberOfPages) {
        
        // _numberOfPages <= 0 <= numberOfPages
        _numberOfPages = MAX(0, numberOfPages);
        
        
        // 0<=   currentPage  <= _numberOfPages
        _currentPage = MIN(MAX(0, _currentPage), _numberOfPages);
        
        // 更新bounds
        self.bounds = self.bounds;
        
        // 当页面数为1时是否隐藏 pagecontrol ,默认为 no
        if (_hidesForSinglePage == YES && _numberOfPages < 2) {
            self.hidden = YES;
        } else{
            
            self.hidden = NO;
        }
        
    }
}


// hidesForSinglePage  setter
- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage
{
    
    _hidesForSinglePage = hidesForSinglePage;
    
    if (_hidesForSinglePage == YES && _numberOfPages < 2) {
        self.hidden = YES;
    }
}


// 延迟显示
- (void)setDefersCurrentPageDisplay:(BOOL)defersCurrentPageDisplay
{
    _defersCurrentPageDisplay = defersCurrentPageDisplay;
}


// 设置类型  需要绘制
- (void)setType:(AGPageControlType)type
{
    _type = type;
    
    [self setNeedsDisplay];
}


// 设置当前点颜色  需要绘制
- (void)setOnColor:(UIColor *)onColor
{
    if (_onColor != onColor) {
        
        _onColor = onColor;
        
        [self setNeedsDisplay];
        
    }
}


// 设置非当前点颜色  需要绘制
- (void)setOffColor:(UIColor *)offColor
{
    if (_offColor != offColor) {
        
        _offColor = offColor;
        
        [self setNeedsDisplay];
    }
}


// 设置 指示器的直径  重新绘制
- (void)setIndicatorDiameter:(CGFloat)indicatorDiameter
{
    _indicatorDiameter = indicatorDiameter > 0 ? indicatorDiameter : kDotDiameter;
    
    self.bounds = self.bounds; // 
    
    [self setNeedsDisplay];
}


// 设置 指示器间距 重新绘制
- (void)setIndicatorSpace:(CGFloat)indicatorSpace
{
    _indicatorSpace = indicatorSpace > 0 ? indicatorSpace : kDotSpace;
    
    self.bounds = self.bounds;
    
    [self setNeedsDisplay];
}


// *** 重写 setFrame 方法,不允许调用者 设置frame ，而是我们根据 sizeForNumberOfPages 获取size  指定frame
- (void)setFrame:(CGRect)frame
{
    frame.size = [self sizeForNumberOfPages:self.numberOfPages];
    super.frame = frame;
}

// *** 重写 setBound 方法 因为不允许调用设置frame，因此需要bounds
- (void)setBounds:(CGRect)bounds
{
    bounds.size = [self sizeForNumberOfPages:self.numberOfPages];
    
    super.bounds = bounds;
}



#pragma mark-
#pragma mark   UIPageControl  原生方法

// 实现原生 更新当前页方法
- (void)updateCurrentPageDisplay
{
    // 如果  defersCurrentPageDisplay 延迟执行设置为no ，则忽略该方法
    if (self.defersCurrentPageDisplay == NO) {
        return;
    } else
    {
        
    // 如果设置为  YES, 重新绘制 当前视图， 显示到正确的页面
        [self setNeedsDisplay];
    }
    
}


// 实现原声 根据页面数获取size 大小方法
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    CGFloat diameter = self.indicatorDiameter;
    
    CGFloat space = self.indicatorSpace;
    
    // 返回size
    
    CGFloat width = pageCount * diameter + (pageCount - 1) * space + kLeft * 2;
    
    CGFloat height = MAX(2 * kLeft,  2 * kTop + diameter);
    
    return CGSizeMake(width, height);
    
}




#pragma mark-
#pragma mark Touches handlers - 处理点击
// 苹果原生的 pageControl 原点不能处理点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    // 获取触摸的位置
    UITouch *theTouch = [touches anyObject];
    
    CGPoint touchLocation = [theTouch locationInView:self];
    
    // 判断触摸点是在pageControl的 左边 还是 右边
    if (touchLocation.x < self.bounds.size.width / 2) {
        self.currentPage = MAX(self.currentPage - 1, 0);
    } else{
        
        self.currentPage = MIN(self.currentPage + 1, self.numberOfPages - 1);
    }
    
    //  *** send the value changed action to the target, target 执行 值改变 触发的方法
    
    // 这样处理之后，当控件值发生变化时，每一个对象(观察者——注册该事件)都会收到响应的通知。
    [self sendActionsForControlEvents:(UIControlEventValueChanged)];
    
}



#pragma mark-
#pragma mark drawRect - 绘制方法
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 drawRect在以下情况下会被调用：
 1. 初始化时设置 frame 大小
 2. 在controller 会在 loadView viewDieLoad 之后调用
 3. sizeToFit 之后调用
 4. 过设置contentMode属性值为UIViewContentModeRedraw。那么将在每次设置或更改frame的时候自动调用drawRect:
 5. 直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0。

 
 cggraphics 引擎
 
 
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    // 1. 获取 current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    // 2. save the context 入到图形堆栈, 把copy
    CGContextSaveGState(context);
    
    
    // 3. 设置
    // 画弧线 ，需要支持反锯齿
    CGContextSetAllowsAntialiasing(context, TRUE);
    
    
    
    
    // x, y
    CGFloat diameter = self.indicatorDiameter;
    CGFloat space = self.indicatorSpace;
    
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = _numberOfPages * diameter + (_numberOfPages - 1) * space;
    
    CGFloat x = CGRectGetMidX(currentBounds) - dotsWidth / 2;
    CGFloat y = CGRectGetMidY(currentBounds) - diameter / 2;
    
    // onColor offColor
    CGColorRef onColorCG = _onColor ? _onColor.CGColor : [UIColor colorWithWhite:1.0 alpha:1.0].CGColor; // 指定颜色 或者 默认白色
    
    CGColorRef offColorCG = _offColor ? _offColor.CGColor : [UIColor colorWithWhite:0.7f alpha:0.5].CGColor; // 指定颜色 或者 默认灰色
    
    
    // 画点
    for (int i = 0; i < _numberOfPages; i++) {
        
        // 点的位置
        CGRect dotRect = CGRectMake(x, y, diameter, diameter);
        
        // 绘制当前点
        if (i == _currentPage) {
            
            // 根据不同类型绘制不同的点
            // 系统默认样式实心 实心 ， 或者 实心  空心
            // 当前点为实心点
            if (_type == AGPageControlTypeOnFullOffFull || _type == AGPageControlTypeOnFullOffEmpty) {
                
                // strokeColor 空心颜色
                CGContextSetStrokeColorWithColor(context, onColorCG);
                
                // 不会填充颜色只是有个边缘线
                CGContextStrokeEllipseInRect(context, dotRect);
                
                // fillColor 填充色
                CGContextSetFillColorWithColor(context, onColorCG);
                
                // 返回一个同心矩形，或大 或小
                CGRect insetRect = CGRectInset(dotRect, 2, 2);
                
                // 画一个矩形的内接椭圆，并且填充颜色
                CGContextFillEllipseInRect(context, insetRect);
                
            } else{ // 当前点为空心点
                
                // strokeColor 空心颜色
                CGContextSetStrokeColorWithColor(context, onColorCG);
                
                // 不会填充颜色只是有个边缘线
                CGContextStrokeEllipseInRect(context, dotRect);
                
                
            }
            
            
        }else{  // 绘制非当前点
        
            // 如果类型为 空 空 ， 不空 空
            // 非当前点为 空心点
            if (_type == AGPageControlTypeOnEmptyOffEmpty || _type == AGPageControlTypeOnFullOffEmpty) {
                
                CGContextSetStrokeColorWithColor(context, offColorCG);
                
                CGContextStrokeEllipseInRect(context, dotRect);
                

            } else{ //  实心点
                
                CGContextSetFillColorWithColor(context, offColorCG);
                
                CGRect insetRect = CGRectInset(dotRect, -0.5f, -0.5f);
                
                CGContextFillEllipseInRect(context, insetRect);
                
            }
            
        } // i else 结束
        
        
        // i++,更改 x 的值
        x += diameter + space;
        
        
    } // for 结束
    
    
    
    // 4. 恢复到最近的 graph context
    CGContextRestoreGState(context);
    
}




@end
