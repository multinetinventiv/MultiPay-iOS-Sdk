//
//  ToastView.swift
//  Multipay
//
//  Created by Ramazan Oz on 5.09.2022.
//

import UIKit

class ToastView: UIView {
    struct Model {
        let message: String
        let buttonText: String?
        let onButtonTap: (() -> Void)?
    }
    
    private let containerView: UIView
    private var messageQueue: [Model] = []
    private var currentModel: Model?
    private let label = UILabel()
    private let stackView = UIStackView()
    private let button = UIButton()
    private let closeImageView = UIImageView()
    private let closeImageContainerView = UIView()
    
    init(showIn containerView: UIView) {
        self.containerView = containerView
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        closeImageView.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.cornerRadius = 10
        clipsToBounds = true
        self.alpha = 0
        button.roundedCorners(cornerRadius: 10, borderWidth: 1.0, borderColor: .white)
        
        closeImageView.image = UIImage(named: "sdkCloseBtn", in: getResourceBundle(anyClass: ToastView.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsets(top: -4, left: -4, bottom: -4, right: -4))
        closeImageView.tintColor = .white
        
        containerView.addSubview(self)
        
        self.addSubview(stackView)
        closeImageContainerView.addSubview(closeImageView)
        
        stackView.addArrangedSubview(closeImageContainerView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 6),
            leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            closeImageView.trailingAnchor.constraint(equalTo: closeImageContainerView.trailingAnchor),
            closeImageView.topAnchor.constraint(equalTo: closeImageContainerView.topAnchor),
            closeImageView.bottomAnchor.constraint(equalTo: closeImageContainerView.bottomAnchor),
            
            closeImageView.widthAnchor.constraint(equalToConstant: 24),
            closeImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        closeImageView.tintColor = .white
        closeImageView.isUserInteractionEnabled = true
        closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapCloseButton)))
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc private func buttonAction() {
        hide()
        currentModel?.onButtonTap?()
    }
    
    @objc func onTapCloseButton() {
        if alpha == 1 {
            hide()
        }
    }
    
    public func show(message: String, buttonText: String? = nil, onButtonTap: (() -> Void)? = nil) {
        let model = Model(message: message, buttonText: buttonText, onButtonTap: onButtonTap)
        
        self.messageQueue.append(model)
        
        if alpha == 0 {
            self.checkQueue()
        }
    }
    
    private func checkQueue() {
        if self.messageQueue.count > 0 {
            let model = self.messageQueue[0]
            currentModel = model
            
            label.text = model.message
            
            if let buttonText = model.buttonText {
                button.isHidden = false
                closeImageContainerView.isHidden = false
                button.setTitle(buttonText, for: UIControl.State())
            } else {
                button.isHidden = true
                closeImageContainerView.isHidden = true
            }
            
            self.messageQueue.remove(at: 0)
            
            if self.alpha == 0 {
                UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                    self.alpha = 1
                }, completion: { _ in
                    
                    if self.button.isHidden {
                        self.hideWithDelay()
                    }
                })
            }
        }
    }
    
    private func hide() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.checkQueue()
            
        })
    }
    
    private func hideWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if self.button.isHidden {
                self.hide()
            }
        })
    }
}
