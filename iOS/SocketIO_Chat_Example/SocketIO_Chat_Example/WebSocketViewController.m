//
//  WebSocketViewController.m
//  SocketIO_Chat_Example
//
//  Created by yiniansiji on 2020/2/10.
//  Copyright © 2020 逸年四季. All rights reserved.
//

#import "WebSocketViewController.h"
#import "SocketRocketUtility.h"
@interface WebSocketViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputTF;


@end

@implementation WebSocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
        [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:@"ws://123.207.136.134:9010/ajaxchattest"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketDidCloseNote object:nil];
    
    
        //    [[SocketRocketUtility instance] SRWebSocketClose]; 在需要得地方 关闭socket
        
     
}


- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    //在成功后需要做的操作。。。

}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSString * message = note.object;
    NSLog(@"收到服务端发送过来的消息:  %@",message);
}
- (IBAction)sendBtn:(UIButton *)sender {
    
    
    [[SocketRocketUtility instance] sendData:self.inputTF.text];
    
}

@end
