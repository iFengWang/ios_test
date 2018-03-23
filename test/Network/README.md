## 介绍

`XSYNetwork` 是基于 `AFNetworking` 的更高层的网络请求抽象库，也可以看作网络管理层，用来封装 `URL` 等请求所需要的一些基本信息，客户端可以直接操作 `XSYNetwork` ，不用与 `AFNetworking` 有直接联系。

### Provider
`Provider` 是一个提供网络请求服务的提供者。通过一些初始化配置之后，在外部可以直接用`Provider` 来发起 `Request`。

### Request
在进行网络请求时，第一步需要进行配置，来生成一个 `Request`。首先按照官方文档，创建一个类，遵守 `XSYTargetInterface` 协议，并实现协议所规定的属性。 `Request` 的生成过程如下：

```objc
XSYTargetInterface => (EndpointBlock) => Endpoint => (RequestBlock) => Request
```
根据创建了一个遵守 `XSYTargetInterface` 协议的类，我们完成了如下几个属性的设置：

```objc
@property (readonly, nonatomic, strong) NSURL *baseURL;

@property (readonly, nonatomic, copy) NSString *path;

@property (readonly, nonatomic, assign) XSYHTTPMethodType method;

@property (readonly, nullable, nonatomic, strong) XSYParameters *parameters;

@property (readonly, nullable, nonatomic, strong) XSYHttpHeaderFields *headers;

@property (readonly, nonatomic, strong) XSYRequestTask *task;
```
提供了这些属性之后，就可以进一步配置去生成所需要的请求。

通过 `EndpointBlock` 生成 `Endpoint`。`Endpoint` 是一个对象，把网络请求所需的一些属性和方法进行了包装，在 `Endpoint` 类中有如下属性：

```objc
@property (readonly, nonatomic, copy) NSString *url;

@property (readonly, nonatomic, assign) XSYHTTPMethodType method;

@property (nullable, readonly, nonatomic, strong) XSYParameters *parameters;

@property (readonly, nonatomic, strong) XSYRequestTask *task;

@property (nullable, readonly, nonatomic, strong) XSYHttpHeaderFields *httpHeaderFields;
```

`Endpoint` 这几个属性可以和上面通过 `XSYTargetInterface` 配置的属性对应起来。

`EndpointBlock` 是一个 `block`，参数为遵守 `XSYTargetInterface` 协议的类，返回一个 `Endpoint` 对象。可以使用 `Provider` 扩展里的 `DefaultEndpointBlock`。

再通过 `RequestBlock`，传入 `Endpoint` 生成 `Request`，可以使用 `Provider` 扩展里的 `DefaultRequestBlock`。

使用 `Endpoint` 可以更灵活地配置网络请求，以适应更多样化的业务需求，可以使用以下方法在 `EndpointBlock` 中给一些网络请求添加请求头，替换请求参数，让这些请求配置更加灵活：

```objc
- (XSYEndpoint *)addNewParameters:(nullable XSYParameters *)newParameters;

- (XSYEndpoint *)replaceNewTask:(XSYRequestTask *)newTask;

- (XSYEndpoint *)addNewHttpHeaderFields:(nullable XSYHttpHeaderFields *)newHttpHeaderFields;
```

### Response
`Response` 类对于请求结果进行了封装，提供了一些判断请求 `statusCode` 方法。

### Plugins
`XSYNetwork` 提供了一个插件协议 `XSYPluginInterface`，协议里规定了几种方法，阐明了插件的应用区域：

```objc
@protocol XSYPluginInterface <NSObject>

@optional

/**
 Called to modify a request before sending.
 */
- (NSURLRequest *)prepare:(NSURLRequest *)request target:(id<XSYTargetInterface>)target;

/**
 Called immediately before a request is sent over the network (or stubbed).
 */
- (void)willSend:(id<XSYRequestTypeInterface>)requestType target:(id<XSYTargetInterface>)target;

/**
 Called after a response has been received, but before the `XSYProvider` has invoked its completion handler.
 */
- (void)didReceive:(XSYResult<XSYResponse *> *)result target:(id<XSYTargetInterface>)target;

/**
 Called to modify a result before completion.
 */
- (XSYResult<XSYResponse *> *)process:(XSYResult<XSYResponse *> *)result target:(id<XSYTargetInterface>)target;

@end
```

* `prepare` 可以在请求前对 `request` 进行修改。
* `willSend` 在请求发送之前的一瞬间调用，这个可以用来添加请求时的 `loading toast`。
* `didReceive` 在接收到请求响应时，且在 `Provider` 的 `CompletionBlock` 之前调用。
* `process` 在 `CompletionBlock` 之前调用，用来修改请求结果。

可以通过以下图理解插件调用时机:

```sequence
Note right of Request: prepare
Request->AFNetworking: 
Note right of AFNetworking: willSend
AFNetworking->Response: send request
Note right of Response: didReceive
Response->Result: 
Note right of Result: process
Result->Complete handler: 
```
使用插件的方式，让代码仅保持着主干逻辑，使用者根据业务需求自行加入插件来配置自己的网络业务层，这样做更加灵活，低耦合。目前提供 3 种插件：

* `AccessTokenPlugin` `OAuth` 的 `Token` 验证。
* `NetworkActivityPlugin` 网络请求状态。
* `NetworkLoggerPlugin` 网络日志。

插件内部结构很简单，除了自行定义的一些变量外，就是遵守 `XSYPluginInterface` 协议后，去实现协议规定的方法，在特定方法内做自己需要做的事。因为 `XSYPluginInterface` 内的方法都是可选方法，在具体插件内不一定需要实现所有的协议方法，仅根据需要实现特定方法即可。
写好插件之后，使用起来也比较简单，`Provider` 的初始化方法中，有个形参 `plugins:(NSArray<id<XSYPluginInterface>> *)plugins`，把网络请求中需要用到的插件加入数组中。

## Future

- [ ] `Response` 中添加一些数据处理方法。例：图片转换。
- [ ] 添加 `Test stub`，提供便捷单元测试方法。
- [ ] 添加 `Cache`（待定）


