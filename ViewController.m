//
//  ViewController.m
//  Calendar
//
//  Created by chi on 2020/6/16.
//  Copyright © 2020 chi-ios. All rights reserved.
//

#import "ViewController.h"
#import "collectionViewCellCollectionViewCell.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firstDayWeekday = [self getWeekDayOfFirstDay];
    self.daysOfMonth = [self getMonthDaysFromDate];
    self.year = [self getYearMonthDayWeekdayFromDate:[NSDate date]].year;
    self.month = [self getYearMonthDayWeekdayFromDate:[NSDate date]].month;
    //顶部日期栏
    self.dateHeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 40)];
    self.dateHeadLabel.textAlignment = NSTextAlignmentCenter;
    self.dateHeadLabel.text = [NSString stringWithFormat:@"%ld年%ld月",self.year,self.month];
    [self.view addSubview:self.dateHeadLabel];
    
    //星期展示栏
    self.weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 40)];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *weeks = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
    CGFloat weekWidth = SCREEN_WIDTH / 7;
    for(int i=0;i<7;++i) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*weekWidth, 0, weekWidth, 40)];
        label.text = weeks[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self.weekView addSubview:label];
        
    }
    [self.view addSubview:self.weekView];
    
    //日历-UICollectionView
    //layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    CGFloat width = (SCREEN_WIDTH-7)/7;
    layout.itemSize = CGSizeMake(width, width);
    
    self.calendar = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 350) collectionViewLayout:layout];
    self.calendar.backgroundColor = [UIColor whiteColor];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    [self.calendar registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:self.calendar];
    
    
    //弹窗视图
    self.dateView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 350, SCREEN_WIDTH/2, 80)];
    self.dateView.backgroundColor = [UIColor grayColor];
    //弹窗的日期显示栏
    self.dateInDateView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    self.dateInDateView.textAlignment = NSTextAlignmentCenter;
    [self.dateView addSubview:self.dateInDateView];
    //确认按钮
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH/2, 30)];
    [self.button setTitle:@"OK" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(OK:) forControlEvents:UIControlEventTouchUpInside];
    [self.dateView addSubview:self.button];
    
    //滑动手势
    self.swipeGestureRecognizeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
    [self.swipeGestureRecognizeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:self.swipeGestureRecognizeRight];
    
    self.swipeGestureRecognizeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    [self.swipeGestureRecognizeRight setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:self.swipeGestureRecognizeLeft];

    
}

#pragma mark - 代理方法

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.daysOfMonth+self.firstDayWeekday;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *c = [self.calendar dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/14, 20, 40, 40)];
    if((indexPath.row+1)>=self.firstDayWeekday&&(indexPath.row+1)<=(self.firstDayWeekday+self.daysOfMonth-1)) {
        c.label.text = [NSString stringWithFormat:@"%ld",indexPath.row+2-self.firstDayWeekday];
    }
    else {
        c.label.text = @"";
    }
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componets;
    componets = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    if(self.year == componets.year && self.month == componets.month && (indexPath.row+2-self.firstDayWeekday) == componets.day) {
        c.label.backgroundColor = [UIColor yellowColor];
    }
    return c;
    
    
    
}

#pragma mark - 日期计算函数
-(NSInteger)getWeekDayOfFirstDay {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componets;
    componets = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    componets.day = 1;
    NSDate *firstdayDate = [calendar dateFromComponents:componets];
    NSLog(@"%@",firstdayDate);
    NSLog(@"%ld",(long)[self getYearMonthDayWeekdayFromDate:firstdayDate].weekday);
    //return [componets weekday];
    return ([self getYearMonthDayWeekdayFromDate:firstdayDate].weekday);
    
}

- (NSDateComponents *)getYearMonthDayWeekdayFromDate:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *com = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    return com;
}

- (NSInteger)getMonthDaysFromDate {
    NSDate *date = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

#pragma mark - Cell点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSDate *date = [NSDate date];
    if(indexPath.row+1>=self.firstDayWeekday) {
        self.dateInDateView.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",self.year,self.month,(long)(indexPath.row+2-self.firstDayWeekday)];
        [self.view addSubview:self.dateView];
    }
}

#pragma mark - 按钮

-(void)OK:(id)sender {
    [self.dateView removeFromSuperview];
}


#pragma mark - 滑动手势方法

-(void)handleSwipeFromRight:(id)selector {
    NSLog(@"swipe from right");
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componets;
    componets = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    if(self.month == 12) {
        componets.year = self.year + 1;
        componets.month = 1;
        self.year = componets.year;
    }
    else {
        componets.year = self.year;
        componets.month = self.month + 1;
    }
    componets.day = 1;
    self.month = componets.month;
    self.dateHeadLabel.text = [NSString stringWithFormat:@"%ld年%ld月",componets.year,componets.month];
    NSDate *lastMonthDate = [calendar dateFromComponents:componets];
    self.firstDayWeekday = [self getYearMonthDayWeekdayFromDate:lastMonthDate].weekday;
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastMonthDate];
    self.daysOfMonth = range.length;
    //NSLog([NSString stringWithFormat:@"%ld",self.daysOfMonth]);
    [self.calendar reloadData];
}

-(void)handleSwipeFromLeft:(id)selector {
    NSLog(@"swipe from left");
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componets;
    componets = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    if(self.month == 1) {
        componets.year = self.year - 1;
        componets.month = 12;
        self.year = componets.year;
    }
    else {
        componets.year = self.year;
        componets.month = self.month - 1;
    }
    componets.day = 1;
    self.month = componets.month;
    self.dateHeadLabel.text = [NSString stringWithFormat:@"%ld年%ld月",componets.year,componets.month];
    NSDate *lastMonthDate = [calendar dateFromComponents:componets];
    self.firstDayWeekday = [self getYearMonthDayWeekdayFromDate:lastMonthDate].weekday;
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastMonthDate];
    self.daysOfMonth = range.length;
    [self.calendar reloadData];
}
@end
