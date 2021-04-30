//
//  Multipay.swift
//  Multipay
//
//  Created by ilker sevim on 2.10.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation

public protocol MultipayDelegate : class {
    
    //MARK: - WalletToken expire delegate methods
    
    func walletTokenExpired(expiredWalletToken: String?)
    
    //MARK: - Card select-change-unselect operations result methods
    
    //Select or change wallet requests delegate method
    func multipaySelectedCardInfos(cardBalance:String?, cardImageUrl: String?, cardName: String?, walletToken: String?, cardMaskedNumber: String?)
    
    //UnselectWallet(Delete) requests delegate method
    func multipayUnselectCardSuccess()
    func multipayUnselectCardFailed(resultCode:String?, resultMessage: String?)
    
    //Single Wallet request delegate method
    
    func multipaySingleWalletSuccess(cardBalance:String?, cardImageUrl: String?, cardName: String?, walletToken: String?, cardMaskedNumber: String?)
    func multipaySingleWalletFailed(resultCode:String?, resultMessage: String?)
    
    //MARK: - Payment Delegates
    
    //Success
    func multipayPaymentDidSucceed(sign: String?, transferServerRefNo: String?)
    
    //Fail
    func multipayPaymentDidFail(error: Error?)
    
    //MARK: - Reversal Delegates
    
    //Success
    func multipayRollbackWithSignDidSucceed(sign: String?, rollbackServerReferenceNumber: String?)
    
    //Fail
    func multipayRollbackWithSignDidFail(error: ErrorModel?)
    
}


public class Multipay {
    
    private init() { }
    
    weak static var delegate: MultipayDelegate?
    
    static var testModeActive = false
    
    public class func start(vcToPresent: UIViewController, appToken: String, referenceNumber: String?, delegate:MultipayDelegate? = nil, languageCode: String? = nil, apiType: APIType = .prod, testMode: Bool = false, walletToken: String? = nil, obfuscationSalt: String)
    {
        Multipay.testModeActive = testMode
        Multipay.delegate = delegate
        
        CoreManager.start(vcToPresent: vcToPresent, appToken: appToken, referenceNumber: referenceNumber, languageCode: languageCode, apiType:apiType, walletToken: walletToken, obfuscationSalt: obfuscationSalt)
    }
    
    //MARK: SDK FUNCTIONS
    
    public class func callUnSelectWallet(delegate:MultipayDelegate, appToken: String, walletToken: String, languageCode: String = NSLocale.preferredLanguages[0], referenceNumber: String?, obfuscationSalt: String, testMode: Bool = false)
    {
        
        log.debug("callUnSelectWallet is called")
        
        Auth.obfuscationSalt = obfuscationSalt
        
        if testMode{
            delegate.multipayUnselectCardSuccess()
            return
        }
        
        var parameters = [appTokenKey : appToken.count > 0 ? appToken : Auth.appToken]
        parameters[newAppTokenKey] = appToken.count > 0 ? appToken : Auth.appToken
        parameters[languageCodeKey] = languageCode.count > 0 ? languageCode : "tr"
        parameters[walletTokenKey] = walletToken.count > 0 ? walletToken : Auth.walletToken
        if let referenceNmbr = referenceNumber{
            parameters[referenceNumberKey] = referenceNmbr
        }
        else if let referenceNumber = Auth.referenceNumber {
            parameters[referenceNumberKey] = referenceNumber
        }
        
        let requestId = UUID().uuidString.lowercased()
        parameters[requestIdKey] = requestId
        
        let service = ServiceConstants.ServiceName.SdkUnselectWallet
        
