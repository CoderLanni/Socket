//
//  ViewController.m
//  SocketIO_Chat_Example
//
//  Created by yiniansiji on 2020/2/10.
//  Copyright © 2020 逸年四季. All rights reserved.
//

#import "ViewController.h"

#import "SocketIOViewController.h"
#import "WebSocketViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    


}


- (IBAction)socketIOBtn:(UIButton *)sender {
    
    SocketIOViewController *io = [[SocketIOViewController alloc]init];
    [self.navigationController pushViewController:io animated:YES];
}

- (IBAction)webSocketBtn:(UIButton *)sender {
    
    WebSocketViewController *web = [[WebSocketViewController alloc]init];
       [self.navigationController pushViewController:web animated:YES];
    
}

@end
