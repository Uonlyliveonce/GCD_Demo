

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func syncConcurrent(_ sender: Any) {
        syncConcurrent()
    }
    @IBAction func asyncConcurrent(_ sender: Any) {
        asyncConcurrent()
    }
    @IBAction func syncSerial(_ sender: Any) {
        syncSerial()
    }
    @IBAction func asyncSerial(_ sender: Any) {
        asyncSerial()
    }
    @IBAction func syncMain(_ sender: Any) {
        syncMain()
    }
    @IBAction func asyncMain(_ sender: Any) {
        asyncMain()
    }
    @IBAction func connection(_ sender: Any) {
        button.setTitle("-----", for: .normal)
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            for i in 0..<3{
                print("connection\(i)-------\(Thread.current)")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { 
                self.button.setTitle("线程间通信", for: .normal)
            })
        }
    }
    @IBAction func barrier(_ sender: Any) {
        print("begin")
        let queue = DispatchQueue(label: "queue", attributes: .concurrent)
        queue.async {
            print("111-----\(Thread.current)")
        }
        queue.async {
            print("222-----\(Thread.current)")
        }
        queue.async(group: nil, qos: .default, flags: .barrier) { 
            print("barrier-----\(Thread.current)")
        }
        queue.async {
            print("333-----\(Thread.current)")
        }
        queue.async {
            print("444-----\(Thread.current)")
        }
        print("end")
    }
    @IBAction func after(_ sender: Any) {
        button.setTitle("延时", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            self.button.setTitle("线程间通信", for: .normal)
        }
    }
    @IBAction func group(_ sender: Any) {
        let group = DispatchGroup()
        let queue1 = DispatchQueue(label: "queue1")
        queue1.async(group: group) {
            for i in 1...10 {
                print("111-----\(i)-----\(Thread.current)")
            }
            print("111:\(Thread.current)")
        }
        let queue2 = DispatchQueue(label:"queue2")
        group.notify(queue: queue2) {
            queue2.async {
                for i in 1...10 {
                    print("222-----\(i)-----\(Thread.current)")
                }
                print("222:\(Thread.current)")
            }
        }
    }
}


extension ViewController{
    func createQueue() -> Void {
        // label:队列标签
        // qos:设置队列的优先级
        // attributes:队列形式：默认串行，设置为.concurrent代表是并行队列
        let queue0 = DispatchQueue(label: "queue0", qos: .default, attributes: .concurrent)
        //创建一个默认串行队列
        let queue1 = DispatchQueue(label: "queue1")
        //创建一个有优先级的串行队列
        let queue2 = DispatchQueue(label: "queue2", qos: .background)
    }
    
    func createGlobalQueue() -> Void {
        // 系统的全局队列
        let queue0 = DispatchQueue.global()
        let queue1 = DispatchQueue.global(qos: .default)
    }
}


extension ViewController{
    //MARK: - 并行队列+同步执行
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
    //MARK: - 并行队列+异步执行
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
    //MARK: - 串行队列+同步执行
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
    //MARK: - 串行队列+异步执行
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
    //MARK: - 主队列+同步执行
    func syncMain() -> Void {
        
        print("syncMain---begin")
        
        let queue = DispatchQueue.main
        
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
        
        print("syncMain---end")
        
    }
    //MARK: - 主队列+异步执行
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
    
    
    
    
    
    
    
}
