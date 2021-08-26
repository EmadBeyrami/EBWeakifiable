// MARK: - Source: https://github.com/EmadBeyrami/EBWeakifiable
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
    
    // MARK: type 1
    /// Simple solution for tiring [weak self] in swift
    ///
    ///      producer.register { [weak self] in
    ///          guard let self = self else { return }
    ///          self.runJob()
    ///      }
    ///
    /// Simply after each closure add weakify like sample below:
    ///
    ///      producer.register(handler: weakify { strongSelf in
    ///          strongSelf.runJob()
    ///      })
    ///
    /// ENJOY ❤️
    ///
    func weakify(_ code: @escaping (Self) -> Void) -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            code(self)
        }
    }
    
    // MARK: type 2
    /// Simple solution for tiring [weak self] in swift
    ///
    ///      producer.register { [weak self] in
    ///          guard let self = self else { return }
    ///          return self.signout()
    ///      }
    ///
    /// Simply after each closure add weakify like sample below:
    ///
    ///      producer.register(handler: weakify { strongSelf in
    ///          return strongSelf.signout()
    ///      })
    ///
    /// ENJOY ❤️
    ///
    func weakify<Z>(_ code: @escaping (Self) -> Z) -> () -> Z? {
        return { [weak self] in
            guard let self = self else { return nil }
            return code(self)
        }
    }
    
    // MARK: type 3
    /// Simple solution for tiring [weak self] in swift
    ///
    ///      producer.register { [weak self] result in
    ///          guard let self = self else { return }
    ///          self.handle(result)
    ///      }
    ///
    /// Simply after each closure add weakify like sample below:
    ///
    ///      producer.register(handler: weakify { strongSelf, result in
    ///          strongSelf.handle(result)
    ///      })
    ///
    /// ENJOY ❤️
    ///
    func weakify<T>(_ code: @escaping (Self, T) -> Void) -> (T) -> Void {
        return { [weak self] data in
            guard let self = self else { return }
            code(self, data)
        }
    }
    
    // MARK: type 4
    /// Simple solution for tiring [weak self] in swift
    ///
    ///      producer.register { [weak self] number in
    ///          guard let self = self else { return }
    ///          self.login(number)
    ///      }
    ///
    /// Simply after each closure add weakify like sample below:
    ///
    ///      producer.register(handler: weakify { (strongSelf, number) -> Bool in
    ///          strongSelf.login(number)
    ///      })
    ///
    /// ENJOY ❤️
    ///
    func weakify<T, Z>(_ code: @escaping (Self, T) -> Z) -> (T) -> Z? {
        return { [weak self] data in
            guard let self = self else { return nil }
            return code(self, data)
        }
    }
    
}

extension NSObject: EBWeakifiable { }
