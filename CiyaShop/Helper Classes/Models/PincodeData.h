//
//  PincodeData.h
//  CiyaShop
//
//  Created by Kaushal Parmar on 24/06/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PincodeData : NSObject

@property (strong,nonatomic) NSString *availableat_text;
@property (strong,nonatomic) NSString *cod_available_msg;
@property (strong,nonatomic) NSString *cod_data_label;
@property (strong,nonatomic) NSString *cod_help_text;
@property (strong,nonatomic) NSString *cod_not_available_msg;
@property (strong,nonatomic) NSString *del_data_label;
@property (strong,nonatomic) NSString *del_help_text;

@property BOOL del_saturday;
@property BOOL del_sunday;

@property (strong,nonatomic) NSString *error_msg_blank;
@property (strong,nonatomic) NSString *error_msg_check_pincode;
@property (strong,nonatomic) NSString *pincode_placeholder_txt;

@property BOOL show_city_on_product;
@property BOOL show_cod_on_product;
@property BOOL show_estimate_on_product;
@property BOOL show_product_page;
@property BOOL show_state_on_product;

@end

NS_ASSUME_NONNULL_END
