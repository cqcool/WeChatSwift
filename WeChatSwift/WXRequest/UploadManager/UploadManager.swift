//
//  UploadManager.swift
//  WeChatSwift
//
//  Created by 陈群 on 2024/10/22.
//  Copyright © 2024 alexiscn. All rights reserved.
//

import Foundation
//import AliyunOSSSwiftSDK
import AliyunOSSiOS

typealias UploadResult = ((_ obj: Any?, _ error: NSError?)->Void)

let ourLogLevel = OSSDDLogLevel.verbose
@objcMembers
class UploadManager: NSObject {
    static let manager = UploadManager()
    var result: UploadResult?
    private var yunModel: ALiYunModel?
    private override init() {
        super.init()
        setup()
    }
    func upload(prefixType: PrefixType, number: String, type: UploadType, image: UIImage, result: UploadResult?) {
        self.result = result
        let request = UploadRequest(prefixType: prefixType, number: number, type: type)
        request.startWithCompletionBlock { request in
            guard let resp = try? JSONDecoder().decode(ALiYunModel.self, from: request.wxResponseData()) else {
                return
            }
            self.yunModel = resp
            self.uploadAvatar(image: image, imageName: resp.nameList?.first ?? "", prefixType: prefixType)
            
        } failure: { request in
            self.result?(nil, request.error as NSError?)
            self.result = nil
        }

    }
    func uploadAvatar(image: UIImage, imageName: String, prefixType: PrefixType) {
        
        let request = OSSPutObjectRequest()
        request.uploadingData = image.pngData()!
        request.bucketName = self.yunModel?.bucketName ?? ""
        request.objectKey = imageName// + ".jpeg"
//        request.uploadProgress = { (bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
//            print("bytesSent:\(bytesSent),totalBytesSent:\(totalBytesSent),totalBytesExpectedToSend:\(totalBytesExpectedToSend)");
//        };
        
        let provider = OSSFederationTokenCredentialProvider {
            let tcs = TaskCompletionSource()
//            DispatchQueue(label: "test").async {
//                Thread.sleep(forTimeInterval: 10)
                let token = OSSFederationToken()
                token.tAccessKey = self.yunModel?.accessKeyId ?? ""//"STS.tAccessKey"
                token.tSecretKey = self.yunModel?.accessKeySecret ?? ""//"tSecretKey"
                token.tToken = self.yunModel?.securityToken ?? ""//"tToken"
                token.expirationTimeInGMTFormat = self.yunModel?.expiration ?? ""
                tcs.trySetResult(token)
//            }
//            tcs.wait(timeout:10)
            if let error = tcs.task.error {
                let nsError = error as NSError
                if nsError.code == OSSClientErrorCODE.codeNotKnown.rawValue,
                   let errorMessage = nsError.userInfo[OSSErrorMessageTOKEN] as? String,
                   errorMessage == "TaskCompletionSource wait timeout." {
                    // 超时错误
                }
                throw error
            } else if let result = tcs.task.result as? OSSFederationToken {
                return result
            }
            throw NSError(domain: OSSClientErrorDomain,
                          code: OSSClientErrorCODE.codeSignFailed.rawValue,
                          userInfo: [OSSErrorMessageTOKEN : "Can not get FederationToken."])
        }
        
        let client = OSSClient(endpoint: self.yunModel?.endpoint ?? "", credentialProvider: provider)
        let task = client.putObject(request)
        task.continue({ (t) -> Any? in
            if (t.error != nil) {
                let error: NSError = (t.error)! as NSError
                self.result?(nil, error)
                self.result = nil
//                self.ossAlert(title: "error", message: error.description)
            } else {
                self.updateUserInfo()
//                self.ossAlert(title: "notice", message: result?.description)
            }
            return
        }).waitUntilFinished()
    }
    
    func updateUserInfo() {
        var imageName: String = ""
        if let name = self.yunModel?.nameList?.first,
           name.contains("/")  {
            imageName = (name as NSString).components(separatedBy: "/").last ?? ""
        }
        let request = updateInfoRequest(head: imageName)
        request.startWithCompletionBlock { request in
            self.result?(imageName, nil)
            self.result = nil
        } failure: { request in
            self.result?(nil, request.error as NSError?)
            self.result = nil
        } 
    }
    
    func setup() {
        OSSDDLog.removeAllLoggers();
        OSSLog.enable();
        
        
    }
}

/*
 {"code":200,"data":{"bucketName":"boxgroup","stsServer":"http:\/\/boxgroup.oss-ap-southeast-1.aliyuncs.com","nameList":["common\/3e03fa3856e645bab9dd792eb869e2fc"],"accessKeyId":"STS.NV55oQvdN8Rx11bL2PNHVc8Ey","accessKeySecret":"14Aa7kVZrSsm4yNv4sTmH73HTzvYjaaxfG5RhB99vRw6","endpoint":"oss-ap-southeast-1.aliyuncs.com","securityToken":"CAIS1wJ1q6Ft5B2yfSjIr5WAftXlm7tvj5CTMxfTqDIFQsd6jP3umzz2IHpPfnZoBOgcs\/kwlG9T7Pgdlq90UIR+WVecpQO+GlcNo22beIPkl5Gf595t0e+QewW6Dxr8w7WdAYHQR8\/cffGAck3NkjQJr5LxaTSlWS7CU\/iOkoU1VskLeQO6YDFafpQ0QDFvs8gHL3DcGO+wOxrx+ArqAVFvpxB3hBEYi8G2ydbO7QHF3h+oiL1XhfyoesL7P5I3Zs4gCY\/shbIqTMebjn4MsSot3bxtkalJ9Q3AutygGFRL632ESbGOqYcwdFIhPPVnRP4b96KiyucaoOXWkJ\/s0RFJMPGx0\/453TEhqSGtPZRKVr5RHd6TUxxG0uAeIAf3+EryzRiuvpfwgT6dhvUKPDdtK1eUY+bsgxupaRyIcKOu24pdsvFW9F6Fk5f0YTbGLdqXuYGCrNBtBytAGoABF2gJo4i5IXcYdV6hYsSGtKxN4MQbNQcNRbCJ\/ZdiwTRLwGaIYpLh\/BvGQbSXeKEwBaPXL4XRNLXzze4xt4Wapl7kEpu3hTTKJiM6y49QOCsZglbyB\/ilM1BWyf09gKosYxDTj\/9Hon\/U\/QgR6Zx7vJxrJmp\/9dSEmkoE8\/6CoFUgAA==","expiration":"2024-10-22T09:23:09Z"},"sign":"X7XlmLqSNM+y5gQZfFtCCp1fX7ilP3VM217DvvdDzw4=","msg":"成功"}
 */
@objcMembers
class ALiYunModel: NSObject, Codable {
     var bucketName: String?
     var stsServer: String?
     var nameList: [String]?
     var accessKeyId: String?
     var accessKeySecret: String?
     var endpoint: String?
     var securityToken: String?
     var expiration: String?
    
    enum CodingKeys: String, CodingKey {
        case bucketName
        case stsServer
        case nameList
        case accessKeyId
        case accessKeySecret
        case endpoint
        case securityToken
        case expiration
    }
}