        ServiceInvokerHandler.sharedInstance.post(service,
                                                  isSdkService: true,
                                                  parameters: parameters as [String:AnyObject],
                                                  isCancelable: false,
                                                  applicationType: ServiceInvokerHandler.ServiceInvokerHandlerApplicationType.multiPay,
                                                  httpMethod: .post,
                                                  callback: {
                                                    (responseSuccess, rawData)  in
                                                    
                                                    DispatchQueue.main.async(execute: {
                                                        guard let response = responseSuccess, let resultCode = response[resultCodeKey] as? Int else {
                                                            delegate.multipayUnselectCardFailed(resultCode: responseSuccess?[resultCodeKey] as? String, resultMessage: responseSuccess?[resultMessageKey] as? String)
                                                            return }
                                                        
                                                        if resultCode == 0{
                                                            delegate.walletTokenExpired(expiredWalletToken: parameters[walletTokenKey] as? String)
                                                            delegate.multipayUnselectCardSuccess()
                                                        }
                                                        else{
                                                            delegate.multipayUnselectCardFailed(resultCode: responseSuccess?[resultCodeKey] as? String, resultMessage: responseSuccess?[resultMessageKey] as? String)
                                                        }
                                                    })
                                                  })
        { (responseFail, rawData) in
            
            log.error("error: \(responseFail)")
            
            DispatchQueue.main.async(execute: {
                
                delegate.multipayUnselectCardFailed(resultCode: responseFail.code, resultMessage: responseFail.description)
                
            })
        }
    }
    
    public class func callSingleWallet(delegate:MultipayDelegate, appToken: String, walletToken: String, languageCode: String = NSLocale.preferredLanguages[0], referenceNumber: String?, obfuscationSalt: String, testMode: Bool = false)
    {
        
        log.debug("callSingleWallet is called")
        
        Auth.obfuscationSalt = obfuscationSalt
        
        if testMode{
            let walletModelTest = WalletModelTest()
            delegate.multipaySingleWalletSuccess(cardBalance: walletModelTest.cardBalance, cardImageUrl: walletModelTest.cardImageUrl, cardName: walletModelTest.cardName, walletToken: walletModelTest.token, cardMaskedNumber: walletModelTest.cardNumber)
            return
        }
        
        var parameters = [appTokenKey : appToken.count > 0 ? appToken : Auth.appToken]
        parameters[newAppTokenKey] = appToken.count > 0 ? appToken : Auth.appToken
        parameters[languageCodeKey] = languageCode.count > 0 ? languageCode : "tr"
        parameters[walletTokenKey] = walletToken.count > 0 ? walletToken : Auth.walletToken
        if let referenceNmbr = referenceNumber{
            parameters[referenceNumberKey] = referenceNmbr
        }
        else if let referenceNumber = Auth.referenceNumber {
            parameters[referenceNumberKey] = referenceNumber
        }
        
        let requestId = UUID().uuidString.lowercased()
        parameters[requestIdKey] = requestId
        
        let service = ServiceConstants.ServiceName.SdkSingleWallet
        
        ServiceInvokerHandler.sharedInstance.post(service,
                                                  isSdkService: true,
                                                  parameters: parameters as [String:AnyObject],
                                                  isCancelable: false,
                                                  applicationType: ServiceInvokerHandler.ServiceInvokerHandlerApplicationType.multiPay,
                                                  httpMethod: .post,
                                                  callback: {
                                                    (responseSuccess, rawData)  in
                                                    
                                                    DispatchQueue.main.async(execute: {
                                                        guard let response = responseSuccess, let resultCode = response[resultCodeKey] as? Int else {
                                                            
                                                            delegate.walletTokenExpired(expiredWalletToken: parameters[walletTokenKey] as? String)
                                                            delegate.multipaySingleWalletFailed(resultCode: responseSuccess?[resultCodeKey] as? String, resultMessage: responseSuccess?[resultMessageKey] as? String)
                                                            return }
                                                        
                                                        if resultCode == 0, let rawData = rawData{
                                                            
                                                            do{
                                                                let modelObject = try rawData.decoded() as SingleWalletResponse
                                                                if let wallet = modelObject.result?.wallet{
                                                                    delegate.multipaySingleWalletSuccess(cardBalance: wallet.balance, cardImageUrl: wallet.image, cardName: wallet.name, walletToken: wallet.token, cardMaskedNumber: wallet.maskedNumber)
                                                                }
                                                            }
                                                            catch{
                                                                delegate.walletTokenExpired(expiredWalletToken: parameters[walletTokenKey] as? String)
                                                                delegate.multipaySingleWalletFailed(resultCode: responseSuccess?[resultCodeKey] as? String, resultMessage: responseSuccess?[resultMessageKey] as? String)
                                                                print("error: \(error)")
                                                            }
                                                            
                                                        }
                                                        else{
                                                            delegate.walletTokenExpired(expiredWalletToken: parameters[walletTokenKey] as? String)
                                                            delegate.multipaySingleWalletFailed(resultCode: responseSuccess?[resultCodeKey] as? String, resultMessage: responseSuccess?[resultMessageKey] as? String)
                                                        }
                                                    })
                                                  })
        { (responseFail, rawData) in
            
            log.error("error: \(responseFail)")
            
            DispatchQueue.main.async(execute: {
                delegate.walletTokenExpired(expiredWalletToken: parameters[walletTokenKey] as? String)
                delegate.multipaySingleWalletFailed(resultCode: responseFail.code, resultMessage: responseFail.description)
            })
        }
    }
    
