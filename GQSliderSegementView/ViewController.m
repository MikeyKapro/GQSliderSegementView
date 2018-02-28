//
//  ViewController.m
//  GQSliderSegementView
//
//  Created by 陆国庆 on 2018/2/27.
//  Copyright © 2018年 lgq. All rights reserved.
//

#import "ViewController.h"
#import "GQSliderSegementView.h"

// 屏幕的宽
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

// 屏幕的高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// tableview高度
#define tableHeight  (SCREEN_HEIGHT - 20 - 40)

//随机颜色
#define k_COLORRANDOM [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0]


@interface ViewController () <UITableViewDelegate, UITableViewDataSource, GQSliderSegementViewDelegate>

@property (nonatomic, strong) GQSliderSegementView *segmentView;
@property (nonatomic, strong) UIScrollView *bgScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initUI];
    [self makeConstrains];
}

#pragma mark - UI
- (void)initUI {
    
    // 创建Segment
    NSArray *titleArr = @[@"推荐人数排行",@"我推荐的人"];
    self.segmentView = [[GQSliderSegementView alloc] initWithFrame:CGRectZero
                                                          titleArr:titleArr
                                                        titleColor:[UIColor redColor]
                                                  selectTitleColor:[UIColor whiteColor]
                                                         titleFont:[UIFont systemFontOfSize:12]
                                                   selectTitleFont:[UIFont systemFontOfSize:12]
                                                    hiddenVertical:NO];
    self.segmentView.delegate = self;
    [self.view addSubview:self.segmentView];
    
    // 创建Segment下面的ScrollView
    UIScrollView *bgScrollView = [[UIScrollView alloc] init];
    bgScrollView.pagingEnabled = YES;
    bgScrollView.delegate = self;
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    [self.view addSubview:bgScrollView];
    self.bgScrollView = bgScrollView;
    
    // 创建ScrollView上的tableview
    for (int i = 0; i < 2; i++) {
        
        UITableView *tableview = [self createTableViewWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, tableHeight)];
        [bgScrollView addSubview:tableview];
        
    }
}

#pragma mark - 创建tableview
- (UITableView *)createTableViewWithFrame:(CGRect)frame {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = k_COLORRANDOM;
    tableView.rowHeight = 50;
    
    
    return tableView;
}

#pragma mark - 约束
- (void)makeConstrains {
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.right.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.bottom.equalTo(@0);
        
    }];
}

#pragma mark - UITableViewDateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    return cell;
}

#pragma mark - GQSliderSegementViewDelegate

#pragma mark -- 点击segment滑动ScrollView
- (void)sliderSegementView:(UIView *)view selectIndex:(NSInteger)selectIndex {
    
    [self.bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * selectIndex, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

#pragma mark -- 滑动ScrollView改变segment的指向
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger selectIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self.segmentView actionScrollToIndex:selectIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
