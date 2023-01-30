//
//  MyOrderCell.h
//  QuickClick
//
//  Created by Kaushal PC on 02/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderDate;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderedItem;
@property (strong, nonatomic) IBOutlet UILabel *lblDeliveryStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblDeliveredDate;

@property (strong, nonatomic) IBOutlet UILabel *lblDesc;

@property (strong, nonatomic) IBOutlet UIView *vwImage;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (strong, nonatomic) IBOutlet UIButton *btnViewAll;



@end
