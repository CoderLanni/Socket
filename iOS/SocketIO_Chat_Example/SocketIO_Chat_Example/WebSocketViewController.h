//
//  WebSocketViewController.h
//  SocketIO_Chat_Example
//
//  Created by yiniansiji on 2020/2/10.
//  Copyright © 2020 逸年四季. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    disConnectByUser ,
    disConnectByServer,
} DisConnectType;

@interface WebSocketViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
