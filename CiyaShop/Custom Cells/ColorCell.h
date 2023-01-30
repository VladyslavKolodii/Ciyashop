//
//  ColorCell.h
//  QuickClick
//
//  Created by Kaushal PC on 22/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgBG;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *act;

@end
