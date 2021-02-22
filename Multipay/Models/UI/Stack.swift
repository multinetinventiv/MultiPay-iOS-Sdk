
import Foundation

class LLNode<T> {
    
    var key: T!
    var next: LLNode?
    var previous: LLNode?
    
}

class Stack<T> {
    
    fileprivate var top: LLNode<T>! = LLNode<T>()
    
    
    //the number of items
    var count: Int {
        
        
        //determine if the key or instance exist
        let topitem: T? = self.top?.key
        
        if (topitem == nil) {
            return 0
        }
        
        var current: LLNode = top
        var x: Int = 1
        
        
        //cycle through the list of items to get to the end.
        while ((current.next) != nil) {
            current = current.next!
            x += 1
        }
        
        return x
        
        
    }
    
    
    //push an item onto the stack
    func push(_ key: T) {
        
        
        //check for the instance
        if (top == nil) {
            top = LLNode<T>()
        }
        
        
        //determine if the head node is populated
        if (top.key == nil) {
            top.key = key
            return
        }
        else {
            
            //establish the new item instance
            let childToUse: LLNode<T> = LLNode<T>()
            childToUse.key = key
            
            
            //set newly created item at the top
            childToUse.next = top
            top = childToUse
            
            
        }
        
    }
    
    
    
    //remove an item from the stack
    func pop() -> T? {
        
        //determine if the key or instance exist
        let topitem: T? = self.top?.key
        
        if (topitem == nil){
            return nil
        }
        
        //retrieve and queue the next item
        let queueitem: T? = top.key!
        
        
        //reset the top value
        if let nextitem = top.next {
            top = nextitem
        }
        else {
            top = nil
        }
        
        
        return queueitem
        
    }
    
    
    
    //retrieve the top most item
    func peek() -> T? {
        
        
        //determine if the key or instance exist
        if let topitem: T = self.top?.key {
            return topitem
        }
            
        else {
            return nil
        }
        
        
    }
    
    
    
    //check for the presence of a value
    func isEmpty() -> Bool {
        
        //determine if the key or instance exist
        if let _: T = self.top?.key {
            return false
        }
            
        else {
            return true
        }
        
    }
    
    func clear()
    {
        var i = count
        while i > 0 {
             let _ = pop()
             i -= 1
        }
    }
}
