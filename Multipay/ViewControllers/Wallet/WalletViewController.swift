//
//  WalletViewController.swift
//  Pods
//
//  Created by ilker sevim on 2.11.2020.
//

import UIKit

class WalletViewController: BaseVC {
    
    @IBOutlet weak var topInfoLbl: UILabel!
    @IBOutlet weak var cardList: UITableView!
    @IBOutlet weak var bottomButtonStackView: UIStackView!
    @IBOutlet weak var addCardBtn: UIButton!
    @IBOutlet weak var eslestirBtn: UIButton!
    @IBOutlet weak var radioButton: RadioButton!
    
    var walletModelList: [WalletModelTest] = [WalletModelTest]()
    {
        didSet{
            self.cardList.reloadData()
        }
    }
    
    var lastSelectedCardTest: WalletModelTest?
    var lastSelectedCard: Wallet?
    
    var getWalletsResponseModel: GetWalletsResponse?
    {
        didSet{
            self.cardList.reloadData()
        }
    }
    
    let tableRowHeight:CGFloat = 116
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationViewType = NavigationType.withLeftButton
        self.navigationEditionType = NavigationEditionType.whiteEditionType
        self.hasKeyboard = false
        
        self.cardList.estimatedRowHeight = tableRowHeight
        self.cardList.rowHeight = tableRowHeight
        
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Multipay.testModeActive
        {
            addTestModel()
            walletModelList.forEach { (model) in
                model.isChecked = false
                if model.token == Auth.walletToken {
                    model.isChecked = true
                    self.lastSelectedCardTest = model
                    self.eslestirBtn.isHidden = false
                }
                self.cardList.reloadData()
            }
        }
        else{
            callGetWallets()
        }
        
