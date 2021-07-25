# TitanHTTP
## _Yet another networking library_

[![N|Solid](https://media.npr.org/assets/img/2017/10/16/titan-41d62a75c7b7376fe8ff872bb1deec3bc24a4a14.jpeg)]()


TitanHTTP is a networking library built on top of Alamofire, providing easy and convenient ways to make requests leveraging the power of the Combine framework. It is in Alpha stage so feedback is welcomed.

## Current Features

- Making Data requests
- Authentication and re-Authentication through a protocol
- Request payloads with either a dictionary or encodable object
- Prints requests and responses for easy debuging

## Usage

Create an instance of TitanRequestManager and if needed hold a single reference to it (makes it easy to handle authentication requests race conditions). The Configuration object it receives on init provides the session configuration you desire to use and an instance conforming to TitanAuthHandlerProtocol (this one takes care of authentication related tasks, it is up to you to implement as you desire). Both are optionals, if you dont provide a session the default AF configuration is used.


```sh
public struct TitanConfiguration {
    let sessionConfiguration: URLSessionConfiguration?
    let authHandler: TitanAuthHandlerProtocol?
    
    public init(sessionConfiguration: URLSessionConfiguration? = nil,
                authHandler: TitanAuthHandlerProtocol? = nil) {
        self.sessionConfiguration = sessionConfiguration
        self.authHandler = authHandler
    }
}
```

TitanAuthHandlerProtocol provides 2 functions that will be called whenever a request is made (you can parse the url and decide what set of authentication headers to add), and whenever a 403 is returned from a service so you may act on refreshing authentication credentials or not. Once you refresh you either return success or failure, or notRelevant if you actually dont care about refreshing for a specific request (Ex: a url you dont actually handle). It will retry the request and call again (getAuthenticationHeadersIfNeeded) so it will pick up the updated values from there. The url of the request is provided to give you context.

```sh
public protocol TitanAuthHandlerProtocol {
    
    /// Invoked in each request to adapt the request adding additional headers for authentication
    /// - Parameter request: unmodified request to be sent
    func getAuthenticationHeadersIfNeeded(forRequest request: URLRequest) -> [String: String]?
    
    /// Provides the request that failed with 403 to obtain credentials and have them available for next retry
    /// - Parameters:
    ///   - request: original request
    ///   - completion: signals the library of the authentication credentials update result in order to retry or not
    func updateAuthentication(forRequest request: URLRequest, completion: @escaping (AuthenticationUpdateResult) -> Void)
}
```

To make a basic request just create a subscriber and sink

```sh
titan.makeRequest(TitanHttpRequest(url: "https://www.google.com", method: .get)).sink { completion in
            // Handle completion
        } receiveValue: { data in
            // Handle data
        }.store(in: &subscribers)
```

TitanHttpRequest also accepts a payload, additional headers and if you either want to use cache or ignore it.

```sh
public struct TitanHttpRequest {
    let url: String
    let method: HttpMethod
    let payload: Payload?
    let headers: [String: String]?
    let ignoreCache: Bool
    
    public init(url: String,
                method: HttpMethod,
                payload: Payload? = nil,
                headers: [String: String]? = nil,
                ignoreCache: Bool = true) {
        self.url = url
        self.method = method
        self.payload = payload
        self.headers = headers
        self.ignoreCache = ignoreCache
    }
}
```
