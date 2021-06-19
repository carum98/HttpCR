# HttpCR

[![CI Status](https://img.shields.io/travis/carum98/HttpCR.svg?style=flat)](https://travis-ci.org/carum98/HttpCR)
[![Version](https://img.shields.io/cocoapods/v/HttpCR.svg?style=flat)](https://cocoapods.org/pods/HttpCR)
[![License](https://img.shields.io/cocoapods/l/HttpCR.svg?style=flat)](https://cocoapods.org/pods/HttpCR)
[![Platform](https://img.shields.io/cocoapods/p/HttpCR.svg?style=flat)](https://cocoapods.org/pods/HttpCR)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

HttpCR is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HttpCR'
```

## Author

carum98, carumtito@gmail.com

## Example

```swift
import Foundation
import HttpCR

class Client: NetworkHttpCR {
    
    let baseURL = "https://jsonplaceholder.typicode.com/"
    var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    
    func getPosts(complete: @escaping (Result<[Post], ApiError>) -> Void) {
        let path = "posts"
        
        self.request(
            path: "\(baseURL)\(path)",
            methods: .GET,
            type: [Post].self,
            completion: complete
        )
    }
    
    func createPost(post: Post, complete: @escaping (Result<Post, ApiError>) -> Void) {
        let path = "posts"
        
        let parameters: [String: Any] = [
            "title": post.title,
            "body": post.body,
            "userId": post.userId
        ]
        
        self.request(
            path: "\(baseURL)\(path)",
            methods: .POST,
            parameters: parameters,
            type: Post.self,
            completion: complete
        )
    }
    
    func updatePost(post: Post, id: Int, complete: @escaping (Result<Post, ApiError>) -> Void) {
        let path = "posts/\(id)"
        
        let parameters: [String: Any] = [
            "id": post.id,
            "title": post.title,
            "body": post.body,
            "userId": post.userId
        ]
        
        self.request(
            path: "\(baseURL)\(path)",
            methods: .PUT,
            parameters: parameters,
            type: Post.self,
            completion: complete
        )
    }
    
    func deletePost(id: Int, complete: @escaping (Result<Post, ApiError>) -> Void) {
        let path = "posts/\(id)"
        
        self.request(
            path: "\(baseURL)\(path)",
            methods: .DELETE,
            type: Post.self,
            completion: complete
        )
    }
}
```

## License

HttpCR is available under the MIT license. See the LICENSE file for more info.
