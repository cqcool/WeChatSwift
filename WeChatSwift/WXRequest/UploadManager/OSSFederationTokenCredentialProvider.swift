//
//  OSSRootViewController.swift
//  OSSSwiftDemo
//
//  Created by huaixu on 2018/1/2.
//  Copyright © 2018年 aliyun. All rights reserved.
//

import UIKit
//import AliyunOSSSwiftSDK
//import AliyunOSSiOS


//public class OSSFederationTokenCredentialProvider: OSSFederationCredentialProvider {
//    var token: OSSFederationToken?
//    private var tokenGetter: () throws -> OSSFederationToken
//    
//    public init(tokenGetter: @escaping () throws -> OSSFederationToken) {
//        self.tokenGetter = tokenGetter
//        super.init()
//    }
//    
//    public override func getToken() throws -> OSSFederationToken {
//        do {
//            if var token = token {
//                if let expirationTimeInGMTFormat = token.expirationTimeInGMTFormat {
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.timeZone = TimeZone(identifier: "GMT")
//                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//                    if let data = dateFormatter.date(from: expirationTimeInGMTFormat) {
//                        token.expirationTimeInMilliSecond = Int64(data.timeIntervalSince1970 * 1000)
//                    }
//                }
//                let expirationDate = Date(timeIntervalSince1970: TimeInterval(token.expirationTimeInMilliSecond / 1000))
//                let interval = expirationDate.timeIntervalSince(NSDate.oss_clockSkewFixed())
//                if interval < 5 * 60 {
//                    token = try self.tokenGetter()
//                    self.token = token
//                }
//                return token
//            } else {
//                let token = try self.tokenGetter()
//                self.token = token
//                return token
//            }
//        } catch {
//            throw NSError(domain: OSSClientErrorDomain,
//                          code: OSSClientErrorCODE.codeSignFailed.rawValue,
//                          userInfo: [OSSErrorMessageTOKEN : error])
//        }
//    }
//}
//
//
//public class TaskCompletionSource: OSSTaskCompletionSource<AnyObject> {
//    
//    public func wait(timeout: TimeInterval) {
//        let timer = DispatchSource.makeTimerSource()
//        timer.schedule(deadline: .now() + timeout)
//        timer.setEventHandler {
//            if !self.task.isCompleted {
//                let error = NSError(domain: OSSClientErrorDomain,
//                                    code: OSSClientErrorCODE.codeNotKnown.rawValue,
//                                    userInfo: [OSSErrorMessageTOKEN : "TaskCompletionSource wait timeout."])
//                self.trySetError(error)
//            }
//        }
//        timer.resume()
//        task.waitUntilFinished()
//        timer.cancel()
//    }
//}
