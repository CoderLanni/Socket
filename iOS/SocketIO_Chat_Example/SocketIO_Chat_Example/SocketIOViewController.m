//
//  SocketIOViewController.m
//  SocketIO_Chat_Example
//
//  Created by yiniansiji on 2020/2/10.
//  Copyright © 2020 逸年四季. All rights reserved.
//

#import "SocketIOViewController.h"

@import SocketIO;

@interface SocketIOViewController ()


@property (strong, nonatomic) SocketManager* manager;
@property (strong, nonatomic) SocketIOClient *socket;
@property (weak, nonatomic) IBOutlet UITextField *inputmsgTF;
@property(nonatomic ,strong) NSMutableArray *messageArray;


@end

@implementation SocketIOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
        self.messageArray = [[NSMutableArray alloc]init];
    
    
     [self connection];
    
}

- (void)connection{
 NSURL *url = [NSURL URLWithString:@"http://192.168.5.30:3000"];
 //必须注意SocketManager使用属性实例 不然会被释放会接受不到服务器消息
 self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];
 self.socket = [self.manager defaultSocket];
     //监听是否连接上服务器，正确连接走后面的回调
     [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
         NSLog(@"*************\n\niOS客户端上线\n\n*************");
         [self.socket emit:@"login" with:@[@"30342"]];
     }];
    [self.socket on:@"chat message" callback:^(NSArray * _Nonnull event, SocketAckEmitter * _Nonnull ack) {
       if (event[0][@"message"] && ![event[0][@"message"] isEqualToString:@""]) {
           NSLog(@"*************\n\n消息: %@",event?event[0][@"message"]:@"");
       }
     }];
     [self.socket on:@"privateMessage" callback:^(NSArray * _Nonnull event, SocketAckEmitter * _Nonnull ack) {
       if (event[0][@"message"] && ![event[0][@"message"] isEqualToString:@""]) {
           NSLog(@"*************\n\n消息: %@",event?event[0][@"message"]:@"");
           
       }
     }];
     [self.socket on:@"disconnect" callback:^(NSArray * _Nonnull event, SocketAckEmitter * _Nonnull ack) {
       NSLog(@"*************\n\niOS客户端下线\n\n*************%@",event?event[0]:@"");
     }];
     [self.socket on:@"error" callback:^(NSArray * _Nonnull event, SocketAckEmitter * _Nonnull ack) {
       NSLog(@"*************\niOS客户端报错\\n%@\n\n*************",event?event[0]:@"");
     }];
     [self.socket connect];

}
- (IBAction)sendbtn:(UIButton *)sender {
     if (self.inputmsgTF.text.length>0) {
    
        [self.socket emit:@"chat message" with:@[@{@"toUser":@"30621",@"message":self.inputmsgTF.text}]];
//        [self.messageArray insertObject:self.inputmsgTF.text atIndex:0];
        self.inputmsgTF.text = @"";
      }
}

-(void)dealloc{
     NSLog(@" IO页面注销");
    [self.socket disconnect];
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@" IO页面消失");
       [self.socket disconnect];
}
@end
