//
//  SearchCell.h
//  QuickClick
//
//  Created by Kaushal PC on 05/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *vwTable;
@property (strong, nonatomic) IBOutlet UIView *vwImage;

@end
