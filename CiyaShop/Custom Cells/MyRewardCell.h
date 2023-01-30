//
//  MyRewardCell.h
//  QuickClick
//
//  Created by Kaushal PC on 05/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRewardCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgCoupon;
@property (strong, nonatomic) IBOutlet UIImageView *imgScratchCoupon;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblCouponCode;
@property (strong, nonatomic) IBOutlet UILabel *lblScratchText;

@end
