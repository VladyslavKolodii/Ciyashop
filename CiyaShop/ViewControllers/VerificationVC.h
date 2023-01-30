//
//  VerificationVC.h
//  CiyaShop
//
//  Created by Kaushal Parmar on 03/06/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VerificationOTPDelegate <NSObject>

-(void)successInVerification;

@end

@interface VerificationVC : UIViewController

@property NSString *strUserId;
@property NSString *strPhoneNumber;
@property NSString *strVerificationToken;

@property (strong, nonatomic) id <VerificationOTPDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
