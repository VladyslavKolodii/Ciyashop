//
//  DealOfTheDayCell.h
//  QuickClick
//
//  Created by APPLE on 24/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCell.h"

@protocol RedirectToDealOfTheDayDelegate <NSObject>

-(void)RedirectToDealOfTheDay:(Product*)dict;

@end

@interface DealOfTheDayCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, TimerHelper>

@property(strong,nonatomic) IBOutlet UICollectionView *colProducts;
@property(strong,nonatomic) IBOutlet UIButton *btnViewAll;

@property(strong,nonatomic) IBOutlet UILabel *lblTitle;
@property(strong,nonatomic) IBOutlet UILabel *lblTimer;

@property(strong,nonatomic) IBOutlet UIView *vwHead;
@property(strong,nonatomic) IBOutlet UIView *vwTimer;
@property(strong,nonatomic) IBOutlet UIImageView *imgTimer;

@property(strong,nonatomic) id<RedirectToDealOfTheDayDelegate> delegate;

//@property(strong,nonatomic) NSMutableArray *arrDealOfTheDay;

@property int mins, hours, seconds, set;

@end
