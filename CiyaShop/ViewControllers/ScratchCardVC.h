//
//  ScratchCardVC.h
//  CiyaShop
//
//  Created by Kaushal PC on 03/04/18.
//  Copyright © 2018 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScratchViewDelegate
@required
- (void)scratchView;
@end

@interface ScratchCardVC : UIViewController

@property NSString *strCouponCode, *strCouponDesc;

@property (nonatomic, assign) id<ScratchViewDelegate> delegate;


@end
