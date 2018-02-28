//
//  SliderSegementView.h
//  Call
//
//  Created by admin on 2017/7/8.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GQSliderSegementViewDelegate <NSObject>

/**
 点击Segment上选项的代理
 
 @param view Segment
 @param selectIndex 第几个选项
 */
- (void)sliderSegementView:(UIView *)view selectIndex:(NSInteger)selectIndex;

@end

@interface GQSliderSegementView : UIView

@property (nonatomic, weak) id<GQSliderSegementViewDelegate> delegate;

/**
 创建Segment

 @param frame 尺寸
 @param titleArr 标题数组
 @param titleColor 标题未选中颜色
 @param selectTitleColor 标题选中颜色
 @param titleFont 标题未选中大小
 @param selectTitleFont 标题选中大小
 @param hiddenVertical 是否隐藏中间分割线
 @return 返回视图
 */
- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor titleFont:(UIFont *)titleFont selectTitleFont:(UIFont *)selectTitleFont hiddenVertical:(BOOL)hiddenVertical;

/**
 使Segment指向第几个选项

 @param index 第几个选项
 */
- (void)actionScrollToIndex:(NSInteger)index;

@end
