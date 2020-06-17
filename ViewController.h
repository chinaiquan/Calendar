//
//  ViewController.h
//  Calendar
//
//  Created by chi on 2020/6/16.
//  Copyright © 2020 chi-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *calendar;
@property UILabel *dateHeadLabel;
//星期指示栏
@property UIView *weekView;
//弹窗栏
@property UIView *dateView;
@property UILabel *dateInDateView;
@property UIButton *button;

//每月第一天是星期几
@property NSInteger firstDayWeekday;
//月的天数
@property NSInteger daysOfMonth;
//当前年
@property NSInteger year;
//当前月
@property NSInteger month;

//滑动手势
@property UISwipeGestureRecognizer *swipeGestureRecognizeRight;
@property UISwipeGestureRecognizer *swipeGestureRecognizeLeft;

@end

