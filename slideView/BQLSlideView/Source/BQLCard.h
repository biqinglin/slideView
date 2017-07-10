//
//  BQLSlideCard.h
//  slideView
//
//  Created by lin on 2017/7/10.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CardsMode) {
    
    CardsModeLeft = 0,  // 视野内左边
    CardsModeCenter,    // 视野内中间
    CardsModeRight,     // 视野内右边
};

typedef struct {
    CGFloat x;          // 卡片x坐标
    NSUInteger index;   // 卡片索引
}CardsMap; // 卡片坐标映射，并与cards关联起来（自定义cards）

@interface BQLCard : UIView

@property (nonatomic) CardsMap map;

@property (nonatomic, assign) CardsMode mode;

@property (nonatomic, copy) NSString *label_string;

- (void)setupSubViews;

@end
