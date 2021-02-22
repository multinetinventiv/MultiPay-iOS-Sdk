
//
//  Card.swift
//  MultiU
//
//  Created by  on 07/06/16.
//  Copyright © 2016 . All rights reserved.
//

import Foundation
import XCGLogger

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}


//MARK: - Enums

enum ProductionType: Int {
    case physical = 1
    case virtual = 2
}

enum ProductType:Int {
    case restoNetKls = 1
    case petroNetKls
    case execuNetKls
    
    case caterNet
    case bireyselKls
    case multiAvantaj = 8
    
    case otelNet
    case cutomerID
    case restoNetKrd = 15
    
    case vendiNetKls = 12
    case temsil = 21
    case ikram
    case multiAvantajBusiness
    
    //Otomisyon Kartları
    case icDisBinek = 28
    case disBinek = 29
    case icBakimBinek = 30
    case detIcBakimBinek = 31
    case disBakimBinek = 32
    case disKorumaBinek = 33
    case fullBakimBinek = 34
    case icDisSUV = 35
    case disSUV = 36
    case icBakimSUV = 37
    case detIcBakimSUV = 38
    case disBakimSUV = 39
    case disKorumaSUV = 40
    case fullBakimSUV = 41
    
    case gift = 99
    case non = 1099
    
    case addCard = 9999
}

enum TrxLoadType:Int {
    case loadInit
    case loadNext
    case forceToLoad
}

enum ProcessType:String {
    
    case Undefined = "Undefined"
    case Loading = "Loading"
    case CorporateLoading = "CorporateLoading"
    case IndividualLoading = "IndividualLoading"
    case BonusLoading = "BonusLoading"
    case Expenditure = "Expenditure"
    case Withdraw  = "Withdraw"
    case Cancel = "Cancel"
    case MoneyTransferEntry = "MoneyTransferEntry"
    case MoneyTransferOut = "MoneyTransferOut"
    
    func getColor() -> UIColor {
        switch self {
        case .Loading:
            return ColorPalette.cardTransaction.Loading
        case .CorporateLoading:
            return ColorPalette.cardTransaction.CorporateLoading
        case .IndividualLoading:
            return ColorPalette.cardTransaction.IndividualLoading
        case .BonusLoading:
            return ColorPalette.cardTransaction.BonusLoading
        case .Expenditure:
            return ColorPalette.cardTransaction.Expenditure
        case .Withdraw:
            return ColorPalette.cardTransaction.Withdraw
        case .Cancel:
            return ColorPalette.cardTransaction.Cancel
        case .MoneyTransferOut:
            return ColorPalette.cardTransaction.MoneyTransferOut
        case .MoneyTransferEntry:
            return ColorPalette.cardTransaction.MoneyTransferEntry
        case .Undefined:
            return ColorPalette.cardTransaction.Undefined
        }
    }
    
    func getImageName() -> String {
        
        switch self {
        case .Loading:
            return "loading"
        case .CorporateLoading:
            return "loading"
        case .IndividualLoading:
            return "loading"
        case .BonusLoading:
            return "BonusLoading"
        case .Expenditure:
            //burada sectore  göre imaj döneceğiz
            return ""
        case .Withdraw:
            return  "withdrawal"
        case .Cancel:
            return "cancel"
        case .MoneyTransferOut:
            return "cancel"
        case .MoneyTransferEntry:
            return "loading"
        case .Undefined:
            return "undefined"
        }
    }
}


//MARK: - Structs

struct Product {
    var productId:Int?
    var productName:String?
    var productImageUrl:String?
    var productType:ProductType = .non
    let productImagePlaceHolderImageName: String = "restonet"
}

struct CardHelper {
    static let kMobileMaxLimitPerDay = "MaxSaleLimitPerDay"
    static let kMobileMaxLimitPerSale = "MaxSaleLimitPerTransaction"
    static let kAvailableForMobileSale = "AvailableForSale"
    
}

struct ChannelLimit {
    
    var amount:String = "0"
    var currency = ""
    var displayValue = ""
    
    func getAmount() -> String {
        return amount.asLocaleCurrency
    }
    
