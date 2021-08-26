/*
 Callbacks are a part of almost all iOS apps, and as frameworks
 such as `RxSwift` keep gaining in popularity, they become ever
 more present in our codebase.
 
 Seasoned Swift developers are aware of the potential memory
 leaks that `@escaping` callbacks can produce, so they make
 real sure to always use `[weak self]`, whenever they need to
 use `self` inside such a context. And when they need to have
 `self` be non-optional, they then add a `guard` statement along.
 
 Consequently, this syntax of a `[weak self]` followed by
 a `guard` rapidly tends to appear everywhere in the codebase.
 The good thing is that, through a little protocol-oriented
 trick, it's actually possible to get rid of this tedious
 syntax, without loosing any of its benefits!
 */

import Foundation

protocol EBWeakifiable: class { }

extension EBWeakifiable {
    func weakify(_ code: @escaping (Self) -> Void) -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            
            code(self)
        }
    }
    
    func weakify<T>(_ code: @escaping (T, Self) -> Void) -> (T) -> Void {
        return { [weak self] arg in
            guard let self = self else { return }
            
            code(arg, self)
        }
    }
}

extension NSObject: EBWeakifiable { }
