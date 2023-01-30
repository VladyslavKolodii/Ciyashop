//
//  SallerReviewCell.h
//  CiyaShop
//
//  Created by Kaushal PC on 14/11/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SallerReviewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *vwRating;

@property (strong, nonatomic) IBOutlet UILabel *lblRate;
@property (strong, nonatomic) IBOutlet UILabel *lblReview;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblBorder;

@property (strong, nonatomic) IBOutlet UIButton *btnMore;

@property (strong, nonatomic) IBOutlet UIImageView *Devider;

@property (strong, nonatomic) IBOutlet UIView *vw;

@end