        self.title = Localization.WalletTitle.local
        self.navigationItem.title = Localization.WalletTitle.local
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            
            self.navigationController?.dismiss(animated: false, completion: {
                Auth.shared.logout()
            })
            
        }
    }
    
    func setupViews(){
        
        self.title = Localization.WalletTitle.local
        self.cardList.backgroundColor = UIColor.clear
        self.cardList.separatorColor = ColorPalette.walletSdk.seperatorColor()
        self.cardList.tableFooterView = UIView()
        
        //Top Info Lbl Style
        
        topInfoLbl.textColor = ColorPalette.walletSdk.topInfoText()
        //UIColor(red: 0.098, green: 0.098, blue: 0.098, alpha: 1)
        
        topInfoLbl.font = UIFont(name: "Montserrat-Regular", size: 14)
        
        topInfoLbl.numberOfLines = 0
        
        topInfoLbl.lineBreakMode = .byWordWrapping
        
        topInfoLbl.textAlignment = .center
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineHeightMultiple = 1.17
        
        paragraphStyle.alignment = .center
        
        let topInfoStr = Localization.WalletTopInfoText.local
        
        topInfoLbl.attributedText = NSMutableAttributedString(string: topInfoStr, attributes: [NSAttributedString.Key.kern: 0.25, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        //Add Card Button Style
        
        addCardBtn.backgroundColor = UIColor(red: 0.384, green: 0.008, blue: 0.933, alpha: 0)
        
        addCardBtn.layer.backgroundColor = UIColor(red: 0.384, green: 0.008, blue: 0.933, alpha: 0).cgColor
        
        addCardBtn.layer.cornerRadius = 10
        
        addCardBtn.layer.borderWidth = 1
        
        addCardBtn.layer.borderColor = ColorPalette.getirBorder.cgColor
        
        addCardBtn.setTitleColor(ColorPalette.tintColor(), for: UIControl.State.normal)
        
        addCardBtn.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 13.65)
        
        addCardBtn.titleLabel?.textAlignment = .center
        
        addCardBtn.setTitle(Localization.WalletAddCardButton.local, for: UIControl.State.normal)
        
        // Eşleştir Button Style
        
        eslestirBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "5DB185")
        
        eslestirBtn.clipsToBounds = true
        
        eslestirBtn.layer.cornerRadius = 10
        
        eslestirBtn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        eslestirBtn.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 14)
        
        eslestirBtn.titleLabel?.textAlignment = .center
        
        eslestirBtn.setTitle(Localization.WalletSynchroniseButton.local, for: UIControl.State.normal)
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension WalletViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTemp = tableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell", for: indexPath) as? WalletTableViewCell
        guard let cell = cellTemp else{
            return WalletTableViewCell()
        }
        
        if Multipay.testModeActive, let model = walletModelList[safeIndex:indexPath.row]{
            cell.initTestView(model: model)
        }
        else if let wallets = self.getWalletsResponseModel?.result?.wallets, let model = wallets[safeIndex:indexPath.row]{
            cell.initView(model: model)
        }
        
        cell.selectionStyle = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Multipay.testModeActive{
            return walletModelList.count
        }
        else{
            return getWalletsResponseModel?.result?.wallets?.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let wallets = self.getWalletsResponseModel?.result?.wallets{
            wallets.forEach { (wallet) in
                wallet.isChecked = false
            }
            
            let realModel = wallets[safeIndex:indexPath.row]
            realModel?.isChecked = true
            self.lastSelectedCard = realModel
        }
        
        if Multipay.testModeActive{
            walletModelList.forEach { (model) in
                model.isChecked = false
            }
            let model = walletModelList[safeIndex:indexPath.row]
            model?.isChecked = true
            self.lastSelectedCardTest = model
        }
        
        tableView.reloadData()
        self.eslestirBtn.isHidden = false
        log.debug("row clicked \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell.responds(to: #selector(setter: UITableViewCell.separatorInset))) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        if (cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins))) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if (cell.responds(to: #selector(setter: UIView.layoutMargins))) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
}


extension WalletViewController{
    
    @IBAction func eslestirBtnClicked(_ sender: Any) {
        
        log.debug("eslestir btn clicked")
        
        guard let selected = self.lastSelectedCardTest, Multipay.testModeActive else {
            guard let selected = self.lastSelectedCard else{
                return
            }
            
            if selected.isSelected == true{
                self.presentModalWillDismiss(animated: true)
                return
            }
            
            callSelectWallet(lastSelectedCard: selected)
            
            return
        }
        
        Multipay.delegate?.multipaySelectedCardInfos(cardBalance: selected.cardBalance, cardImageUrl: selected.cardImageUrl, cardName: selected.cardName, walletToken: selected.token, cardMaskedNumber: selected.cardNumber)
        self.presentModalWillDismiss(animated: true)
    }
    
    @IBAction func addCardBtnClicked(_ sender: Any) {
        
        let nav = self.navigationController as! MyNavigationController
        nav.openAddCardFromWallet()
        
    }
}

extension WalletViewController{
    
    func callGetWallets(){
        
        log.debug("callGetWallets is called")
        
        var parameters : [String:String] = [:]
        if let walletToken = Auth.walletToken {
            parameters[walletTokenKey] = walletToken
        }
        else{
            parameters[authTokenKey] = Auth.authToken
        }
        
        if let referenceNumber = Auth.referenceNumber {
            parameters[referenceNumberKey] = referenceNumber
        }
        
        post(ServiceConstants.ServiceName.SdkWallet, isSdkService: true, parameters: parameters  as [String:AnyObject], displayError: true, isSecure: false, httpMethod: .post, callback: { [weak self](data: [String:AnyObject]?, rawData) in
            if let strongSelf = self{
                //log.debug("data : \(String(describing: data))")
                
                if let rawData = rawData{
                    do{
                        let modelObject = try rawData.decoded() as GetWalletsResponse
                        if let wallets = modelObject.result?.wallets{
                            for wallet in wallets{
                                if wallet.isSelected == true{
                                    wallet.isChecked = true
                                    strongSelf.lastSelectedCard = wallet
                                    strongSelf.eslestirBtn.isHidden = false
                                    break
                                }
                            }
                        }
                        strongSelf.getWalletsResponseModel = modelObject
                    }
                    catch{
                        print("error: \(error)")
                    }
                }
                
                if let responseData  = data {
                    if  strongSelf.checkResultCodeAndShowError(responseData,showMessage: Multipay.testModeActive ? false : true) == ServiceResultCodeType.exit {
                        //strongSelf.navigationController?.popToRootViewController(animated: true)
                        return
                    }
                }
                
            }
            
        },errorCallback: {
            [weak self] (data, rawData) in
            
            log.error("error : \(data.description)")
            
            let alert = UIAlertController(title: "Failed", message: data.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
            
            Multipay.delegate?.walletTokenExpired(expiredWalletToken: parameters[walletTokenKey])
            
//            if let self = self{
//                self.navigationController?.popToRootViewController(animated: true)
//                return
//            }
        })
        
    }
    
    func callSelectWallet(lastSelectedCard: Wallet){
        
        log.debug("callSelectWallet is called")
        
        var parameters:[String : String] = [:]
        
        if let referenceNumber = Auth.referenceNumber {
            parameters[referenceNumberKey] = referenceNumber
        }
        
        let wallets = self.getWalletsResponseModel?.result?.wallets
        var isSelected = false
        
        if let wallets = wallets{
            for wallet in wallets{
                if wallet.isSelected == true{
                    isSelected = true
                }
            }
        }
        
        if let walletToken = lastSelectedCard.token {
            parameters[walletTokenKey] = walletToken
        }
        
        else if let walletToken = Auth.walletToken {
            parameters[walletTokenKey] = walletToken
        }
        
        let serviceName = isSelected ? ServiceConstants.ServiceName.SdkChangeWallet : ServiceConstants.ServiceName.SdkSelectWallet
        
        post(serviceName, isSdkService: true, parameters: parameters  as [String:AnyObject], displayError: true, isSecure: false, httpMethod: .post, callback: { [weak self](data: [String:AnyObject]?, rawData) in
            if let self = self{
                log.debug("data : \(String(describing: data))")
                
                if let wallets = self.getWalletsResponseModel?.result?.wallets{
                    wallets.forEach { (wallet) in
                        wallet.isSelected = false
                    }
                }
                
                lastSelectedCard.isSelected = true
                
                if let responseData  = data {
                    if  self.checkResultCodeAndShowError(responseData,showMessage: Multipay.testModeActive ? false : true) == ServiceResultCodeType.exit {
                        //self.navigationController?.popToRootViewController(animated: true)
                        return
                    }
                }
                
                Multipay.delegate?.multipaySelectedCardInfos(cardBalance: lastSelectedCard.balance, cardImageUrl: lastSelectedCard.image, cardName: lastSelectedCard.name, walletToken: lastSelectedCard.token, cardMaskedNumber: lastSelectedCard.maskedNumber)
                
                self.presentModalWillDismiss(animated: true)
            }
            
        },errorCallback: {
            [weak self] (data, rawData) in
            
            log.error("error : \(data.description)")
            
            Multipay.delegate?.walletTokenExpired(expiredWalletToken: parameters[walletTokenKey] as? String)
            
            if let self = self{
                //self.navigationController?.popToRootViewController(animated: true)
                return
            }
        })
    }
}

extension WalletViewController{
    
    func addTestModel(){
        self.walletModelList.append(WalletModelTest())
        let second = WalletModelTest()
        second.cardName = "MultiNet 2"
        second.cardNumber = "9999 9999 9999 9999"
        second.cardBalance = "87,08 TL"
        second.token = "test token"
        self.walletModelList.append(second)
    }
}

//MARK: - StoryboardInstantiable
extension WalletViewController: StoryboardInstantiable {
    static var storyboardName: String { return "Cards" }
    static var storyboardIdentifier: String? { return "WalletVC" }
}
