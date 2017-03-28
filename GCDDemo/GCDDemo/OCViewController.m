//
//  OCViewController.m
//  GCDDemo
//
//  Created by 王昱斌 on 17/3/28.
//  Copyright © 2017年 Qtin. All rights reserved.
//

#import "OCViewController.h"

@interface OCViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [self syncMain];
    });
    
}


-(void)createQueue{
    //参数1：队列的唯一标识符，用于DEBUG，可为空
    //参数2：用来识别是串行队列还是并发队列
    // 并发队列
    dispatch_queue_t queue0 = dispatch_queue_create("queue0", DISPATCH_QUEUE_CONCURRENT);
    // 串行队列
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
}

-(void)createGlobalQueue{
    dispatch_queue_t queue0 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)syncConcurrent:(id)sender {
    [self syncConcurrent];
}
- (IBAction)asyncConcurrent:(id)sender {
    [self asyncConcurrent];
}
- (IBAction)syncSerial:(id)sender {
    [self syncSerial];
}
- (IBAction)asyncSerial:(id)sender {
    [self asyncSerial];
}
- (IBAction)syncMain:(id)sender {
    [self syncMain];
}
- (IBAction)asyncMain:(id)sender {
    [self asyncMain];
}
- (IBAction)connection:(id)sender {
    [_button setTitle:@"-----" forState:(UIControlStateNormal)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"connection%d------%@",i,[NSThread currentThread]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_button setTitle:@"线程间通信" forState:(UIControlStateNormal)];
        });
    });
}




#pragma mark - 并行队列+同步执行
- (void) syncConcurrent{
    
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"111------%@" , [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"222------%@" , [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"333------%@" , [NSThread currentThread]);
        }
    });
    
    NSLog(@"syncConcurrent---end");
    
}
#pragma mark - 并行队列+异步执行
- (void) asyncConcurrent{
    
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"111------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"222------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"333------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncConcurrent---end");
}
#pragma mark - 串行队列+同步执行
- (void) syncSerial{
    
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"111------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"222------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"333------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncSerial---end");
}
#pragma mark - 串行队列+异步执行
- (void) asyncSerial{
    
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncSerial---end");
    
}
#pragma mark - 主队列+同步执行
- (void)syncMain{
    
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncMain---end");
    
}
#pragma mark - 主队列+异步执行
- (void)asyncMain{
    
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"111------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"222------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"333------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncMain---end");
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