    //MARK: CONFIRM PAYMENT
    
    public class func callConfirmPayment(delegate:MultipayDelegate, paymentAppToken: String, languageCode: String = NSLocale.preferredLanguages[0], requestId: String, walletToken: String, merchantReferenceNumber: String, terminalReferenceNumber:String, transferReferenceNumber:String, transactionDetails: [TransactionDetailModel], sign:String, obfuscationSalt: String, testMode: Bool = false)
    {
        
        log.debug("callConfirmPayment is called")
        
        Auth.obfuscationSalt = obfuscationSalt
        
        if testMode{
            delegate.multipayPaymentDidSucceed(sign: nil, transferServerRefNo: nil)
            return
        }
        
        var parameters:[String:AnyObject] = [:]
        
        parameters[paymentAppTokenKey] = paymentAppToken as AnyObject
        parameters[languageCodeKey] = (languageCode.count > 0 ? languageCode : "tr") as AnyObject
        parameters[requestIdKey] = requestId as AnyObject
        parameters[walletTokenKey] = (walletToken.count > 0 ? walletToken : Auth.walletToken) as AnyObject
        parameters[merchantReferenceNumberKey] = merchantReferenceNumber as AnyObject
        parameters[terminalReferenceNumberKey] = terminalReferenceNumber as AnyObject
        parameters[transferReferenceNumberKey] = transferReferenceNumber as AnyObject
        
        var transactionDetailArrayDict:[[String:Any]] = []
        
        for transDetailModel in transactionDetails{
            var dict = ["amount" : transDetailModel.amount as String]
            dict["productId"] = transDetailModel.productId  as String
            dict["referenceNumber"] = transDetailModel.referenceNumber  as String
            transactionDetailArrayDict.append(dict)
        }
        
        parameters[transactionDetailsKey] = transactionDetailArrayDict as AnyObject
        parameters[signKey] = sign as AnyObject
        
        let service = ServiceConstants.ServiceName.SdkPaymentConfirm
        
        ServiceInvokerHandler.sharedInstance.post(service,
                                                  isSdkService: true,
                                                  parameters: parameters,
                                                  isCancelable: false,
                                                  applicationType: ServiceInvokerHandler.ServiceInvokerHandlerApplicationType.multiPay,
                                                  httpMethod: .post,
                                                  sendRequestIdToRequestsParam: false,
                                                  callback: {
                                                    (responseSuccess, rawData)  in
                                                    
                                                    DispatchQueue.main.async(execute: {
                                                        
                                                        if let rawData = rawData{
                                                            do{
                                                                let modelObject = try rawData.decoded() as PaymentConfirmResponseModel
                                                                if let resultCode = modelObject.resultCode, resultCode == 0{
                                                                    delegate.multipayPaymentDidSucceed(sign: modelObject.result?.sign, transferServerRefNo: modelObject.result?.transferServerReferenceNumber)
                                                                }
                                                                else{
                                                                    delegate.multipayPaymentDidFail(error: nil)
                                                                }
                                                            }
                                                            catch{
                                                                print("error: \(error)")
                                                                delegate.multipayPaymentDidFail(error: error)
                                                            }
                                                        }
                                                    })
                                                  })
        { (responseFail, rawData) in
            
            log.error("error: \(responseFail)")
            
            delegate.multipayPaymentDidFail(error: responseFail as? Error)
        }
    }
    
    //MARK: PAYMENT Reversal
    
