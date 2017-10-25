//
//  SwiftyGA.swift
//  SwiftyGA
//
//  Created by Arash Z.Jahangiri on 10/21/17.
//  Copyright (c) 2017 Arash Z.Jahangiri. All rights reserved.
//

import Foundation
import Alamofire

extension Dictionary /* <KeyType, ValueType> */ {
    func mix(_ dictionary: Dictionary<Key, Value>?) -> Dictionary {
        if dictionary == nil { return self }
        
        var newDictionary = self
        for key in dictionary!.keys {
            if newDictionary[key] != nil { continue }
            newDictionary[key] = dictionary![key]
        }
        
        return newDictionary
    }
}

public class Utility{
    class func screenName(obj: Any) -> String {
        return String(describing: type(of: obj))
    }
}

public enum Track {
    public enum Category : String {
        case click  = "click"
        case tap = "tap"
    }
    
    public enum Action : String {
        case tap  = "tap Action"
        case next  = "next Action"
        case back  = "back Action"
    }
}

protocol GoogleTracking {
    func screenView(_ viewName: String)
    func send(_ track: TrackProtocol)
}

public enum API: String {
    case ssl
    case http
    case debug
    
    func string() -> String {
        switch self {
        case .ssl:
            return "https://ssl.google-analytics.com/collect"
        case .http:
            return "http://www.google-analytics.com/collect"
        case .debug:
            return "https://www.google-analytics.com/debug/collect"
        }
    }
}

public class SwiftyGA: NSObject, GoogleTracking{
    
    public static let shared = SwiftyGA()
    public var trackingID: String = ""
    private static let identifierKey = "YOUR-IDENTIFIER"
    public var usesVendorIdentifier = false
    var sessionManager: Alamofire.SessionManager!
    
    private override init() {}
    
    public func configure(trackingID: String) {
        self.trackingID = trackingID
        
        setupSessionManager()
    }
    
