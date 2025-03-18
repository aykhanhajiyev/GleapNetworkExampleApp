//
//  SampleVC.swift
//  GleapNetworkExample
//
//  Created by Aykhan Hajiyev on 17.03.25.
//

import UIKit
import SnapKit
import SwiftMessages

final class SampleVC: UIViewController {
    
    private let networkService: LoginNetworkService = LoginNetworkServiceImpl()
    
    private let containerStackView: UIStackView = .build {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private let phoneNumberTextField: UITextField = .build {
        $0.placeholder = "Enter your phone number"
        $0.borderStyle = .roundedRect
    }
    
    private let passwordTextField: UITextField = .build {
        $0.placeholder = "Enter your password"
        $0.borderStyle = .roundedRect
        $0.autocapitalizationType = .none
    }
    
    private lazy var loginButton: UIButton = .build {
        $0.setTitle("Login", for: .normal)
        $0.backgroundColor = .gray
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerStackView)
        [
            phoneNumberTextField,
            passwordTextField,
            loginButton
        ].forEach(containerStackView.addArrangedSubview)
        
        containerStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.center.equalToSuperview()
        }
        containerStackView.setCustomSpacing(32, after: passwordTextField)
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    @objc
    private func didTapLoginButton() {
        networkService.login(with: .init(phoneNumber: phoneNumberTextField.text ?? "", password: passwordTextField.text ?? "")) { result in
            switch result {
            case .success(let data):
                let messageView = MessageView.viewFromNib(layout: .cardView)
                messageView.configureTheme(.success)
                messageView.configureDropShadow()
                messageView.configureContent(title: "Success", body: "Login successfully. You won't redirect.")
                SwiftMessages.show(view: messageView)
            case .failure(let error):
                let messageView = MessageView.viewFromNib(layout: .cardView)
                messageView.configureTheme(.error)
                messageView.configureDropShadow()
                messageView.configureContent(title: "Error", body: "Login error. Try again :( Error: \(error)")
                SwiftMessages.show(view: messageView)
            }
        }
    }
}
