//
//  ProductCell.h
//  QuickClick
//
//  Created by APPLE on 24/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DealOfTheDayDelegate <NSObject>

-(void)setDealOfTheDay;

@end

@interface ProductCell : UICollectionViewCell

@property (strong,nonatomic) IBOutlet UIImageView *img;

@property (strong,nonatomic) IBOutlet UILabel *lblPrice;
@property (strong,nonatomic) IBOutlet UILabel *lblProductName;

@property (strong,nonatomic) IBOutlet UILabel *lblDays;
@property (strong,nonatomic) IBOutlet UILabel *lblHours;
@property (strong,nonatomic) IBOutlet UILabel *lblMinutes;

@property (strong,nonatomic) IBOutlet UILabel *lblSalePersent;

@property (strong,nonatomic) IBOutlet UIView *vwHours;
@property (strong,nonatomic) IBOutlet UIView *vwMinutes;
@property (strong,nonatomic) IBOutlet UIView *vwDays;

@property (strong,nonatomic) IBOutlet UIView *vwImages;

@property (strong,nonatomic) IBOutlet UIActivityIndicatorView *act;

@property (strong,nonatomic) NSTimer *timer;

@property (strong,nonatomic) id<DealOfTheDayDelegate> delegate;

-(void)timerData;

@property int mins, hours, days, index;

@end
