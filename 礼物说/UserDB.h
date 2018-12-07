//
//  UserDB.h
//  网络_06
//
//  Created by 曾令轩 on 15/11/24.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "DBManager2.h"

@interface UserDB : DBManager2
- (void)createTable;
- (void)addUserWithParams:(NSArray *)params;
- (void)deleteUsers:(NSArray *)users;
- (NSArray *)selectUser:(NSArray *)users;
@end
