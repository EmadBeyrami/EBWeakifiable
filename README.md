# Weakifiable
A simple solution for tiring [weak self] in swift

## Usage
1. give this repo a **Star** ⭐️
2. Add `EBWeakifiable` to your Project.
3. simply after each closure add `weakify` like sample below:
``` swift
producer.register(handler: weakify { strongSelf, result in
            strongSelf.handle(result)
 })
```

to show case the full ability here is a sampleCode of both producing and consuming:

``` swift
class User: NSObject {
    
    private var handler: (Int) -> Void = { _ in }
    
    func register(handler: @escaping (Int) -> Void) {
        self.handler = handler
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { self.handler(42) })
    }
    
    func login(handler: @escaping (Int) -> Bool?) {
        
    }
    
    func signout(handler: @escaping () -> Bool?) {
        
    }
    
    func runJob(handler: @escaping () -> Void) {
        
    }
    
    deinit {
        print("deinit Producer")
    }
    
}

class Consumer: NSObject {
    
    let user = User()
    
    func consume() {
        
        // MARK: - type 1
        /// old
        user.runJob { [weak self] in
             guard let self = self else { return }
             self.runJob()
         }
        
        /// new
        user.runJob(handler: weakify { strongSelf in
            strongSelf.runJob()
        })
        
        // MARK: - type 2
        /// old
        user.signout { [weak self] in
             guard let self = self else { return false }
             return self.signout()
         }
        
        /// new
        user.signout(handler: weakify { strongSelf in
            return strongSelf.signout()
        })
        
        // MARK: - type 3
        /// old
        user.register { [weak self] result in
             guard let self = self else { return }
             self.handle(result)
         }
        
        /// new
        user.register(handler: weakify { strongSelf, result in
            strongSelf.handle(result)
        })
        
        // MARK: - type 4
        /// old
        user.login { [weak self] number in
             guard let self = self else { return false }
             return self.login(number)
         }
        
        /// new
        user.login(handler: weakify { (strongSelf, number) -> Bool in
            return strongSelf.login(number)
        })
        
    }
    
    // for 3
    private func handle(_ result: Int) {
        print("🎉 \(result)")
    }
    
    // for 4
    private func login(_ result: Int) -> Bool {
        print("🎉 \(result) is Login")
        return true
    }
    
    // for 2
    private func signout() -> Bool {
        print("🎉 user is signout")
        return true
    }
    
    // for 1
    private func runJob() {
        print("🎉 run Job")
    }
    
    deinit {
        print("deinit Consumer")
    }
}

```
