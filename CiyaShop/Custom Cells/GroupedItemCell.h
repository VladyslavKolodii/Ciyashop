//
//  GroupedItemCell.h
//  QuickClick
//
//  Created by Kaushal PC on 11/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupedItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblViewDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider;

@property (strong, nonatomic) IBOutlet UIView *vwImage;

@end
