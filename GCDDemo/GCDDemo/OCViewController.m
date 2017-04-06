//
//  OCViewController.m
//  GCDDemo
//
//  Created by 王昱斌 on 17/3/28.
//  Copyright © 2017年 Qtin. All rights reserved.
//

#import "OCViewController.h"


@interface Sark : NSObject
@property (nonatomic, copy) NSString *name;
- (void)speak;
@end
@implementation Sark
- (void)speak {
    NSLog(@"my name's %@", self.name);
}
@end

@interface OCViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
//    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
//    BOOL res3 = [(id)[Sark class] isKindOfClass:[Sark class]];
//    BOOL res4 = [(id)[Sark class] isMemberOfClass:[Sark class]];
//    
//    NSLog(@"%d %d %d %d", res1, res2, res3, res4);
//    NSLog(@"ViewController = %@ , 地址 = %p", self, &self);
//    
//    id cls = [Sark class];
//    NSLog(@"Sark class = %@ 地址 = %p", cls, &cls);
//    
//    void *obj = &cls;
//    NSLog(@"Void *obj = %@ 地址 = %p", obj,&obj);
//    
//    [(__bridge id)obj speak];
//    
//    Sark *sark = [[Sark alloc]init];
//    NSLog(@"Sark instance = %@ 地址 = %p",sark,&sark);
//    
//    [sark speak];
    
    
    
    NSLog(@"ViewController = %@ , 地址 = %p", self, &self);
    
//    NSString *myName = @"halfrost";
    
    
    id cls = [Sark class];
    NSLog(@"Sark class = %@ 地址 = %p", cls, &cls);
    
    void *obj = &cls;
    NSLog(@"Void *obj = %@ 地址 = %p", obj,&obj);
    
    [(__bridge id)obj speak];
    
    Sark *sark = [[Sark alloc]init];
    NSLog(@"Sark instance = %@ 地址 = %p",sark,&sark);
    
    [sark speak];
    
//    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
//
//    dispatch_async(queue, ^{
//        [self syncMain];
//    });
    
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
- (IBAction)barrier:(id)sender {
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"111-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"222-----%@", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"----barrier-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"333-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"444-----%@", [NSThread currentThread]);
    });
}
- (IBAction)after:(id)sender {
    [_button setTitle:@"延时" forState:(UIControlStateNormal)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_button setTitle:@"线程间通信" forState:(UIControlStateNormal)];
    });
}

- (IBAction)group:(id)sender {
    dispatch_group_t group =  dispatch_group_create();
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_group_async(group, queue1, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"111-----%d-----%@",i,[NSThread currentThread]);
        }
    });
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_group_notify(group, queue2, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"222-----%d-----%@",i,[NSThread currentThread]);
        }
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
