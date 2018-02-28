//
//  SliderSegementView.m
//  Call
//
//  Created by admin on 2017/7/8.
//  Copyright © 2017年 young. All rights reserved.
//

#import "GQSliderSegementView.h"

//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Iphone6_Scale    [UIScreen mainScreen].bounds.size.width/375.0

// 初始tag值
static NSInteger const initTag = 200;

@interface GQSliderSegementView ()

@property (nonatomic, strong) NSMutableArray *buttonArr;

@property (nonatomic, strong) UIButton *frontSender; // 前一个点击的按钮
@property (nonatomic, strong) UIView *bottomSlider;
@property (nonatomic, strong) UILabel *bottomLineView;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectTitleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *selectTitleFont;
@property (nonatomic, assign) BOOL hiddenVertical; // 是否隐藏分割线

@end

@implementation GQSliderSegementView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor titleFont:(UIFont *)titleFont selectTitleFont:(UIFont *)selectTitleFont hiddenVertical:(BOOL)hiddenVertical {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleArr = titleArr;
        self.titleColor = titleColor;
        self.selectTitleColor = selectTitleColor;
        self.titleFont = titleFont;
        self.selectTitleFont = selectTitleFont;
        self.hiddenVertical = hiddenVertical;
        
        [self initUI];
        [self makeConstrains];
    }
    
    return self;
}

#pragma mark - UI

- (void)initUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 创建Segment的选项
    [self createSegmentBtns];
    
    // 蓝色滑动
    self.bottomSlider = [[UIView alloc] init];
    self.bottomSlider.hidden = NO;
    self.bottomSlider.backgroundColor = self.selectTitleColor;
    [self addSubview:self.bottomSlider];
    
    // 底线
    UILabel *bottomLineView = [[UILabel alloc] init];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomLineView];
    self.bottomLineView = bottomLineView;
    
    [self makeConstrains];
}

#pragma mark -- 创建Segment的选项以及分割线
- (void)createSegmentBtns {
    
    self.buttonArr = [NSMutableArray arrayWithCapacity:self.titleArr.count];
    
    for (int i = 0; i < self.titleArr.count; i++) {
        
        UIButton *btn = [self createBtnWithIndex:i];
        if (i == 0) {
            btn.selected = YES;
            btn.titleLabel.font = self.selectTitleFont;
            
            self.frontSender = btn;
        }
        
        [self addSubview:btn];
        [self.buttonArr addObject:btn];
        
        // 分隔线
        if (i > 0) {
            
            UILabel *vertical = [[UILabel alloc] init];
            vertical.backgroundColor = [UIColor lightGrayColor];
            vertical.hidden = self.hiddenVertical;
            [self addSubview:vertical];
            
            [vertical mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn.mas_left).offset(-18*KWidth_Iphone6_Scale);
                make.centerY.equalTo(btn);
                make.width.equalTo(@1);
                make.height.equalTo(self).dividedBy(2);
            }];
            
        }
    }
    
}

#pragma mark -- 创建单个选项
- (UIButton *)createBtnWithIndex:(NSInteger)index {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:self.titleArr[index] forState:UIControlStateNormal];
    [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
    [btn setTitleColor:self.selectTitleColor forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(actionClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 12;
    btn.layer.borderColor = self.titleColor.CGColor;
    btn.layer.borderWidth = 1;
    btn.titleLabel.font = self.titleFont;
    [btn setBackgroundImage:[self createBackgroundImageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
    [btn setBackgroundImage:[self createBackgroundImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = NO;
    btn.tag = initTag + index;
    return btn;
}

#pragma mark -- 根据颜色创建背景图片
- (UIImage *)createBackgroundImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}

#pragma mark -- 约束
- (void)makeConstrains {
    
    [self.buttonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:36*KWidth_Iphone6_Scale leadSpacing:20*KWidth_Iphone6_Scale tailSpacing:20*KWidth_Iphone6_Scale];
    
    [self.buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self).multipliedBy(24.0/40);
        make.centerY.equalTo(self);
    }];
    
    UIButton *firstBtn = self.buttonArr.firstObject;
    
    [self.bottomSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.left.equalTo(firstBtn.titleLabel.mas_left);
        make.right.equalTo(firstBtn.titleLabel.mas_right);
        make.bottom.equalTo(self);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - action

#pragma mark -- 点击Segment选项
- (void)actionClickBtn:(UIButton *)sender {
    
    if (sender == self.frontSender) {
        return;
    }

    [self changeBtnStateWithBtn:sender];
    
    if (_delegate && [_delegate respondsToSelector:@selector(sliderSegementView:selectIndex:)]) {
        [_delegate sliderSegementView:self selectIndex:sender.tag - initTag];
    }
}

#pragma mark -- 使Segment指向第几个选项
- (void)actionScrollToIndex:(NSInteger)index {
    
    UIButton *sender = self.buttonArr[index];
    
    if (sender == self.frontSender) {
        return;
    }
    
    [self changeBtnStateWithBtn:sender];
}

#pragma mark -- 改变Segment选项的状态
- (void)changeBtnStateWithBtn:(UIButton *)sender {
    
    self.frontSender.selected = NO;
    self.frontSender.titleLabel.font = self.titleFont;
    
    sender.selected = YES;
    sender.titleLabel.font = self.selectTitleFont;
    
    [self.bottomSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.left.equalTo(sender.titleLabel.mas_left);
        make.right.equalTo(sender.titleLabel.mas_right);
        make.bottom.equalTo(self);
        
    }];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self layoutIfNeeded];
    } completion:nil];
    
    self.frontSender = sender;
}

@end
