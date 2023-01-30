//
//  LocationHelper.m
//  CupidLove
//
//  Created by APPLE on 20/01/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "LocationHelper.h"

@implementation LocationHelper 
{
    NSString *location;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation *oldLocation;
}

+ (instancetype)sharedInstance
{
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
   
    return sharedInstance;
}
#pragma mark --------- CLLocationManager delegate methods---------

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    
    CLLocation *newLocation = [locations lastObject];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            
            self->placemark = [placemarks lastObject];
            NSString *lati = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
            NSString *longi= [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
            
//            NSString *myState = placemark.administrativeArea;
//            NSString *myCountry = placemark.country;
            
           // [newLocation distanceFromLocation:oldLocation
            
            
//            NSLog(@"%f",[[placemarks lastObject] distanceFromLocation:[placemarks lastObject]]);
//            NSLog(@"Location number: - %ld, %f",(long)count, [newLocation distanceFromLocation:oldLocation]);
            if(self->oldLocation==nil ){
                self.latitude=lati;
                self.longitude=longi;
                self->oldLocation = newLocation;

                [self changeLocation];

            } else if( [newLocation distanceFromLocation:self->oldLocation] > [DistanceForLocationUpdate integerValue]) {
                self->oldLocation = newLocation;
                self.latitude=lati;
                self.longitude=longi;
                //calling api here
                [self changeLocation];

                NSLog(@"Location changed");
            }
        } else {
            NSLog(@"Error::%@", error.debugDescription);
        }
    }];
    // Turn off the location manager to save power.
//    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
    self.latitude=0;
    self.longitude=0;
}

#pragma mark --method---

- (void) updateLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        //Location Services Enabled
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
           // ALERTVIEW([MCLocalization stringForKey:@"Please go to Settings and turn on Location Service for this app."], appDelegate.window.rootViewController);
            NSLog(@"Please go to Settings and turn on Location Service for this app.");
        }
        
        //enable location
        geocoder = [[CLGeocoder alloc] init];
        if (locationManager == nil)
        {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.delegate = self;
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }
    else{
       // ALERTVIEW([MCLocalization stringForKey:@"Please enable Location Service for this app."], appDelegate.window.rootViewController);
        NSLog(@"Please enable Location Service for this app.");

    }
    

}
- (void) stopUpdateLocation
{
   [locationManager stopUpdatingLocation];

}
#pragma mark - api call
-(void) changeLocation{
        
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"21.1832914" forKey:@"lat"];
    [dict setValue:@"72.8296566" forKey:@"lng"];
    [dict setValue:appDelegate.strDeviceToken forKey:@"device_token"];
    [dict setValue:@"1" forKey:@"device_type"];
    NSLog(@"%@",dict);
    
    [CiyaShopAPISecurity findGeoLocation:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
//        HIDE_PROGRESS;

        NSLog(@"%@",dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                
            }
            else if ([[dictionary valueForKey:@"status"] isEqualToString:@"error"])
            {
                
            }
            else
            {
                
            }
        }
        else
        {
            
        }
    }];
    
}


@end
