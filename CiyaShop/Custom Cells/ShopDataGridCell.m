//
//  ShopDataGridCell.m
//  QuickClick
//
//  Created by Kaushal PC on 24/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "ShopDataGridCell.h"

@implementation ShopDataGridCell 
@synthesize hours, mins, seconds, timer;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // Initialization code
    if (appDelegate.fromItemDetail)
    {
        self.btnAddToCart.hidden = true;
        
        self.imgProduct.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - (95*SCREEN_SIZE.width/375));
        self.lblTitle.frame = CGRectMake(self.lblTitle.frame.origin.x, self.imgProduct.frame.origin.y + self.imgProduct.frame.size.height, self.lblTitle.frame.size.width, self.lblTitle.frame.size.height);
        self.lblRate.frame = CGRectMake(self.lblRate.frame.origin.x, self.frame.size.height - self.lblRate.frame.size.height - 5, self.lblRate.frame.size.width, self.lblRate.frame.size.height);
    }
    else if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode)
    {
        self.btnAddToCart.hidden = false;

        self.imgProduct.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - (110*SCREEN_SIZE.width/375));
        self.lblTitle.frame = CGRectMake(self.lblTitle.frame.origin.x, self.imgProduct.frame.origin.y + self.imgProduct.frame.size.height, self.lblTitle.frame.size.width, self.lblTitle.frame.size.height);
        self.lblRate.frame = CGRectMake(self.lblRate.frame.origin.x, self.btnAddToCart.frame.origin.y - (3*SCREEN_SIZE.width/375) - self.lblRate.frame.size.height, self.lblRate.frame.size.width, self.lblRate.frame.size.height);
        
        [Util setSecondaryColorButton:self.btnAddToCart];
    }
    else
    {
        self.btnAddToCart.hidden = true;
        
        self.imgProduct.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - (95*SCREEN_SIZE.width/375));
        self.lblTitle.frame = CGRectMake(self.lblTitle.frame.origin.x, self.imgProduct.frame.origin.y + self.imgProduct.frame.size.height, self.lblTitle.frame.size.width, self.lblTitle.frame.size.height);
        self.lblRate.frame = CGRectMake(self.lblRate.frame.origin.x, self.frame.size.height - self.lblRate.frame.size.height - (3*SCREEN_SIZE.width/375), self.lblRate.frame.size.width, self.lblRate.frame.size.height);
    }
    float y = self.lblTitle.frame.origin.y + ((self.lblRate.frame.origin.y - self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height)/2) - 8;
    self.vwRating.frame = CGRectMake(self.vwRating.frame.origin.x, y, self.vwRating.frame.size.width, self.vwRating.frame.size.height);
}

#pragma mark: - Timer

-(void)startTimer:(NSString*)dateString;
{
    if (![dateString isEqualToString:@""])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        NSDate *dateNew = [dateFormatter dateFromString:dateString];
        NSDate *dateNow = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components: (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate: dateNow toDate: dateNew options: 0];
        
        //        components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:dateNew];
        
        seconds = (int)[components second];
        mins = (int)[components minute];
        hours = (int)[components hour];
        
        if ([self.timer isValid])
        {
            [self.timer invalidate];
        }
        self.timer = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerData) userInfo:nil repeats:YES];
    }
}

-(void)timerData
{
    seconds--;
    if (mins == 0 && hours == 0 && seconds == 0)
    {
        //remove data of the table
    }
    else
    {
        if (seconds == -1)
        {
            seconds = 59;
            mins--;
            if(mins == -1)
            {
                mins = 59;
                hours--;
                if (hours == -1)
                {
                    hours = 0;
                }
            }
        }
    }
    NSString *hh = [NSString stringWithFormat:@"%.2d", hours];
    NSString *mm = [NSString stringWithFormat:@"%.2d", mins];
    NSString *ss = [NSString stringWithFormat:@"%.2d", seconds];

    if (appDelegate.isRTL) {
        hh = [self setTextAsNumber:hh];
        mm = [self setTextAsNumber:mm];
        ss = [self setTextAsNumber:ss];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@ %@ : %@ : %@", [MCLocalization stringForKey:@"Sale ends in"], hh, mm, ss];
    
    self.lblTimer.text = str;
//    if (self.delegate)
//    {
//        [self.delegate TimerHelper:str];
//    }
}

- (NSString*)setTextAsNumber:(NSString*)hh {
    NSDictionary *numbersDictionary = @{@"1" : @"۱", @"2" : @"۲", @"3" : @"۳", @"4" : @"۴", @"5" : @"۵", @"6" : @"۶", @"7" : @"۷", @"8" : @"۸", @"9" : @"۹"};
    for (NSString *key in numbersDictionary) {
        hh = [hh stringByReplacingOccurrencesOfString:key withString:numbersDictionary[key]];
    }
    return hh;
}
@end
