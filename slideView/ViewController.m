//
//  ViewController.m
//  slideView
//
//  Created by lin on 2017/7/10.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

#import "ViewController.h"
#import "BQLSlideView.h"

@interface ViewController ()

@property (nonatomic, strong) BQLSlideView *slideView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *array = @[@"我是第一张",@"我是第二张",@"我是第三张",
                       @"我是第四张",@"我是第五张",@"我是第六张",
                       @"我是第七张",@"我是第八张",@"我是第九张"];
    _slideView = [BQLSlideView cardView:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.width)];
    [_slideView setCardViews:array atIndex:0];
    _slideView.transfrom = YES;
    [self.view addSubview:_slideView];
}

- (IBAction)forward:(id)sender {
    
    [_slideView slideForwards];
}

- (IBAction)backward:(id)sender {
    
    [_slideView slideBackwards];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
