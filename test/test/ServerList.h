//
//  ServerList.h
//  test
//
//  Created by 兴业 on 16/5/24.
//  Copyright © 2016年 ckfear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerList : NSObject

/**
 *  primary 主键ID
 */
@property (nonatomic, assign) NSInteger ID;

/**
 *  IP
 */
@property (nonatomic, copy) NSString *serverIP;

/**
 *  服务器名
 */
@property (nonatomic, copy) NSString *serverName;

/**
 *  证书后缀
 */
@property (nonatomic, copy) NSString *cerSuffix;


@end
