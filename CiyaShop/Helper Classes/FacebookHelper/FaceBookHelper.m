//
//  FaceBookHelper.m
//  CupidLove
//
//  Created by potenza on 16/03/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "FaceBookHelper.h"

@implementation FaceBookHelper


+(FaceBookHelper *)shareInstance
{
    static FaceBookHelper * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FaceBookHelper alloc] init];
    });
    return instance;
}


-(FaceBookHelper *)init
{

    
    //TODO: - Permission List need to update as per requirements
    self.arrPermissions=[[NSMutableArray alloc]initWithObjects:@"public_profile", @"email", nil];
    
    //TODO: - Add Below in info.plist with replacing your Facebook AppID
    
//    <key>FacebookAppID</key>
//    <string>1839921342953266</string>
//    <key>FacebookDisplayName</key>
//    <string>CupidLove</string>
//    <key>LSApplicationQueriesSchemes</key>
//    <array>
//    <string>fbapi</string>
//    <string>fb-messenger-api</string>
//    <string>fbauth2</string>
//    <string>fbshareextension</string>
//    </array>
    
    
//    <key>CFBundleURLTypes</key>
//    <array>
//    <dict>
//    <key>CFBundleURLSchemes</key>
//    <array>
//				<string>fb1839921342953266</string>
//    </array>
//    </dict>
//    </array>

    
    
    self.dictFbDetails=[[NSMutableDictionary alloc]init];
    return self;
}

-(void)LoginWithFaceBook
{
   // SHOW_PROGRESS(@"Please Wait..");
//    SHOW_LOADER_ANIMTION();

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login setLoginBehavior:FBSDKLoginBehaviorWeb];

    [login logInWithPermissions:self.arrPermissions fromViewController:appDelegate.window.rootViewController handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            HIDE_PROGRESS;
            NSLog(@"Process error");
//            ALERTVIEW(@"Something Went wrong.", appDelegate.window.rootViewController);
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"1" forKey:@"error"];
            if(self->_FacebookLogin)
            {
                self->_FacebookLogin(dict);
            }

        } else if (result.isCancelled) {
            NSLog(@"Cancelled");
            HIDE_PROGRESS;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"2" forKey:@"error"];
            if(self->_FacebookLogin)
            {
                self->_FacebookLogin(dict);
            }

        } else {
            NSLog(@"Logged in");
            NSLog(@"User Logged in.....");
            NSLog(@"result%@",result);
            NSLog(@"access token%@",[FBSDKAccessToken currentAccessToken]);

//            [self GetDetialsFromFacebook:^(NSMutableDictionary *result) {
//                self.dictFbDetails=result;
//                if(_FacebookLogin)
//                {
//                    _FacebookLogin(self.dictFbDetails);
//                }
//            }];
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.type(large), email, id,first_name, last_name"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
               //  HIDE_PROGRESS;
                 
                 if (!error)
                 {
                     NSLog(@"fetched user:%@", result);
                     self.dictFbDetails=result;
                     if(self->_FacebookLogin)
                     {
                         self->_FacebookLogin(self.dictFbDetails);
                     }
                 }
                 else
                 {
                     ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], appDelegate.window.rootViewController);
                 }
             }];
        }
    }];
}

-(void)GetDetialsFromFacebook:(FaceBookLoginBlock)FacebookLogin
{
  //  SHOW_PROGRESS(@"Please Wait..");
//    SHOW_LOADER_ANIMTION();

    _FacebookLogin=FacebookLogin;
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picturepicture.type(large), email, id,first_name, last_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 self.dictFbDetails=result;
                 if(self->_FacebookLogin)
                 {
                     self->_FacebookLogin(self.dictFbDetails);
                 }
             }
         }];
    }
    else
    {
        [self LoginWithFaceBook];
    }
}


-(void)ClearToken
{
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
}

@end