    func getAmountInDouble() -> Double {
        
        if (self.amount.length > 0 )
        {
            return Double(self.amount)!
            
        }
        return 0.0
    }
    
}


//MARK: - Card
class Card :BaseModel{
    
    var customerId: Int?
    var cardID :String?
    var cardNo :String?
    var ownerName:String = ""
    var product:Product?
    var dailyTotalLimit  = ChannelLimit()
    var oneTimeSpendLimit = ChannelLimit ()
    var productionType:ProductionType = .physical
    
    var isBlocked: Bool = false
    var isUnblockable: Bool = false
    var isPayable :Bool = true
    var availableForSale = false
    var hasOnlineSalePermission:Bool = false
    var isTopupable: Bool = false
    var IsTopupOrderEnabled: Bool = false
    
    var index : Int = -1
    var pageNumber : Int = 0
    
    var tobeContinue : Bool = false
    var isLoadTrxServiceRunning = false
    
    fileprivate var waitingBalance  = ""
    fileprivate var waitingBalanceDisplayValue  = ""
    
    var balance  = ""
    var currency = ""
    var sign = ""
    var balanceDisplayValue = ""{
        didSet {
            self.balanceUpdate =  balance  == "" ? nil : Date()
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.Notifications.CardBalanceLoadedNotification), object: self)
        }
    }
    var isCountable: String?
    
    fileprivate var balanceUpdate:Date? = nil
    
    
    var trxs :[Transactions]? {
        didSet {
            self.isLoadTrxServiceRunning = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.Notifications.CardTrxNotification), object: self)
        }
    }
    
    var  userRewardAmountDisplayValue:String? {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.Notifications.RewardsLoadedotification), object: self)
        }
    }
    fileprivate var  userRewardAmount:String?
    
    
    //MARK: Init
    
    override init() {
        super.init()
    }
    
    
    class func cards(_ result:AnyObject?) -> [Card] {
        
        var cards = [Card]()
        
        let cardList = result as? [[String:AnyObject]]
        
        
        guard let list = cardList, cardList?.count > 0 else {
            return cards
        }
        
        var i = 0
        
        for (index, item) in list.enumerated() {
            
            let card = Card()
            
            card.customerId = item["CustomerId"] as? Int
            card.index = index
            card.cardID = item["CardId"] as? String
            card.cardNo = item["CardNumber"] as? String
            card.isPayable = (item["IsPayable"] as? Bool) ?? false
            card.ownerName = item["OwnerName"] as? String ?? ""
            card.isTopupable = item["IsTopupable"] as? Bool ?? false
            card.IsTopupOrderEnabled = item["IsTopupOrderEnabled"] as? Bool ?? false
            card.isBlocked = item["IsBlocked"] as? Bool ?? false
            card.isUnblockable = item["Unblockable"] as? Bool ?? false
            
            if let productionType = item["ProductionType"] as? Int {
                card.productionType = ProductionType(rawValue: productionType)!
            }
            
            //Product
            var product = Product()
            product.productId = item["ProductId"] as? Int
            product.productName = item["ProductDescription"] as? String
            product.productImageUrl = item["ImageUrl"] as? String
            
            if let a = ProductType(rawValue: product.productId!) {
                product.productType = a
            }
            
            card.product = product
            
            //Company Check
            var hasOnlineSalePermission =  false
            if let onlineSalePermission = item["HasOnlineSalePermission"] as? Bool { //Firma izni
                hasOnlineSalePermission = onlineSalePermission
            }
            card.hasOnlineSalePermission = hasOnlineSalePermission
            
            
            //Available Check
            card.availableForSale = (item["AvailableForSale"] as? Bool) ?? false //Kartın online ödeme izni (OCY)
            
            
            //TekSeferlik Limit
            let limitOneTime = getChannelLimit(CardHelper.kMobileMaxLimitPerSale, data: item)
            if(limitOneTime != nil ){
                card.oneTimeSpendLimit = limitOneTime!
            }
            
            //Günlük Limit
            let limitPerDay = getChannelLimit(CardHelper.kMobileMaxLimitPerDay, data: item)
            if(limitPerDay != nil ){
                card.dailyTotalLimit = limitPerDay!
            }
            
            
            if let balanceObj = item["Balance"]
            {
                if let currency = balanceObj["Currency"] {
                    card.currency = ((currency as? String)?.removeWhitespace())!
                }
                
                if let sign = balanceObj["Sign"] {
                    card.sign = (sign as? String)!
                    
                }
                
                if let money = balanceObj["Money"] {
                    card.balance = "\(money!)"
                    
                }
                
                if let displayValue = balanceObj["DisplayValue"] {
                    card.balanceDisplayValue = (displayValue as? String)!
                }
                
                if let isCountable = balanceObj["IsCountable"]{
                    card.isCountable = isCountable as? String
                }
            }
            
            if let balanceObj = item["WaitingBalance"]
            {
                if let money = balanceObj["Money"] {
                    card.waitingBalance = "\(money!)"
                }
                
                if let displayValue = balanceObj["DisplayValue"] {
                    card.waitingBalanceDisplayValue = (displayValue as? String)!
                }
            }
            
            
            cards.append(card)
            
            i += 1
        }
        
        cards = self.orderCardsByUserChoice(cards: cards)
        return cards
    }
    
    class func orderCardsByUserChoice(cards: [Card]) -> [Card] {
        var sortedCardList =  [Card]()
        
        if let ss = loadObjectFromUserDefaults(LocalStorageKeys.kCardOrderByUserChoice){
            let sortedArry = ss as! [String]
            for (_,item) in sortedArry.enumerated(){
                let cc = cards.filter({$0.getCardUniqeHash() == item})
                if !cc.isEmpty{
                    sortedCardList.append(contentsOf: cc)
                }
            }
        }else{
            let cc = cards.filter({$0.isRestonet() == true})
            if !cc.isEmpty{
                sortedCardList.append(contentsOf: cc)
            }
        }
        sortedCardList.mergeElements(newElements: cards)
        
        
        return sortedCardList
    }
    
    //MARK: Getters
    
    func getUpdateTime() -> String? {
        
        if(balanceUpdate != nil) {
            return DateManager().timeAgoSince(date: self.balanceUpdate! as NSDate, numericDates: true)
        }
        
        return nil
    }
    
    
    
    func getTransactions() -> [Transactions]? {
        
        loadTransactions()
        
        return nil
    }
    
    class func getToDayString() -> String
    {
        let formatter = CoreManager.dateFromatter(formatStr: "yyyyMMdd")
        let dateStr = formatter.string(from: Date())
        return dateStr
    }
    
    
    func pageNumberStr() -> String
    {
        return String(pageNumber + 1)
    }
    
    
    func getNewTransactions(_ loadType:TrxLoadType = .loadInit) {
        
        if(TrxLoadType.forceToLoad == loadType) {
            pageNumber = 0
        }
        
        loadNewTransactions(pageNumberStr(),loadType: loadType)
        
    }
    
    func getLoadedTransactions() -> [Transactions]? {
        
        return trxs
    }
    
    func getCardID() -> String
    {
        
        guard let cardID = self.cardID else{
            return ""
        }
        return cardID
    }
    
    func getCardNumber() -> String
    {
        
        guard let cardNo = self.cardNo else{
            return ""
        }
        return cardNo
    }
    
    func getFormatedCardNumber() -> String {
        
        guard let cardNo = self.cardNo else{
            return ""
        }
        
        let card = self.product?.productType != .addCard ? cardNo.mask(4, to: 5) : cardNo
        return card.codeFormat()
    }
    
    func getProductID() -> Int {
        return (product?.productId) ?? 0
    }
    
    func getProductName() -> String {
        
        return (self.product?.productName)!
    }
    
    func getIsBlocked() -> Bool {
        return self.isBlocked
    }
    
    func getIsUnblockable() -> Bool {
        return self.isUnblockable
    }
    
    func  getOneTimeLimit() -> ChannelLimit {
        return oneTimeSpendLimit
    }
    
    func  getDailyLimit() -> ChannelLimit {
        return dailyTotalLimit
    }
    
    func getCardUniqeHash() -> String{ //  kartın eşitlik durumları vs için bu hash kullanılmalı. aynı cardID veya productId olabilir. ancak her ikisi aynı olamaz.
        var cardId = ""
        var productId = ""
        if let cardID = self.cardID {
            cardId = cardID
        }
        if let pId = self.product?.productId{
            productId = String(pId)
        }
        return cardId + productId
    }
    
    //MARK: Controls
    
    func isRestonet() -> Bool {
        return product?.productType == .restoNetKls && self.productionType == .physical
    }
    
    func isVirtualCard() -> Bool {
        return self.productionType == .virtual
    }
    
    func isPayButtonEnabled() -> Bool {
        if self.product?.productType == ProductType.addCard {
            return false
        }
        
        return self.isPayable
    }
    
    func isHowToPayButtonEnabled() -> Bool {
        if self.product?.productType == ProductType.addCard {
            return false
        }
        
        return self.isVirtualCard() && !self.isPayable
    }
    
    func isManageButtonEnabled() -> Bool {
        if self.product?.productType == ProductType.addCard {
            return false
        }
        
        if self.productionType == .physical || self.isPayable{
            return true
        }
        
        return false
    }
    
    func isTopupButtonEnabled() -> Bool {
        if self.product?.productType == ProductType.addCard {
            return false
        }
        
        return self.isTopupable
    }
    
    func isTopupOrderButtonEnabled() -> Bool {
        if self.product?.productType == ProductType.addCard {
            return false
        }
        
        return self.IsTopupOrderEnabled
    }
    
    func managementIndividualLoadingOrderVisible() -> Bool {
        return isTopupOrderButtonEnabled()
    }
    
    func managementLostCardVisible() -> Bool {
        return !self.isVirtualCard()
    }
    
    func managementDeleteCardVisible() -> Bool {
        return !self.isVirtualCard()
    }
    
    func balanceTitle() -> String {
        //Otomisyon
        if product?.productType.rawValue >= 28 && product?.productType.rawValue <= 40 {
            return Localization.WalletAvailableLimit.local
        }
        
        //Temsil
        if product?.productType == ProductType.temsil {
            return Localization.WalletAvailableLimit.local
        }
        
        return Localization.WalletAvailableBalance.local
    }
    
    func waitinigBalanceTitle() -> String {
        //Otomisyon
        if product?.productType.rawValue >= 28 && product?.productType.rawValue <= 40 {
            return Localization.WalletWaitingLimit.local
        }
        
        //Temsil
        if product?.productType == ProductType.temsil {
            return Localization.WalletWaitingLimit.local
        }
        
        return Localization.WalletWaitingBalance.local
    }
    
    func noDataFoundText () ->String {
        return ProductType.gift == product?.productType ? "GIFT_TRX_MESSAGE".local : Localization.CommonInfoNoDataFound.local
    }
    
    func updateBalance(_ amount:String?, force:Bool = false) {
        
        guard let theAmount = amount, amount != nil
        else {
            if(force) {
                self.balance = ""
                self.balanceUpdate = nil
            }
            return
        }
        
        self.balance = theAmount
        
    }
    
    func getBalanceWithCurrency() -> String? {
        
        if (balanceUpdate == nil || balance.isEmpty){
            loadBalance()
            return  nil
        }else
        {
            let interval = Date().timeIntervalSince(self.balanceUpdate!)
            if ( interval <= 15 * 60 ) {
                if(balanceDisplayValue != "") {
                    return balanceDisplayValue
                }else{
                    return balance.asLocaleCurrency + " " + currency
                }
            }else{
                loadBalance()
                return  nil
            }
        }
    }
    
    func getWaitingBalanceWithCurrency() -> String {
        
        //Gelen Bakiye 0 mı?
        if (waitingBalance.isEmpty || waitingBalance == "0"){
            return  ""
        }
        
        //Değilse DisplayValue gösterilir.
        return waitingBalanceDisplayValue
    }
    
    
    func hasUserRewardLoaded() -> Bool{
        
        guard let _ = userRewardAmount, userRewardAmount != nil else {
            return false
        }
        return true
    }
    
    func hasUserReward() -> Bool{
        guard let award = userRewardAmount, userRewardAmount != nil else {
            return false
        }
        return award.length > 0 && Double(award) > 0
    }
    
    
    func getBalanceDisplayValue() -> String {
        
        if (self.balance.length > 0 )
        {
            if(balanceDisplayValue != "") {
                return self.balanceDisplayValue
            }else{
                return self.balance.asLocaleCurrency + " " + self.currency
            }
            
        }
        return ""
    }
    
    func getBalance() -> Double {
        
        if (self.balance.length > 0 )
        {
            return Double(self.balance)!
            
        }
        return 0.0
    }
    
    class  func getChannelLimit (_ key:String, data:[String:AnyObject]) -> ChannelLimit? {
        
        if let keyData = data[key] {
            
            var money = ""
            var currency = ""
            var displayValue = ""
            if let themoney = keyData["Money"] {
                money = themoney as! String
            }
            
            if let thecurrency = keyData["Currency"] {
                currency = thecurrency as! String
            }
            
            if let thedisplayValue = keyData["DisplayValue"] {
                displayValue = thedisplayValue as! String
            }
            
            return  ChannelLimit(amount: money, currency: currency, displayValue: displayValue)
        }
        return nil
        
    }
    
    //MARK: Functions
    class func  updateCardForPay(_ cardNumber:String,openToPay:Bool,dailyLimit:String,oneTimeLimit:String) {
        
        let card = CoreManager.Instance().getCard(cardNumber: cardNumber)
        card?.availableForSale = openToPay
        card?.oneTimeSpendLimit.amount = oneTimeLimit
        card?.dailyTotalLimit.amount = dailyLimit
    }
    
    class func createAddCard() -> Card {
        let card = Card()
        card.cardNo = ""
        card.isPayable = false
        
        var product = Product()
        product.productName = "Card To Add"
        product.productType = .addCard
        card.product = product
        
        return card
    }
    
    
    
    //MARK: Requests
    fileprivate func loadBalance() -> Void {
        
        let cardData : [String : Any] = [
            "CardId" : self.getCardID(),
            "CardProductId" : self.getProductID()
        ]
        
        let parameters = ["walletInfo" : cardData]
        
        post(ServiceConstants.ServiceName.GetWalletBalance,  parameters: parameters as [String : AnyObject],   displayError: false, displaySpinner: false, callback:
                {
                    
                    [weak self](data:[String:AnyObject]?, rawData)
                    in
                    if let strongSelf = self
                    {
                        let resData = data as [String : Any]?
                        
                        if let data  = resData {
                            
                            log.debug("data : \(data)")
                            
                            let theCode =  data[resultCodeKey]
                            
                            guard let _ = theCode, theCode as! Int == 0 else {
                                strongSelf.balance = ""
                                return
                            }
                            
                            guard let result = data[resultKey] as! [String : Any]? else{
                                strongSelf.balance = ""
                                strongSelf.currency = ""
                                strongSelf.sign = ""
                                return
                            }
                            
                            guard let balanceDictionary = result["Balance"] as! [String : Any]? else{
                                strongSelf.balance = ""
                                strongSelf.currency = ""
                                strongSelf.sign  = ""
                                return
                            }
                            
                            
                            if let currency = balanceDictionary["Currency"] {
                                strongSelf.currency = ((currency as? String)?.removeWhitespace())!
                                
                            }
                            
                            if let sign = balanceDictionary["Sign"] {
                                strongSelf.sign = (sign as? String)!
                                
                            }
                            
                            if let money = balanceDictionary["Money"] {
                                strongSelf.balance = "\(money)"
                                
                            }
                            
                            if let displayValue = balanceDictionary["DisplayValue"] {
                                strongSelf.balanceDisplayValue = (displayValue as? String)!
                            }
                        }
                    }
                    
                },errorCallback: {
                    [weak self] (data: ErrorModel, rawData) in
                    
                    if let strongSelf = self {
                        strongSelf.balance = ""
                        strongSelf.currency = ""
                        
                    }
                })
    }
    
    fileprivate func loadTransactions() -> Void
    {
        
        if (Config.LOCAL) {
            
            if ServiceConstants.LocalService.isAvaliableToLocal(ServiceConstants.ServiceName.GetCardTransactions)
            {
                
                guard let filePath = Bundle.main.path(forResource: ServiceConstants.ServiceName.GetCardTransactions, ofType: "json") else {
                    
                    log.error("\(ServiceConstants.ServiceName.GetCardTransactions)  json not found")
                    _ = ErrorModel(result: REGUEST_ERROR_CODE, code: REGUEST_ERROR_CODE, message: "\(ServiceConstants.ServiceName.GetCardTransactions)  json file read error ", additionalData: nil)
                    self.trxs = nil
                    return
                    
                }
                
                log.debug("filePath :\(filePath)");
                
                do {
                    let content = try String(contentsOfFile:filePath, encoding: String.Encoding.utf8)
                    let fileContent = content.data(using: String.Encoding.utf8)
                    
                    let json = try JSONSerialization.jsonObject(with: fileContent!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                    
                    guard let result = json[resultKey]  else{
                        self.trxs = nil
                        return
                    }
                    
                    
                    self.processUserRewardAmount(result["UserRewardAmount"] as AnyObject)
                    
                    guard let wallets = result["WalletTransactions"] as AnyObject? else{
                        self.trxs = nil
                        return
                    }
                    
                    guard let trx = wallets["Transactions"] as AnyObject? else{
                        self.trxs = nil
                        return
                    }
                    
                    self.trxs = Transactions.createTrx(trx)
                } catch _ as NSError {
                    log.error("\(ServiceConstants.ServiceName.GetCardTransactions)  json file read error ")
                    self.trxs = nil
                    return
                }
                
            }
            
            return
        }
        
        
        
        
        
        
        let cardTransactionInfo : [String: Any] = ["CardId"   :self.getCardID(),
                                                   "CardProductId": self.getProductID()]
        
        let parameters = [ "walletInfo": cardTransactionInfo ]
        
        post(ServiceConstants.ServiceName.GetCardTransactions,  parameters: parameters as [String : AnyObject] ,   displayError: false, displaySpinner: false, callback:
                {
                    
                    [weak self](data:[String:AnyObject]?, rawData)
                    
                    in
                    if let strongSelf = self
                    {
                        if let data  = data {
                            
                            log.debug("data : \(data)")
                            
                            let theCode =  data[resultCodeKey]
                            
                            guard let _ = theCode, theCode as! Int == 0 else {
                                strongSelf.trxs = nil
                                return
                            }
                            
                            guard let result = data[resultKey]  else{
                                strongSelf.trxs = nil
                                return
                            }
                            
                            strongSelf.trxs = Transactions.createTrx(result)
                            
                        }
                    }
                    
                },errorCallback: {
                    [weak self] (data: ErrorModel, rawData) in
                    
                    if let strongSelf = self {
                        strongSelf.balance = ""
                        strongSelf.currency = ""
                        
                    }
                })
    }
    
    fileprivate func loadNewTransactions(_ pageNumber:String,loadType:TrxLoadType) -> Void
    {
        
        if(isLoadTrxServiceRunning) {
            return
        }
        
        isLoadTrxServiceRunning = true
        
        
        let cardTransactionInfo : [String: Any] = ["CardId"   :self.getCardID(),
                                                   "CardProductId": self.getProductID(),
                                                   "PageNumber":pageNumber]
        
        let parameters = [ "WalletTransactionInfo": cardTransactionInfo ]
        
        post(ServiceConstants.ServiceName.GetCardTransactions,  parameters: parameters as [String : AnyObject] ,   displayError: false, displaySpinner: TrxLoadType.loadNext != loadType, callback:
                {
                    
                    [weak self](data:[String:AnyObject]?, rawData)
                    
                    in
                    if let strongSelf = self
                    {
                        strongSelf.pageNumber += 1
                        if let data  = data {
                            
                            log.debug("data : \(data)")
                            
                            let theCode =  data[resultCodeKey]
                            
                            guard let _ = theCode, theCode as! Int == 0 else {
                                strongSelf.trxs = nil
                                return
                            }
                            
                            guard let result = data[resultKey]  else{
                                strongSelf.trxs = nil
                                return
                            }
                            
                            if let ToBeContinued = result["ToBeContinued"]  {
                                strongSelf.tobeContinue = ToBeContinued as! Bool
                            }
                            
                            guard let walletTransactions = result["WalletTransactions"] as AnyObject?  else{
                                strongSelf.trxs = nil
                                return
                            }
                            
                            
                            if (TrxLoadType.forceToLoad != loadType && strongSelf.trxs?.count > 0) {
                                strongSelf.trxs?.append(contentsOf: Transactions.createTrx(walletTransactions as AnyObject))
                            }else{
                                strongSelf.trxs = Transactions.createTrx(walletTransactions as AnyObject)
                            }
                        }
                    }
                    
                },errorCallback: {
                    [weak self] (data: ErrorModel, rawData) in
                    
                    if let strongSelf = self {
                        strongSelf.balance = ""
                        strongSelf.currency = ""
                        strongSelf.trxs = nil
                    }
                    
                })
    }
    
    
    
    internal func loadGetTotalParantezReward() -> Void
    {
        
        
        let cardTransactionInfo : [String: Any] = ["CardId"   :self.getCardID(),
                                                   "CardProductId": self.getProductID()]
        
        let parameters = [ "walletInfo": cardTransactionInfo ]
        
        post(ServiceConstants.ServiceName.GetCardParantezReward,  parameters: parameters as [String : AnyObject] ,   displayError: false, displaySpinner: false, callback:
                {
                    
                    [weak self](data:[String:AnyObject]?, rawData)
                    
                    in
                    if let strongSelf = self
                    {
                        if let data  = data {
                            
                            log.debug("data : \(data)")
                            
                            let theCode =  data[resultCodeKey]
                            
                            guard let _ = theCode, theCode as! Int == 0 else {
                                strongSelf.trxs = nil
                                return
                            }
                            
                            guard let result = data[resultKey]  else{
                                strongSelf.trxs = nil
                                return
                            }
                            
                            strongSelf.processUserRewardAmount(result)
                            
                        }
                    }
                    
                },errorCallback: {
                    [weak self] (data: ErrorModel, rawData) in
                    
                    if let strongSelf = self {
                        strongSelf.balance = ""
                        strongSelf.currency = ""
                        
                    }
                })
        
        
    }
    
    //MARK: - Total balance func
    class func getTotalBalanceDisplayValue() -> String{
        
        if let selectedCardProductIDs = loadObjectFromUserDefaults(LocalStorageKeys.kCardTotalBalanceChoice) as? [String]{
            var selectedCardList =  [Card]()
            if let cards = CoreManager.Instance().cards{
                for item in selectedCardProductIDs{
                    let cc = cards.filter{$0.getCardUniqeHash() == item}
                    if !cc.isEmpty{
                        selectedCardList.append(contentsOf: cc)
                    }
                }
                return getSelectedCardsTotalBalance(cards: selectedCardList)
            }
        }else{
            if let cards = CoreManager.Instance().cards{
                let cc = cards.filter{$0.isRestonet() == true}
                if !cc.isEmpty{
                    return cc[0].balanceDisplayValue
                }
            }
        }
        
        
        return ""
    }
    
    
    fileprivate class func getSelectedCardsTotalBalance(cards: [Card]) -> String{
        var totalBalance: Double = 0.0
        for item in cards{
            totalBalance = totalBalance + Double(item.balance)!
        }
        let totalBalanceDisplayValue: String = String(totalBalance / 100).formatAmountToDisplay()
        return totalBalanceDisplayValue
    }
    
    
    
    fileprivate func  processUserRewardAmount(_ result:AnyObject?) {
        
        guard let data = result, result != nil else {
            return
        }
        
        
        if let amount  = data["Money"]
        {
            if(isNotNull(amount as AnyObject)) {
                self.userRewardAmount = (amount as? String)!
            }
        }
        
        if let displayValue  = data["DisplayValue"] {
            self.userRewardAmountDisplayValue = (displayValue as? String)!
        }
        
    }
    
    fileprivate func isNotNull(_ object:AnyObject?) -> Bool {
        guard let object = object else {
            return false
        }
        return (isNotNSNull(object) && isNotStringNull(object))
    }
    
    fileprivate func isNotNSNull(_ object:AnyObject) -> Bool {
        return object.classForCoder != NSNull.classForCoder()
    }
    
    fileprivate func isNotStringNull(_ object:AnyObject) -> Bool {
        if let object = object as? String, object.uppercased() == "NULL" {
            return false
        }
        return true
    }
    
}




