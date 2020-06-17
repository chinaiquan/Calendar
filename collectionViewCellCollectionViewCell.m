//
//  collectionViewCellCollectionViewCell.m
//  Calendar
//
//  Created by chi on 2020/6/17.
//  Copyright © 2020 chi-ios. All rights reserved.
//

#import "collectionViewCellCollectionViewCell.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    if([super initWithFrame:frame]) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-7)/7, (SCREEN_WIDTH-7)/7)];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.label.backgroundColor = [UIColor whiteColor];
}

@end
