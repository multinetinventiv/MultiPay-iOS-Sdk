//
//  WalletTableViewCell.swift
//  Multipay
//
//  Created by ilker sevim on 2.11.2020.
//

import UIKit

class WalletTableViewCell: UITableViewCell {
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardNameLbl: UILabel!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var sumOfUsableBalanceLbl: UILabel!
    @IBOutlet weak var radioButton: RadioButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews(){
        self.contentView.backgroundColor = ColorPalette.walletSdk.kartListBackground()
        
        //Card Image
        
        cardImage.image = UIImage(named: "WalletCard", in: getResourceBundle(anyClass: LoginVC.self), compatibleWith: nil)
        
        //Card Name
        
        cardNameLbl.backgroundColor = .clear

        cardNameLbl.textColor = ColorPalette.walletSdk.cardName()

        cardNameLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        
        cardNameLbl.textAlignment = .left
        
        //Card Number
        
        cardNumberLbl.backgroundColor = .clear
        
        cardNumberLbl.textColor = ColorPalette.walletSdk.cardNumber()
        
        cardNumberLbl.font = UIFont(name: "Montserrat-Regular", size: 14)
        cardNumberLbl.textAlignment = .left
        
        // Balance
        
        balanceLbl.backgroundColor = .clear

        balanceLbl.textColor = ColorPalette.walletSdk.cardBalance()

        balanceLbl.font = UIFont(name: "Montserrat-Medium", size: 20)
        
        balanceLbl.textAlignment = .left
        
        //Toplam Kullanılabilir Bakiye
        
        sumOfUsableBalanceLbl.backgroundColor = .clear

        sumOfUsableBalanceLbl.textColor = ColorPalette.walletSdk.cardSumOfUsableBalance()

        sumOfUsableBalanceLbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        
        sumOfUsableBalanceLbl.textAlignment = .left
        
        //Radio Button
        
        self.radioButton.delegate = self
        self.radioButton.isUserInteractionEnabled = false
        
    }
    
    func initTestView(model: WalletModelTest){
        self.cardNameLbl.text = model.cardName
        self.cardNumberLbl.text = model.cardNumber
        self.balanceLbl.text = model.cardBalance
        self.sumOfUsableBalanceLbl.text = Localization.WalletSumBalance.local
        self.radioButton.isChecked = model.isChecked
        if model.isChecked{
            self.contentView.backgroundColor = ColorPalette.walletSdk.kartListBackgroundSelected()
        }else{
            self.contentView.backgroundColor = ColorPalette.walletSdk.kartListBackground()
        }
    }
    
    func initView(model: Wallet){

        let cardName: String = model.name ?? "Multinet"
        self.cardNameLbl.text = cardName
        self.cardNumberLbl.text = model.maskedNumber
        self.balanceLbl.text = model.balance
        self.sumOfUsableBalanceLbl.text = Localization.WalletSumBalance.local
        self.radioButton.isChecked = model.isChecked ?? false
        if model.isChecked ?? false{
            self.contentView.backgroundColor = ColorPalette.walletSdk.kartListBackgroundSelected()
        }else{
            self.contentView.backgroundColor = ColorPalette.walletSdk.kartListBackground()
        }
        
        self.cardImage.image = UIImage(named: "WalletCard", in: getResourceBundle(anyClass: LoginVC.self), compatibleWith: nil)
        
        if let urlString = model.image, let url = URL(string: urlString) {
            self.cardImage.load(url: url)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        //self.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: "E6F3ED")
    }

}

extension WalletTableViewCell: RadioButtonDelegate {
    
    func onClick(_ sender: UIView) {
        guard sender is RadioButton else {
              return
            }
            radioButton.isChecked = !radioButton.isChecked
    }
    
}