//MARK: - Transactions
class Transactions: BaseModel {
    
    
    var  id :Int?
    var  merchantName :String?
    fileprivate var  amount :String?
    var processType :ProcessType?
    var dateTime:String?
    var currency :String?
    var amountDisplayValue :String = ""
    
    deinit{
        log.debug("\(String(describing: self.merchantName)), \(String(describing: self.amount))")
    }
    
    init(id:Int,merchantName:String,amount:String ,processType:ProcessType,dateTime:String,currency:String){
        
        self.id = id
        self.merchantName = merchantName
        self.amount = amount
        self.processType = processType
        self.dateTime = dateTime
        self.currency = currency
    }
    
    
    init(dictionary:[String:AnyObject])
    {
        if let id  = dictionary["Id"] {
            self.id = id as? Int
        }
        
        if let name  = dictionary["MerchantName"] {
            self.merchantName = name as? String
        }
        
        
        if let pType  = dictionary["ProcessType"] {
            self.processType = ProcessType(rawValue: (pType as? String)!)
        }
        
        if let dateTime  = dictionary["DateTime"] {
            self.dateTime = dateTime as? String
        }
        
        
        guard let amountDictionary = dictionary["Amount"]  else{
            self.amount = ""
            self.currency = ""
            return
        }
        
        
        if let amount  = amountDictionary["Money"] {
            self.amount = amount as? String
        }
        if let currency  = amountDictionary["Currency"] {
            self.currency = (currency as? String)?.removeWhitespace()
        }
        
        if let sign  = amountDictionary["Sign"] {
            if ( (sign as! String).length != 0) {
                self.currency = (sign as? String)?.removeWhitespace()
            }
        }
        
        if let displayValue  = amountDictionary["DisplayValue"] {
            self.amountDisplayValue = (displayValue as? String)!
        }
        
        
    }
    
