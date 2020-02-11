//
//  SocketRocketUtility.h
//  SocketIO_Chat_Example
//
//  Created by yiniansiji on 2020/2/10.
//  Copyright © 2020 逸年四季. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>

extern NSString * _Nonnull const kNeedPayOrderNote;
extern NSString * _Nonnull const kWebSocketDidOpenNote;
extern NSString * _Nonnull const kWebSocketDidCloseNote;
extern NSString * _Nonnull const kWebSocketdidReceiveMessageNote;


NS_ASSUME_NONNULL_BEGIN

@interface SocketRocketUtility : NSObject


/** 获取连接状态 */
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;

/** 开始连接 */
- (void)SRWebSocketOpenWithURLString:(NSString *)urlString;

/** 关闭连接 */
- (void)SRWebSocketClose;

/** 发送数据 */
- (void)sendData:(id)data;

+ (SocketRocketUtility *)instance;


@end

NS_ASSUME_NONNULL_END
