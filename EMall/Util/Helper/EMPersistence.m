//
//  EMPersistence.m
//  EMall
//
//  Created by Luigi on 16/8/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMPersistence.h"
#import "EMUserModel.h"
#import "NSData+CommonCrypto.h"
static NSString *const  kUserPersistenceKey  =@"kUserPersistenceKey";
@implementation EMPersistence
+ (void)persistenceWithUserModel:(EMUserModel *)userModel{
    if (userModel&&[userModel isKindOfClass:[EMUserModel class]]) {
        RI.userID=userModel.userID;
        RI.userName=userModel.userName;
        RI.avatar=userModel.avatar;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData * aData=[NSKeyedArchiver archivedDataWithRootObject:userModel];
            if (aData) {
                NSError *aError;
                aData=[aData AES256EncryptedDataUsingKey:kUserPersistenceKey error:&aError];
                if (aError==nil&&aData) {
                    [[NSUserDefaults standardUserDefaults ] setObject:aData forKey:[kUserPersistenceKey md5String]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        });
    }
}
+ (void)userLogou{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[kUserPersistenceKey md5String]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    RI.userID=0;
    RI.userName=nil;
    RI.avatar=nil;
     [[NSNotificationCenter defaultCenter] postNotificationName:OCLogoutNofication object:nil];
}
+ (EMUserModel *)localUserModel{
    EMUserModel *userModel;
    NSData *aData=[[NSUserDefaults standardUserDefaults]  objectForKey:[kUserPersistenceKey md5String]];
    if (aData) {
        NSError *aError;
        aData=[aData decryptedAES256DataUsingKey:kUserPersistenceKey error:&aError];
        if (aData) {
             userModel=[NSKeyedUnarchiver unarchiveObjectWithData:aData];
        }
    }
    if (![userModel isKindOfClass:[EMUserModel class]]) {
        userModel=nil;
    }
    return userModel;
}
@end
