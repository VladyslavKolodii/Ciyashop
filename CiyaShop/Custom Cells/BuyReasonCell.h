//
//  BuyReasonCell.h
//  CiyaShop
//
//  Created by Kaushal PC on 04/10/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyReasonCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;

@property (strong, nonatomic) IBOutlet UILabel *lblRight;
@property (strong, nonatomic) IBOutlet UILabel *lblBottom;

@property (strong, nonatomic) IBOutlet UIView *vwImage;

@end