    //MARK: Getters
    func  getName() -> String {
        
        if(merchantName != nil ){
            return merchantName!
        }
        return ""
    }
    
    func getProcessInfo() -> String {
        return (processType?.rawValue.local)!
    }
    
    func  getDateTime() -> String {
        return getDate() + " " + getTime()
    }
    
    func getDate() -> String
    {
        guard let theTimeInt = self.dateTime else{
            return ""
        }
        let dateStr = (theTimeInt as NSString).substring(to: 8)
        
        let formatter = CoreManager.dateFromatter(formatStr: "yyyyMMdd")
        let date = formatter.date(from: dateStr)
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date!)
    }
    
    
    func getDate4Next() -> String
    {
        guard let theTimeInt = self.dateTime else{
            return ""
        }
        let dateStr = (theTimeInt as NSString).substring(to: 8)
        return dateStr
    }
    
    func getTime() -> String
    {
        
        guard let theTimeInt = self.dateTime else{
            return "00:00"
        }
        var timeStr = (theTimeInt as NSString).substring(from: 8)
        timeStr = (timeStr as NSString).substring(to: 4)
        timeStr = timeStr.insert(":", ind: 2)
        
        return timeStr
    }
    
    
    
    func getAmount() -> String
    {
        guard let _ = self.amount, self.amount != nil && self.amount?.length > 0 else{
            return ""
        }
        
        if (self.processType == ProcessType.Expenditure){
            return "- \(self.amountDisplayValue)"
        }
        
        return "\(self.amountDisplayValue)"
    }
    
    
    
    //MARK: Create Transactions
    class func createTrx(_ result:AnyObject?) -> [Transactions]
    {
        var trxs = [Transactions]()
        
        let trxList = result as? [[String:AnyObject]]
        
        guard let list = trxList, trxList?.count > 0 else {
            return trxs
        }
        
        
        
        for item in list
        {
            trxs.append(Transactions(dictionary: item))
        }
        
        return trxs
    }
}

//MARK: - Others

func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.getCardUniqeHash() == rhs.getCardUniqeHash()
}
