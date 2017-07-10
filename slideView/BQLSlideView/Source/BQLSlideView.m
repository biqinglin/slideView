//
//  BQLSlideView.m
//  slideView
//
//  Created by lin on 2017/7/10.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

#import "BQLSlideView.h"
#import "UIView+BQLAdd.h"
#import "BQLCard.h"

@interface BQLSlideView () <UIScrollViewDelegate>
{
    CGFloat card_spacing;   // 卡片间距
    CGFloat card_width;     // 卡片宽度
    CGFloat card_height;    // 卡片高度
    NSUInteger current_card_index; // 当前索引
    NSUInteger temp_index;
}

@property (nonatomic, strong) NSMutableArray *dataSource; // 数据源

@property (nonatomic, strong) NSMutableArray *reuseViewsArray; // 复用view

@property (nonatomic, strong) NSMutableArray *cardsMapArray; // 卡片坐标与索引映射

@property (nonatomic, strong) UIScrollView *contentScroll;

@end

@implementation BQLSlideView

+ (instancetype)cardView:(CGRect )frame; {
    
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        _contentScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentScroll.backgroundColor = [UIColor clearColor];
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.showsVerticalScrollIndicator = NO;
        _contentScroll.delegate = self;
        [self addSubview:_contentScroll];
        
        card_width = self.width * 0.8;
        card_height = self.height;
        card_spacing = (self.width - card_width) * 0.5;
    }
    return self;
}

- (void)setCardViews:(NSArray *)cards atIndex:(NSUInteger )index {
    
    // 默认cars数组数据大于等于三，不然要这个功能并无卵用啊
    if(!cards || cards.count < 3 || index > cards.count) return;
    // 记录数据源
    [self.dataSource addObjectsFromArray:cards];
    // 配置备用View
    [self setupStandbyViews];
    // 记录当前索引
    current_card_index = index;
    temp_index = index;
    // 把每一个x坐标都记录下来，并且与current_card_index相对应 做一张映射
    [self setupCarsMap];
    // 展示最前面的cards并配置相关信息
    [self.reuseViewsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BQLCard *view = (BQLCard *)obj;
        CGFloat x = card_spacing + idx * (card_spacing * 0.5 + card_width);
        view.frame = CGRectMake(x, 0, card_width, card_height);
        [view setupSubViews];
        [_contentScroll addSubview:view];
        
        CardsMap map = {x,idx};
        view.map = map;
        CardsMode mode = (CardsMode )idx;
        view.mode = mode;
        view.label_string = self.dataSource[idx];
    }];
    [_contentScroll setContentOffset:CGPointMake((card_width + card_spacing * 0.5) * current_card_index, 0) animated:YES];
    _contentScroll.contentSize = CGSizeMake(card_width * cards.count + (cards.count - 1) * (card_spacing * 0.5) + card_spacing * 2, 0);
}

// 配置备用View
- (void)setupStandbyViews {
    
    // 配置三个View，进行复用
    for(int i = 0; i < 3; i ++) {
        
        BQLCard *view = [[BQLCard alloc] init];
        view.backgroundColor = [UIColor lightGrayColor];
        [self.reuseViewsArray addObject:view];
    }
}

- (void)setupCarsMap {
    
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat x = card_spacing + idx * (card_spacing * 0.5 + card_width);
        CardsMap map = {x,idx};
        NSValue *map_value = [NSValue value:&map withObjCType:@encode(CardsMap)];
        [self.cardsMapArray addObject:map_value];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.x;
    float a = offset / (card_width + card_spacing / 2);
    // 计算实时索引变化
    if (a - (int)a > 0.5) {
        current_card_index = (int)a + 1;
    }
    else {
        current_card_index = (int)a;
    }
    // 更新frame
    BOOL to_right = current_card_index>temp_index?YES:NO;
    if(temp_index != current_card_index) {
        [self updateViewsFrame:current_card_index right:to_right];
    }
    else {
        if(_transfrom) {
            float temp_space = card_spacing * 2;
            float temp_width = card_width;
            for(UIView *view in _contentScroll.subviews) {
                
                if([view isKindOfClass:[BQLCard class]]) {
                    BQLCard *card = (BQLCard *)view;
                    NSInteger index = card.map.index;
                    CGFloat width = temp_width + temp_space/4;
                    CGFloat y = index * width;
                    CGFloat value = (offset-y)/width;
                    CGFloat scale = fabs(cos(fabs(value)*M_PI/6));
                    view.transform = CGAffineTransformMakeScale(1.0, scale);
                }
            }
        }
    }
    temp_index = current_card_index;
}

// 更新view's frame
- (void)updateViewsFrame:(NSUInteger )index right:(BOOL )right {
    
    if(!((index == 0 && !right) ||
         (index == 1 && right) ||
         (index == self.dataSource.count - 1 && right) ||
         (index == self.dataSource.count - 2 && !right))) {
        
        NSValue *value_left = [self.cardsMapArray objectAtIndex:index - 1];
        NSValue *value_center = [self.cardsMapArray objectAtIndex:index];
        NSValue *value_right = [self.cardsMapArray objectAtIndex:index + 1];
        CardsMap map_left;
        [value_left getValue:&map_left];
        CardsMap map_center;
        [value_center getValue:&map_center];
        CardsMap map_right;
        [value_right getValue:&map_right];
        [self.reuseViewsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BQLCard *cards = (BQLCard *)obj;
            if(cards.mode == CardsModeLeft) {
                if(right) {
                    cards.left = map_right.x;
                }
                cards.mode = right?CardsModeRight:CardsModeCenter;
                cards.map = right?map_right:map_center;
            }
            else if (cards.mode == CardsModeCenter) {
                
                cards.mode = right?CardsModeLeft:CardsModeRight;
                cards.map = right?map_left:map_right;
            }
            else if (cards.mode == CardsModeRight) {
                if(!right) {
                    cards.left = map_left.x;
                }
                cards.mode = right?CardsModeCenter:CardsModeLeft;
                cards.map = right?map_center:map_left;
            }
            cards.label_string = self.dataSource[cards.map.index];
        }];
    }
}

- (void)slideForwards {
    
    if(current_card_index > 0) {
        [_contentScroll setContentOffset:CGPointMake((card_width + card_spacing * 0.5) * (current_card_index - 1), 0) animated:YES];
    }
}

- (void)slideBackwards {
    
    if(current_card_index < self.dataSource.count - 1) {
        
        [_contentScroll setContentOffset:CGPointMake((card_width + card_spacing * 0.5) * (current_card_index + 1), 0) animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollEndWithAnimation];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self scrollEndWithAnimation];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    NSLog(@"scrollview's animation is end : %ld",current_card_index);
}

- (void)scrollEndWithAnimation {
    
    [_contentScroll setContentOffset:CGPointMake((card_width + card_spacing / 2.0) * current_card_index, 0) animated:YES];
}

- (NSMutableArray *)reuseViewsArray {
    
    if(!_reuseViewsArray) {
        _reuseViewsArray = [NSMutableArray array];
    }
    return _reuseViewsArray;
}

- (NSMutableArray *)dataSource {
    
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)cardsMapArray {
    
    if(!_cardsMapArray) {
        _cardsMapArray = [NSMutableArray array];
    }
    return _cardsMapArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
