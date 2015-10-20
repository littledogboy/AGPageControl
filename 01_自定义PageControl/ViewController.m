//
//  ViewController.m
//  01_自定义PageControl
//
//  Created by 吴书敏 on 15/10/13.
//  Copyright © 2015年 littledogboy. All rights reserved.
//

#import "ViewController.h"
#import "AGPageControl.h"




@interface ViewController ()

@property (nonatomic, strong) AGPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    
    // agpageControl
    //  初始化 + 类型
    self.pageControl = [[AGPageControl alloc] initWithType:(AGPageControlTypeOnFullOffEmpty)];
    
    // center
    [_pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-30.0f)] ;

    
    // numberOfPages
    _pageControl.numberOfPages = 5;
    
    // currentPag
    _pageControl.currentPage = 0;
    
    
    // onColor

    
    // offColor
    
    
    // diameter
    _pageControl.indicatorDiameter = 15;
    
    
    // space
    _pageControl.indicatorSpace = 15;
    
    
    // 添加
    [self.view addSubview:_pageControl];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
