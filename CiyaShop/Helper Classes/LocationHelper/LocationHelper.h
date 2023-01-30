//
//  LocationHelper.h
//  CupidLove
//
//  Created by APPLE on 20/01/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

//// Protocol definition starts here
//@protocol LocationUpdateDelegate <NSObject>
//@required
//- (void) LocationUpdated;
//@end
// Protocol Definition ends here

@interface LocationHelper : NSObject <CLLocationManagerDelegate>
//{
//    // Delegate to respond back
//    id <LocationUpdateDelegate> _delegate;
//}
//@property (nonatomic,strong) id delegate;

@property(nonatomic) NSString *latitude;
@property(nonatomic) NSString *longitude;

+ (instancetype)sharedInstance;
- (void) updateLocation; //instance method
- (void) stopUpdateLocation;
@end
