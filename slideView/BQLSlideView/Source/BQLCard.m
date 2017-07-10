//
//  BQLSlideCard.m
//  slideView
//
//  Created by lin on 2017/7/10.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

#import "BQLCard.h"

@interface BQLCard ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation BQLCard

- (void)setupSubViews {
    
    _label = [[UILabel alloc] init];
    _label.textColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    [self addSubview:_label];
    _label.frame = CGRectMake(0, 0, self.frame.size.width, 30);
    _label.font = [UIFont systemFontOfSize:20];
    _label.textAlignment = 1;
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor redColor];
    [self addSubview:view1];
    view1.frame = CGRectMake(0, self.frame.size.height - 50, 50, 50);
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor blueColor];
    [self addSubview:view2];
    view2.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height - 50, 50, 50);
    UIView *view3 = [UIView new];
    view3.backgroundColor = [UIColor purpleColor];
    [self addSubview:view3];
    view3.frame = CGRectMake((self.frame.size.width - 50) / 2, (self.frame.size.height - 50) / 2, 50, 50);
}

- (void)setLabel_string:(NSString *)label_string {
    
    _label.text = label_string;
    _label_string = label_string;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
