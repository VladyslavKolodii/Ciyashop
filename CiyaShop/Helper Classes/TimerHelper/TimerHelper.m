//
//  TimerHelper.m
//  CiyaShop
//
//  Created by Kaushal PC on 12/10/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "TimerHelper.h"

@implementation TimerHelper
@synthesize hours, mins, seconds;

#pragma mark create instance of file

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)startTimer
{
    if (appDelegate.arrDealOfTheDay.count > 0)
    {
        seconds = [[[[appDelegate.arrDealOfTheDay objectAtIndex:0] valueForKey:@"deal_life"] valueForKey:@"seconds"] intValue];
        mins = [[[[appDelegate.arrDealOfTheDay objectAtIndex:0] valueForKey:@"deal_life"] valueForKey:@"minutes"] intValue];
        hours = [[[[appDelegate.arrDealOfTheDay objectAtIndex:0] valueForKey:@"deal_life"] valueForKey:@"hours"] intValue];
        
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
    NSString *str = [NSString stringWithFormat:@"%.2d : %.2d : %.2d", hours, mins, seconds];
    
    if (self.delegate)
    {
        [self.delegate TimerHelper:str];
    }
}

@end
