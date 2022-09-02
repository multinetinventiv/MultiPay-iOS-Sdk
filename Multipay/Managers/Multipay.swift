//
//  Multipay.swift
//  Multipay
//
//  Created by ilker sevim on 2.10.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation

public protocol MultipayDelegate : AnyObject {
    
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
    
    static var offlineModeActive = false
    
    public class func start(vcToPresent: UIViewController, walletAppToken: String, referenceNumber: String?, delegate: MultipayDelegate? = nil, language: Language? = nil, environment: Environment = .production, offlineMode: Bool = false, walletToken: String? = nil, obfuscationKey: String, userPreset: UserPreset? = nil) {
        Multipay.offlineModeActive = offlineMode
        Multipay.delegate = delegate
        
        CoreManager.start(vcToPresent: vcToPresent, appToken: walletAppToken, referenceNumber: referenceNumber, languageCode: language?.rawValue ?? NSLocale.preferredLanguages[0], environment: environment, walletToken: walletToken, obfuscationKey: obfuscationKey, userPreset: userPreset)
    }
    
    //MARK: SDK FUNCTIONS
    
    public class func callUnSelectWallet(delegate: MultipayDelegate, walletAppToken: String, walletToken: String, language: Language? = nil, referenceNumber: String?, obfuscationKey: String, offlineMode: Bool = false) {
        
        LoggerHelper.logger.debug("callUnSelectWallet is called")
        
        Auth.obfuscationKey = obfuscationKey
        
        if offlineMode{
            delegate.multipayUnselectCardSuccess()
            return
        }
        
        var parameters = [walletAppTokenKey : walletAppToken.count > 0 ? walletAppToken : Auth.walletAppToken]
        parameters[languageCodeKey] = CoreManager.getLocaleIdentifier(language: language)
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
            
            LoggerHelper.logger.error("error: \(responseFail)")
            
            DispatchQueue.main.async(execute: {
                delegate.multipayUnselectCardFailed(resultCode: responseFail.code, resultMessage: responseFail.description)
            })
        }
    }
    
    public class func getWallet(delegate:MultipayDelegate, walletAppToken: String, walletToken: String, language: Language? = nil, referenceNumber: String?, obfuscationKey: String, offlineMode: Bool = false) {
        
        LoggerHelper.logger.debug("callSingleWallet is called")
        
        Auth.obfuscationKey = obfuscationKey
        
        if offlineMode{
            let walletModelTest = WalletModelTest()
            delegate.multipaySingleWalletSuccess(cardBalance: walletModelTest.cardBalance, cardImageUrl: walletModelTest.cardImageUrl, cardName: walletModelTest.cardName, walletToken: walletModelTest.token, cardMaskedNumber: walletModelTest.cardNumber)
            return
        }
        
        var parameters = [walletAppTokenKey : walletAppToken.count > 0 ? walletAppToken : Auth.walletAppToken]
        parameters[languageCodeKey] = CoreManager.getLocaleIdentifier(language: language)
        
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
            
            LoggerHelper.logger.error("error: \(responseFail)")
            
            DispatchQueue.main.async(execute: {
                delegate.walletTokenExpired(expiredWalletToken: parameters[walletTokenKey] as? String)
                delegate.multipaySingleWalletFailed(resultCode: responseFail.code, resultMessage: responseFail.description)
            })
        }
    }
    
    //MARK: CONFIRM PAYMENT
    
    public class func callConfirmPayment(delegate: MultipayDelegate, paymentAppToken: String, language: Language? = nil, requestId: String, walletToken: String, merchantReferenceNumber: String, terminalReferenceNumber: String, transferReferenceNumber: String, transactionDetails: [TransactionDetailModel], sign: String, obfuscationKey: String, offlineMode: Bool = false)
    {
        
        LoggerHelper.logger.debug("callConfirmPayment is called")
        
        Auth.obfuscationKey = obfuscationKey
        
        if offlineMode{
            delegate.multipayPaymentDidSucceed(sign: nil, transferServerRefNo: nil)
            return
        }
        
        var parameters:[String:AnyObject] = [:]
        
        parameters[paymentAppTokenKey] = paymentAppToken as AnyObject
        parameters[languageCodeKey] = CoreManager.getLocaleIdentifier(language: language) as AnyObject
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
                                                                else if let resultCode = modelObject.resultCode{
                                                                    let errorTemp = NSError(domain:"", code: resultCode, userInfo: [NSLocalizedDescriptionKey: modelObject.resultMessage ?? ""])
                                                                    delegate.multipayPaymentDidFail(error: errorTemp)
                                                                }else if let resultMessage = modelObject.resultMessage{
                                                                    let errorTemp = NSError(domain:"", code: -999, userInfo: [NSLocalizedDescriptionKey: resultMessage])
                                                                    delegate.multipayPaymentDidFail(error: errorTemp)
                                                                }else{
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
            
            LoggerHelper.logger.error("error: \(responseFail)")
            
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
                
                var message = "Bilinmeyen bir hata oluştu!"
                
                if let resultMessage = jsonDict["resultMessage"] as? String{
                    message = resultMessage
                }
                
                let error = NSError(domain:"", code: resultCode ?? -999, userInfo: [NSLocalizedDescriptionKey: message ])
                
                delegate.multipayPaymentDidFail(error: error)
            })
        }
    }
    
    //MARK: PAYMENT Reversal
    
    public class func rollbackPayment(delegate: MultipayDelegate, paymentAppToken: String, language: Language? = nil, requestId: String, sign: String, merchantReferenceNumber: String, terminalReferenceNumber: String, rollbackReferenceNumber: String, reason: ReferenceToRollbackModel.ReasonRollback, referenceNumberType: ReferenceToRollbackModel.ReferenceNumberType, referenceNumber: String, obfuscationKey: String, offlineMode: Bool = false) {
        
        LoggerHelper.logger.debug("callPaymentReversal is called")
        
        Auth.obfuscationKey = obfuscationKey
        
        if offlineMode{
            delegate.multipayRollbackWithSignDidSucceed(sign: nil, rollbackServerReferenceNumber: nil)
            return
        }
        
        var parameters:[String:AnyObject] = [:]
        
        parameters[paymentAppTokenKey] = paymentAppToken as AnyObject
        
        parameters[languageCodeKey] = CoreManager.getLocaleIdentifier(language: language) as AnyObject
        
        parameters[requestIdKey] = requestId as AnyObject
        
        parameters[signKey] = sign as AnyObject

        parameters[merchantReferenceNumberKey] = merchantReferenceNumber as AnyObject
        
        parameters[terminalReferenceNumberKey] = terminalReferenceNumber as AnyObject
        
        parameters[rollbackReferenceNumberKey] = rollbackReferenceNumber as AnyObject
        
        parameters[reasonKey] = reason.rawValue as AnyObject
        
        parameters[ReferenceToRollbackModel.referenceNumberTypeKey] = referenceNumberType.rawValue as AnyObject
        
        parameters[referenceNumberKey] = referenceNumber as AnyObject
        
        let service = ServiceConstants.ServiceName.SdkRollbackPayment
        
        LoggerHelper.logger.debug("callPaymentReversal parameters: \(parameters)")
        
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
            
            LoggerHelper.logger.error("callPaymentReversal error description: \(responseFail.description)")
            
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
