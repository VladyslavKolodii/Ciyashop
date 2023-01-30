//
//  TimerHelper.h
//  CiyaShop
//
//  Created by Kaushal PC on 12/10/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimerHelper <NSObject>
-(void)TimerHelper:(NSString*)time;
@end

@interface TimerHelper : NSObject

#pragma mark - create instance of file

+ (instancetype)sharedInstance;

@property(strong,nonatomic) id<TimerHelper> delegate;
@property int mins, hours, seconds;
@property NSTimer *timer;

-(void)startTimer;

@end
