//
//  AddNewAddressVC.h
//  QuickClick
//
//  Created by Kaushal PC on 02/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewAddressVC : UIViewController

@property int from; //if 0 then billing else 1 then from shipping
@property (strong, nonatomic) NSMutableDictionary *dictCustomerDetail;

@end
