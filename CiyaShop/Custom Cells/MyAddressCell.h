//
//  MyAddressCell.h
//  QuickClick
//
//  Created by Kaushal PC on 02/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAddressCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblAddressTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNumberTitle;

@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblAddAddress;

@property (strong, nonatomic) IBOutlet UIButton *btnRemove;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnAddAddress;

@property (strong, nonatomic) IBOutlet UIImageView *imgDevider;
@property (strong, nonatomic) IBOutlet UIView *vwNoAddress;

@end