    public class func callPaymentReversal(delegate:MultipayDelegate, paymentAppToken: String, languageCode: String = NSLocale.preferredLanguages[0], requestId: String, sign:String, merchantRefNo:String, terminalRefNo:String, rollbackReferenceNumber:String, reason:ReferenceToRollbackModel.ReasonRollback, referenceNumberType: ReferenceToRollbackModel.ReferenceNumberType, referenceNumber: String, obfuscationSalt: String, testMode: Bool = false)
    {
        
        log.debug("callPaymentReversal is called")
        
        Auth.obfuscationSalt = obfuscationSalt
        
        if testMode{
            delegate.multipayRollbackWithSignDidSucceed(sign: nil, rollbackServerReferenceNumber: nil)
            return
        }
        
        var parameters:[String:AnyObject] = [:]
        
        parameters[paymentAppTokenKey] = paymentAppToken as AnyObject
        
        parameters[languageCodeKey] = (languageCode.count > 0 ? languageCode : "tr") as AnyObject
        
        parameters[requestIdKey] = requestId as AnyObject
        
        parameters[signKey] = sign as AnyObject

        parameters[merchantReferenceNumberKey] = merchantRefNo as AnyObject
        
        parameters[terminalReferenceNumberKey] = terminalRefNo as AnyObject
        
        parameters[rollbackReferenceNumberKey] = rollbackReferenceNumber as AnyObject
        
        parameters[reasonKey] = reason.rawValue as AnyObject
        
        parameters[ReferenceToRollbackModel.referenceNumberTypeKey] = referenceNumberType.rawValue as AnyObject
        
        parameters[referenceNumberKey] = referenceNumber as AnyObject
        
        let service = ServiceConstants.ServiceName.SdkRollbackPayment
        
        log.debug("callPaymentReversal parameters: \(parameters)")
        
        ServiceInvokerHandler.sharedInstance.post(service,
                                                  isSdkService: true,
                                                  parameters: parameters,
                                                  isCancelable: false,
                                                  applicationType: ServiceInvokerHandler.ServiceInvokerHandlerApplicationType.multiPay,
                                                  httpMethod: .post,
                                                  sendRequestIdToRequestsParam: false,
                                                  callback: {
                                                    (responseSuccess, rawData)  in
                                                    
                                                    DispatchQueue.main.async(execute: {
                                                        
                                                        if let rawData = rawData{
                                                            do{
                                                                let modelObject = try rawData.decoded() as RollbackPaymentResponseModel
                                                                if let resultCode = modelObject.resultCode, resultCode == 0{
                                                                    delegate.multipayRollbackWithSignDidSucceed(sign: modelObject.result?.sign, rollbackServerReferenceNumber: modelObject.result?.rollbackServerReferenceNumber)
                                                                }
                                                                else{
                                                                    
                                                                    let errorModel = ErrorModel(code: "", message: "result code is not 0!")
                                                                    
                                                                    delegate.multipayRollbackWithSignDidFail(error: errorModel)
                                                                }
                                                            }
                                                            catch{
                                                                print("error: \(error)")
                                                                
                                                                let errorModel = ErrorModel(code: "Parse error", message: error.localizedDescription)
                                                                
                                                                delegate.multipayRollbackWithSignDidFail(error: errorModel)
                                                            }
                                                        }
                                                    })
                                                  })
        {  (responseFail, rawData) in
            
            log.error("callPaymentReversal error description: \(responseFail.description)")
            
            DispatchQueue.main.async(execute: {
                
                var jsonDict: [String:AnyObject] = [:]
                
                if let rawData = rawData{
                    do {
                        jsonDict = try JSONSerialization.jsonObject(with: rawData, options: .mutableContainers) as? [String:AnyObject] ?? [:]
                    } catch {
                        print("Something went wrong")
                    }
                }
                
                let resultCode = jsonDict["resultCode"] as? Int
                
                var message = responseFail.description
                
                if let resultMessage = jsonDict["resultMessage"]{
                        message = resultMessage as! String
                }
                    
                let errorModel = ErrorModel(code: String(resultCode ?? -999), message: message)
                
                delegate.multipayRollbackWithSignDidFail(error: errorModel)
            })
            
        }
    }
}
