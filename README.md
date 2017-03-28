# GCD_Demo
##1. GCD简介
>什么是GCD呢？我们先来看看百度百科的解释简单了解下概念
引自[百度百科](http://baike.baidu.com/item/GCD)Grand Central Dispatch
 (GCD) 是Apple开发的一个多核编程的较新的解决方法。它主要用于优化应用程序以支持多核处理器以及其他对称多处理系统。它是一个在线程池模式的基础上执行的并行任务。在Mac OS X 10.6雪豹中首次推出，也可在IOS 4及以上版本使用。

**为什么要用GCD呢？**
因为GCD有很多好处啊，具体如下：
* GCD可用于多核的并行运算
* GCD会自动利用更多的CPU内核（比如双核、四核）
* GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
* 程序员只需要告诉GCD想要执行什么任务，不需要编写任何线程管理代码

##2. 任务和队列

**任务**：就是执行操作的意思，换句话说就是你在线程中执行的那段代码。在GCD中是放在block中的。执行任务有两种方式：同步执行和异步执行。两者的主要区别是：是否具备开启新线程的能力。

* 同步执行(sync)：只能在当前线程中执行任务，不具备开启新线程的能力
* 异步执行(async)：可以在新的线程中执行任务，具备开启新线程的能力

**队列**：这里的队列指任务队列，即用来存放任务的队列。队列是一种特殊的线性表，采用FIFO（先进先出）的原则，即新任务总是被插入到队列的末尾，而读取任务的时候总是从队列的头部开始读取。每读取一个任务，则从队列中释放一个任务。在GCD中有两种队列：**串行队列**和**并发队列**。

* 并发队列（Concurrent Dispatch Queue）：可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）
并发功能只有在异步（dispatch_async）函数下才有效
* 串行队列（Serial Dispatch Queue）：让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）

##3. GCD的使用
##### 创建队列
######串行并行队列
`Swift`

```
// label:队列标签
// qos:设置队列的优先级
// attributes:队列形式：默认串行，设置为.concurrent代表是并行队列
let queue = DispatchQueue(label: "queue", qos: .default, attributes: .concurrent)
//创建一个默认串行队列
let queue = DispatchQueue(label: "queue")
//创建一个有优先级的串行队列
let queue = DispatchQueue(label: "queue", qos: .background)
```

`OC`

```
//参数1：队列的唯一标识符，用于DEBUG，可为空
//参数2：用来识别是串行队列还是并发队列
// 并发队列
dispatch_queue_t queue= dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
// 串行队列
dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
```
######全局队列
`Swift`

```
// 系统的全局队列
let queue = DispatchQueue.global()
let queue = DispatchQueue.global(qos: .default)
```

`OC`

```
//参数1：用来声明优先级
//参数2：预留供将来使用，传递除零以外的任何值可能会导致空返回值，必须为0
dispatch_queue_t queue0 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
```
#####执行任务
我们先看一下这个表格，我们将按照这个表格顺序撰写一下示例代码

 ||并发队列|串行队列|主队列|
 |-|-|-|-|
 |同步(sync)|没有开启新线程，串行执行任务|没有开启新线程，串行执行任务|没有开启新线程，串行执行任务
 |异步(async)|有开启新线程，并发执行任务|有开启新线程(1条)，串行执行任务|没有开启新线程，串行执行任务

######并行队列+同步执行

`Swift`

```
func syncConcurrent() -> Void {
        
        print("syncConcurrent---begin")
        
        let queue = DispatchQueue(label: "queue", attributes: .concurrent)
        
        queue.sync {
            for i in 1...3 {
                print("111-----\(i)--\(Thread.current)")
            }
        }
        
        queue.sync {
            for i in 1...3 {
                print("222-----\(i)--\(Thread.current)")
            }
        }
        
        queue.sync {
            for i in 1...3 {
                print("333-----\(i)--\(Thread.current)")
            }
        }
        
        print("syncConcurrent---end")
        
    }
```

`OC`

```
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
```

>syncConcurrent---begin
111-----1--<NSThread: 0x600000073780>{number = 1, name = main}
111-----2--<NSThread: 0x600000073780>{number = 1, name = main}
111-----3--<NSThread: 0x600000073780>{number = 1, name = main}
222-----1--<NSThread: 0x600000073780>{number = 1, name = main}
222-----2--<NSThread: 0x600000073780>{number = 1, name = main}
222-----3--<NSThread: 0x600000073780>{number = 1, name = main}
333-----1--<NSThread: 0x600000073780>{number = 1, name = main}
333-----2--<NSThread: 0x600000073780>{number = 1, name = main}
333-----3--<NSThread: 0x600000073780>{number = 1, name = main}
syncConcurrent---end

* 打印信息显示，只有一个主线程执行任务，任务串行逐一执行 
同时我们还可以看到，任务都在打印的begin和end间，说明任务是添加到队列中马上执行的。

######并行队列+异步执行
`Swift`

```
func asyncConcurrent() -> Void {
        
        print("syncConcurrent---begin")
        
        let queue = DispatchQueue(label: "queue", attributes: .concurrent)
        
        queue.async {
            for i in 1...3 {
                print("111-----\(i)--\(Thread.current)")
            }
        }
        
        queue.async {
            for i in 1...3 {
                print("222-----\(i)--\(Thread.current)")
            }
        }
        
        queue.async {
            for i in 1...3 {
                print("333-----\(i)--\(Thread.current)")
            }
        }
        
        print("syncConcurrent---end")
        
    }
```

`OC`

```
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
```

>syncConcurrent---begin
syncConcurrent---end
111-----1--<NSThread: 0x60000007b4c0>{number = 3, name = (null)}
333-----1--<NSThread: 0x60000007b380>{number = 5, name = (null)}
222-----1--<NSThread: 0x608000264e00>{number = 4, name = (null)}
111-----2--<NSThread: 0x60000007b4c0>{number = 3, name = (null)}
222-----2--<NSThread: 0x608000264e00>{number = 4, name = (null)}
333-----2--<NSThread: 0x60000007b380>{number = 5, name = (null)}
111-----3--<NSThread: 0x60000007b4c0>{number = 3, name = (null)}
222-----3--<NSThread: 0x608000264e00>{number = 4, name = (null)}
333-----3--<NSThread: 0x60000007b380>{number = 5, name = (null)}

* 打印信息显示，除了主线程，又开启了4个线程，任务是交替执行。
所有任务是在打印的begin和end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始异步执行。

######串行队列+同步执行
`Swift`
```
func syncSerial() -> Void {
        
        print("syncSerial---begin")
        
        let queue = DispatchQueue(label: "queue")
        
        queue.sync {
            for i in 1...3 {
                print("111-----\(i)--\(Thread.current)")
            }
        }
        
        queue.sync {
            for i in 1...3 {
                print("222-----\(i)--\(Thread.current)")
            }
        }
        
        queue.sync {
            for i in 1...3 {
                print("333-----\(i)--\(Thread.current)")
            }
        }
        
        print("syncSerial---end")
        
    }
```
`OC`
```
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
```
>syncSerial---begin
111-----1--<NSThread: 0x60800006b7c0>{number = 1, name = main}
111-----2--<NSThread: 0x60800006b7c0>{number = 1, name = main}
111-----3--<NSThread: 0x60800006b7c0>{number = 1, name = main}
222-----1--<NSThread: 0x60800006b7c0>{number = 1, name = main}
222-----2--<NSThread: 0x60800006b7c0>{number = 1, name = main}
222-----3--<NSThread: 0x60800006b7c0>{number = 1, name = main}
333-----1--<NSThread: 0x60800006b7c0>{number = 1, name = main}
333-----2--<NSThread: 0x60800006b7c0>{number = 1, name = main}
333-----3--<NSThread: 0x60800006b7c0>{number = 1, name = main}
syncSerial---end

* 打印信息显示，所有任务在主线程中执行的，没有开启新线程。而且串行逐一执行。所有任务都在打印的begin和end之间，这说明任务是添加到队列中马上执行的。

######串行队列+异步执行
`Swift`
```
func asyncSerial() -> Void {
        
        print("asyncSerial---begin")
        
        let queue = DispatchQueue(label: "queue")
        
        queue.async {
            for i in 1...3 {
                print("111-----\(i)--\(Thread.current)")
            }
        }
        
        queue.async {
            for i in 1...3 {
                print("222-----\(i)--\(Thread.current)")
            }
        }
        
        queue.async {
            for i in 1...3 {
                print("333-----\(i)--\(Thread.current)")
            }
        }
        
        print("asyncSerial---end")
        
    }
```
`OC`
```
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
```
>asyncSerial---begin
asyncSerial---end
111-----1--<NSThread: 0x60000007b280>{number = 6, name = (null)}
111-----2--<NSThread: 0x60000007b280>{number = 6, name = (null)}
111-----3--<NSThread: 0x60000007b280>{number = 6, name = (null)}
222-----1--<NSThread: 0x60000007b280>{number = 6, name = (null)}
222-----2--<NSThread: 0x60000007b280>{number = 6, name = (null)}
222-----3--<NSThread: 0x60000007b280>{number = 6, name = (null)}
333-----1--<NSThread: 0x60000007b280>{number = 6, name = (null)}
333-----2--<NSThread: 0x60000007b280>{number = 6, name = (null)}
333-----3--<NSThread: 0x60000007b280>{number = 6, name = (null)}

* 打印信息显示，开启了新线程，但是任务串行逐一执行。所有任务是在打印的begin和end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始同步执行。

######主队列+同步执行
`Swift`
```
 func asyncMain() -> Void {
        
        print("asyncMain---begin")
        
        let queue = DispatchQueue.main
        
        queue.async {
            for i in 1...3 {
                print("111-----\(i)--\(Thread.current)")
            }
        }
        
        queue.async {
            for i in 1...3 {
                print("222-----\(i)--\(Thread.current)")
            }
        }
        
        queue.async {
            for i in 1...3 {
                print("333-----\(i)--\(Thread.current)")
            }
        }
        
        print("asyncMain---end")
        
    }
```
`OC`
```
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
```
>syncMain---begin
(lldb) 

* 这时候打印了begin后抛出了crash，当任务加入主线程。而同步执行有个特点，就是对于任务是立马执行的。那么当我们把第一个任务放进主队列中，它就会立马执行。但是主线程现在正在处理syncMain方法，所以任务需要等`syncMain`执行完才能执行。而`syncMain`执行到第一个任务的时候，又要等第一个任务执行完才能继续执行。这样互相等待，就造成了死锁，所以我们的任务执行不了，而且end也没有打印。
######既然主队列同步执行不成立，我们试一下创建一个并行队列异步执行主队列同步任务
```
dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [self syncMain];
    });
```
>2017-03-28 18:43:14.463 GCDDemo[32024:3326849] syncMain---begin
2017-03-28 18:43:14.481 GCDDemo[32024:3326735] 1------<NSThread: 0x608000065c00>{number = 1, name = main}
2017-03-28 18:43:14.481 GCDDemo[32024:3326735] 1------<NSThread: 0x608000065c00>{number = 1, name = main}
2017-03-28 18:43:14.482 GCDDemo[32024:3326735] 1------<NSThread: 0x608000065c00>{number = 1, name = main}
2017-03-28 18:43:14.482 GCDDemo[32024:3326735] 2------<NSThread: 0x608000065c00>{number = 1, name = main}
2017-03-28 18:43:14.482 GCDDemo[32024:3326735] 2------<NSThread: 0x608000065c00>{number = 1, name = main}
2017-03-28 18:43:14.483 GCDDemo[32024:3326735] 2------<NSThread: 0x608000065c00>{number = 1, name = main}
2017-03-28 18:43:14.483 GCDDemo[32024:3326735] 3------<NSThread: 0x608000065c00>{number = 1, name = main}
2017-03-28 18:43:14.483 GCDDemo[32024:3326735] 3------<NSThread: 0x608000065c00>{number = 1, name = main}
2017-03-28 18:43:14.483 GCDDemo[32024:3326735] 3------<NSThread: 0x608000065c00>{number = 1, name = main}
2017-03-28 18:43:14.483 GCDDemo[32024:3326849] syncMain---end

* 通过打印信息可以发现，虽然是异步可以开启线程，但是还是在主线程串行执行了任务，所有任务是在打印的begin和end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始同步执行。

######主队列+异步执行
`Swift`
```
func asyncMain() -> Void {
        
        print("asyncMain---begin")
        
        let queue = DispatchQueue.main
        
        queue.async {
            for i in 1...3 {
                print("111-----\(i)--\(Thread.current)")
            }
        }
        
        queue.async {
            for i in 1...3 {
                print("222-----\(i)--\(Thread.current)")
            }
        }
        
        queue.async {
            for i in 1...3 {
                print("333-----\(i)--\(Thread.current)")
            }
        }
        
        print("asyncMain---end")
        
    }
```
`Swift`
```
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
```
>asyncMain---begin
asyncMain---end
111-----1--<NSThread: 0x600000066180>{number = 1, name = main}
111-----2--<NSThread: 0x600000066180>{number = 1, name = main}
111-----3--<NSThread: 0x600000066180>{number = 1, name = main}
222-----1--<NSThread: 0x600000066180>{number = 1, name = main}
222-----2--<NSThread: 0x600000066180>{number = 1, name = main}
222-----3--<NSThread: 0x600000066180>{number = 1, name = main}
333-----1--<NSThread: 0x600000066180>{number = 1, name = main}
333-----2--<NSThread: 0x600000066180>{number = 1, name = main}
333-----3--<NSThread: 0x600000066180>{number = 1, name = main}

* 所有任务都在主线程中，虽然是异步执行具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中逐一执行。所有任务是在打印的begin和end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始同步执行。

##4.线程间通信
在开发过程中我们可能把一些耗时的操作放在其他线程执行，但是完成之后需要刷新UI，这时候就要返回主线程刷新UI
`Swift`

```
button.setTitle("-----", for: .normal)
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            for i in 0..<3{
                print("connection\(i)-------\(Thread.current)")
            }
            DispatchQueue.main.async {
                self.button.setTitle("线程间通信", for: .normal)
            }
        }
```

`OC`

```
[_button setTitle:@"-----" forState:(UIControlStateNormal)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"connection%d------%@",i,[NSThread currentThread]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_button setTitle:@"线程间通信" forState:(UIControlStateNormal)];
        });
    });
```

>connection0-------<NSThread: 0x608000260940>{number = 3, name = (null)}
connection1-------<NSThread: 0x608000260940>{number = 3, name = (null)}
connection2-------<NSThread: 0x608000260940>{number = 3, name = (null)}
connection-------<NSThread: 0x600000067980>{number = 1, name = main}

* 打印看到在其他线程中先执行操作，执行完了之后回到主线程执行主线程的相应操作。

[demo]()先呈上，之后继续更新
