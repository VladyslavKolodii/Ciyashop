//
//  ProductCell.m
//  QuickClick
//
//  Created by APPLE on 24/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell
@synthesize days, hours, mins, index, delegate;

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

-(void)timerData
{
    mins--;
    if (mins == 0 && hours == 0 && days == 0)
    {
        //remove data of the table
    }
    else
    {
        if(mins == -1)
        {
            mins = 59;
            hours--;
            if (hours == -1)
            {
                hours = 23;
                days--;
                if (days == -1)
                {
                    days = 0; hours = 0; mins = 0;
                    
                    [appDelegate.arrDealOfTheDay removeObjectAtIndex:index];
                    if (delegate)
                    {
                        [delegate setDealOfTheDay];
                    }
                }
            }
        }
    }
    [[[appDelegate.arrDealOfTheDay objectAtIndex:index] valueForKey:@"deal_life"] setValue:[NSString stringWithFormat:@"%d", days] forKey:@"days"];
    [[[appDelegate.arrDealOfTheDay objectAtIndex:index] valueForKey:@"deal_life"] setValue:[NSString stringWithFormat:@"%d", hours] forKey:@"hours"];
    [[[appDelegate.arrDealOfTheDay objectAtIndex:index] valueForKey:@"deal_life"] setValue:[NSString stringWithFormat:@"%d", mins] forKey:@"minutes"];
    
    self.lblDays.text = [NSString stringWithFormat:@"%d",days];
    self.lblHours.text = [NSString stringWithFormat:@"%d",hours];
    self.lblMinutes.text = [NSString stringWithFormat:@"%d",mins];
    
    NSLog(@"Days :: %@, Hours :: %@, Minutes :: %@", [[[appDelegate.arrDealOfTheDay objectAtIndex:index] valueForKey:@"deal_life"] valueForKey:@"days"], [[[appDelegate.arrDealOfTheDay objectAtIndex:index] valueForKey:@"deal_life"] valueForKey:@"hours"], [[[appDelegate.arrDealOfTheDay objectAtIndex:index] valueForKey:@"deal_life"] valueForKey:@"minutes"]);
}

@end
