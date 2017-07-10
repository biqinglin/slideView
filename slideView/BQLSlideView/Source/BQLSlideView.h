//
//  BQLSlideView.h
//  slideView
//
//  Created by lin on 2017/7/10.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BQLSlideView;
@protocol BQLSlideViewDelegate <NSObject>

/**
 当前所选卡片及索引
 
 @param cardView 所选卡片
 @param index    索引
 */
- (void)cardView:(BQLSlideView *)cardView didSelectAtIndex:(NSInteger )index;

@end

@interface BQLSlideView : UIView

/**
 代理
 */
@property (nonatomic, weak) id<BQLSlideViewDelegate>delegate;

/**
 是否开启形变效果(左右两边小一点)
 */
@property (nonatomic, assign) BOOL transfrom;

/**
 初始化方法
 
 @return BQLCardView
 */
+ (instancetype)cardView:(CGRect )frame;

/**
 配置数据源
 
 @param cards 数据源数组
 @param index 指定当前显示索引
 */
- (void)setCardViews:(NSArray *)cards atIndex:(NSUInteger )index;

/**
 上一个
 */
- (void)slideForwards;
/**
 下一个
 */
- (void)slideBackwards;

@end
