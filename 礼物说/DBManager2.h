//
//  DBManager2.h
//  网络_06
//
//  Created by 曾令轩 on 15/11/24.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager2 : NSObject
- (BOOL)createTable:(NSString *)sql;
- (BOOL)dealWithData:(NSString *)sql params:(NSArray *)params;
- (NSArray *)selectFrom:(NSString *)sql;
@end
