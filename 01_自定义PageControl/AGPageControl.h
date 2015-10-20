//
//  AGPageControl.h
//  01_自定义PageControl
//
//  Created by 吴书敏 on 15/10/13.
//  Copyright © 2015年 littledogboy. All rights reserved.


/*  
 此为自定义的 pageControl
*/

#import <UIKit/UIKit.h>


typedef enum
{
    AGPageControlTypeOnFullOffFull = 0, // on 实心，off 实心
    AGPageControlTypeOnFullOffEmpty = 1, // on 实心， off 空心
    AGPageControlTypeOnEmptyOffFull = 2, // on 空心， off 实心
    AGPageControlTypeOnEmptyOffEmpty = 3 // on 空心， off 空心
    
}AGPageControlType;


@interface AGPageControl : UIControl

// 系统属性
@property (nonatomic,assign) NSInteger numberOfPages; // 总页数

@property (nonatomic,assign) NSInteger currentPage; // 当前页数

@property (nonatomic,assign) BOOL hidesForSinglePage; // 隐藏单页面

@property (nonatomic,assign) BOOL defersCurrentPageDisplay; // 延迟当前页面显示


// pageControl原生方法
- (void)updateCurrentPageDisplay; // 更新显示

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount; // page 不同页面数 size 大小



/*
 AGPageControl 附加选项， 以下所有属性都是可选的。如果没有设置任何属性，那么创建出来的是 苹果原生的 pageControl。
 */


// 初始化时设置类型
- (instancetype)initWithType:(AGPageControlType)type;

@property (nonatomic,assign) AGPageControlType type; // 类型

@property (nonatomic,strong) UIColor *onColor; // 当前颜色

@property (nonatomic,strong) UIColor *offColor; // 非当前颜色

@property (nonatomic,assign) CGFloat indicatorDiameter; // 指示器直径

@property (nonatomic,assign) CGFloat indicatorSpace; // 指示器水平间距






@end
