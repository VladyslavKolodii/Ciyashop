//
//  OrderDetailVC.h
//  QuickClick
//
//  Created by Kaushal PC on 02/08/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OrderDetailDelegate <NSObject>

-(void)updateOrderDetail;

@end

@interface OrderDetailVC : UIViewController

@property (strong, nonatomic) NSMutableDictionary *dictMyOrderData;
@property (strong, nonatomic) id<OrderDetailDelegate> delegate;

@end
