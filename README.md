# Weakifiable
A simple solution for tiring [weak self] in swift

## Usage
1. give this repo a star
2. Add EBWeakifiable to your Project.
3. simply after each closure add weakify like sample below:
```
producer.register(handler: weakify { result, strongSelf in
            strongSelf.handle(result)
 })
```

to show case the full ability here is a sampleCode of both producing and consuming:

```
class Producer: NSObject {
    
    deinit {
        print("deinit Producer")
    }
    
    private var handler: (Int) -> Void = { _ in }
    
    func register(handler: @escaping (Int) -> Void) {
        self.handler = handler
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { self.handler(42) })
    }
}

class Consumer: NSObject {
    
    deinit {
        print("deinit Consumer")
    }
    
    let producer = Producer()
    
    func consume() {
        producer.register(handler: weakify { result, strongSelf in
            strongSelf.handle(result)
        })
    }
    
    private func handle(_ result: Int) {
        print("🎉 \(result)")
    }
}
```


