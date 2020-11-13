@available(iOS 10.0, *)
public struct UNAuthorizationOptions : OptionSet {
    public var rawValue: UInt
    
    public init(rawValue: UInt)
    
    public static var badge: UNAuthorizationOptions { get }
    public static var sound: UNAuthorizationOptions {get}
    public static var alert: UNAuthorizationOptions {get}
    public static var carPlay: UNAuthorizationOptions {get}
}