    func setupSessionManager() {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["User-Agent"] = userAgent
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    open func screenView(_ viewName: String) {
        let screen = Screen(viewName: viewName)
        send(screen)
    }
    
    open func event(category: Track.Category, action: Track.Action, label: String?, value: Int?) {
        let event = Event(category: category, action: action, label: label, value: value)
        send(event)
    }
    
    open func exception(description: String, fatal: Bool?) {
        let exception = Exception(description: description, fatal: fatal)
        send(exception)
    }
    
    open func sessionStart(description: String) {
        let session = SessionStart(description: description)
        send(session)
    }
    
    open func sessionEnd(description: String) {
        let session = SessionEnd(description: description)
        send(session)
    }
    
    func send(_ track: TrackProtocol) {
        let params = track.params
        let trackParams = defaultParams().mix(params)
        
        switch track.type {
        case .screen:
            print("=======\(track.description)=====")
        case .event:
            print("=======\(track.params)=====")
        case .exception:
            print("=======\(track.params)=====")
        case .session:
            print("=======\(track.description)=====")
        }
        
        sessionManager.request(API.ssl.string(), method: .get, parameters: trackParams)
            .response { response in
                if response.error != nil {
                    print(response.error!)
                }else if (response.data != nil){
                    do {
                        if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: response.data!, options: []) as? NSDictionary {
                            // Print out dictionary
                            print(convertedJsonIntoDict)
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    func defaultParams() -> [String: String] {
        let params: [String: String] = [
            "v": "1",
            "tid": trackingID,
            "cid": uniqueUserIdentifier,
            "an": appName,
            "av": appVersion,
            "aid": appIdentifier,
            "sr": screenResolution,
            "ul": userLanguage,
            "ua": userAgent
        ]
        return params
    }
    
    private lazy var uniqueUserIdentifier: String = {
        if let identifier = UIDevice.current.identifierForVendor?.uuidString, self.usesVendorIdentifier {
            return identifier
        }
        
        let defaults = UserDefaults.standard
        guard let identifier = defaults.string(forKey: SwiftyGA.identifierKey) else {
            let identifier = UUID().uuidString
            defaults.set(identifier, forKey: SwiftyGA.identifierKey)
            defaults.synchronize()
            
            return identifier
        }
        
        return identifier
    }()
    
    public lazy var userAgent: String = {
        let currentDevice = UIDevice.current
        let osVersion = currentDevice.systemVersion.replacingOccurrences(of: ".", with: "_")
        return "Device:\(currentDevice.model),OS_Ver:\(osVersion)"
    }()
    
    private lazy var appName: String = {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Unknown"
    }()
    
    private lazy var appIdentifier: String = {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String  ?? "Unknown"
    }()
    
    private lazy var appVersion: String = {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String  ?? "Unknown"
    }()
    
    private lazy var appBuild: String = {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String  ?? "Unknown"
    }()
    
    private lazy var formattedVersion: String = {
        return "\(self.appVersion) (\(self.appBuild))"
    }()
    
    private lazy var userLanguage: String = {
        guard let locale = Locale.preferredLanguages.first, locale.characters.count > 0 else {
            return "Unknown"
        }
        
        return locale
    }()
    
    private lazy var screenResolution: String = {
        let size = UIScreen.main.bounds.size
        return "\(size.width)X\(size.height)"
    }()
}

// MARK: - Track Protocol
//https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide
enum TrackType {
    case screen
    case event
    case exception
    case session
}

protocol TrackProtocol {
    var description: String { get }
    var params: [String: String] { get }
    var type: TrackType { get }
}

public struct Screen: TrackProtocol {
    let viewName: String
    var contentDescription: String {
        return viewName
    }
    
    init(viewName: String) {
        self.viewName = viewName
    }
    
    var description: String {
        return "Screen->\(viewName)"
    }
    
    var params: [String: String] {
        return [
            "t": "screenview",
            "cd": self.viewName,
        ]
    }
    
    var type: TrackType {
        return TrackType.screen
    }
}

public struct Event: TrackProtocol {
    let category: Track.Category
    let action: Track.Action
    let label: String?
    let value: Int?
    
    init(category: Track.Category, action: Track.Action, label: String?, value: Int?) {
        self.category = Track.Category(rawValue: category.rawValue)!
        self.action = Track.Action(rawValue: action.rawValue)!
        self.label = label
        self.value = value
    }
    
    var description: String {
        return "Event->\(category), action: \(action), label: \(String(describing: label)), value: \(String(describing: value)))"
    }
    
    var params: [String: String] {
        var params = [String: String]()
        params["t"] = "event"
        params["ec"] = category.rawValue
        params["ea"] = action.rawValue
        if label != nil {
            params["el"] = label!
        }
        if value != nil {
            params["ev"] = String(value!)
        }
        return params
    }
    
    var type: TrackType {
        return TrackType.event
    }
}

public struct Exception: TrackProtocol {
    let description: String
    let fatal: Bool?
    
    var fatalString: String? {
        if fatal == nil { return nil }
        if fatal! {
            return "1"
        } else {
            return "0"
        }
    }
    
    init(description: String, fatal: Bool?) {
        self.description = description
        self.fatal = fatal
    }
    
    var params: [String: String] {
        var params = [String: String]()
        params["t"] = "exception"
        params["exd"] = description
        if fatal != nil {
            params["exf"] = fatalString!
        }
        return params
    }
    
    var type: TrackType {
        return TrackType.exception
    }
}

public struct SessionStart: TrackProtocol {
    let description: String
    
    init(description: String) {
        self.description = description
    }
    
    var params: [String: String] {
        var params = [String: String]()
        params["sc"] = "start"
        params["dl"] = "/start"
        return params
    }
    
    var type: TrackType {
        return TrackType.session
    }
}

public struct SessionEnd: TrackProtocol {
    let description: String
    
    init(description: String) {
        self.description = description
    }
    
    var params: [String: String] {
        var params = [String: String]()
        params["sc"] = "end"
        params["dl"] = "/end"
        return params
    }
    
    var type: TrackType {
        return TrackType.session
    }
}
