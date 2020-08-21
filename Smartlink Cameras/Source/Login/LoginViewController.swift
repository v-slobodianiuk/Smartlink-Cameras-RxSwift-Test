//
//  LoginViewController.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import RxSwift
import UIKit

final class LoginViewController: UIViewController, ViewModelAttachingProtocol {
    
    // MARK: - Conformance to ViewModelAttachingProtocol
    var bindings: LoginViewModel.Bindings {
        return LoginViewModel.Bindings(loginButtonTap: loginButton.rx.tap.asObservable(), loginTextField: loginTextField.rx.text.asObservable())
    }
    
    var viewModel: Attachable<LoginViewModel>!
    
    func configureReactiveBinding(viewModel: LoginViewModel) -> LoginViewModel {
        return viewModel
    }
    
    
    // MARK: - Logic variables
    fileprivate let disposeBag = DisposeBag()
    
    
    // MARK: - UI variables
    fileprivate var areConstraintsSet: Bool = false
    
    fileprivate lazy var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("Sign In", comment: "Login button text"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.28, green: 0.41, blue: 0.46, alpha: 1.00)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var logoBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        guard let image = UIImage(named: "bg_effect") else {
            fatalError("Specific UIImage could not be found from assets")
        }
        imageView.image = image
        imageView.contentMode = .top
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        guard let image = UIImage(named: "logo_light") else {
            fatalError("Specific UIImage could not be found from assets")
        }
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    fileprivate lazy var loginFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    fileprivate lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.layer.borderWidth = 0.0
        textField.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowRadius = 0.0
        textField.attributedPlaceholder = NSAttributedString(string: "Username",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var passwordFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    fileprivate lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.layer.borderWidth = 0.0
        textField.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowRadius = 0.0
        textField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var additionalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    fileprivate lazy var rememberMeCheckBox: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    fileprivate lazy var rememberLabel: UILabel = {
        let label = UILabel()
        label.text = "Remember Me"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var getStartedCenteringStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    fileprivate lazy var getStartedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        return stackView
    }()
    
    fileprivate lazy var getStartedLabel: UILabel = {
        let label = UILabel()
        label.text = "Installing a DIY System? "
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    fileprivate lazy var getStartedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
        
    }
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !areConstraintsSet {
            areConstraintsSet = true
            configureConstraints()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureAppearance()
        gestureRecognizer(view)
        setupKeyboard()
        textfieldsControlEvent()
    }
    
    deinit {
        
    }
    
}
// MARK: - Extension LoginViewController
extension LoginViewController {
    
    // MARK: Setup GestureRecognizer
    fileprivate func gestureRecognizer(_ view: UIView?) {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view?.addGestureRecognizer(tap)
    }
    
    // MARK: Get Keyboard height
    fileprivate func keyboardHeight() -> Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                },
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                    .map { _ -> CGFloat in
                        0
                }
            ])
            .merge()
    }
    
    // MARK: Change view position depending on keyboard height
    fileprivate func setupKeyboard() {
        keyboardHeight()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                self.view.frame.origin.y = 0 - keyboardHeight
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Setup return key events
    fileprivate func textfieldsControlEvent() {
        loginTextField.rx.controlEvent(UIControl.Event.editingDidEndOnExit)
            .map { [weak self] _ -> Bool in
                guard let self = self else { return true }
                self.passwordTextField.becomeFirstResponder()
                return false
        }
        .asObservable()
        .subscribe()
        .disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(UIControl.Event.editingDidEndOnExit)
            .map { [weak self] _ -> Bool in
                guard let self = self else { return true }
                self.loginTextField.becomeFirstResponder()
                return false
        }
        .asObservable()
        .subscribe()
        .disposed(by: disposeBag)
    }
    
    fileprivate func configureAppearance() {
        view.backgroundColor = .white
        
        view.addSubview(logoBackgroundImageView)
        logoBackgroundImageView.addSubview(logoImageView)
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(loginFieldStackView)
        mainStackView.setCustomSpacing(20, after: loginFieldStackView)
        mainStackView.addArrangedSubview(passwordFieldStackView)
        loginFieldStackView.addArrangedSubview(loginTextField)
        passwordFieldStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(additionalStackView)
        mainStackView.addArrangedSubview(loginButton)
        additionalStackView.addArrangedSubview(rememberMeCheckBox)
        additionalStackView.setCustomSpacing(15, after: rememberMeCheckBox)
        additionalStackView.addArrangedSubview(rememberLabel)
        additionalStackView.addArrangedSubview(forgotPasswordButton)
        mainStackView.addArrangedSubview(getStartedCenteringStackView)
        getStartedCenteringStackView.addArrangedSubview(getStartedStackView)
        getStartedStackView.addArrangedSubview(getStartedLabel)
        getStartedStackView.addArrangedSubview(getStartedButton)
    }
    
    fileprivate func configureConstraints() {
        NSLayoutConstraint.activate([
            logoBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            logoBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoBackgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.48),
            
            logoImageView.bottomAnchor.constraint(equalTo: logoBackgroundImageView.bottomAnchor, constant: 25),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: logoBackgroundImageView.bottomAnchor, constant: 0),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0),
            
            loginTextField.heightAnchor.constraint(equalToConstant: 30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30),
            
            rememberMeCheckBox.widthAnchor.constraint(equalToConstant: 20),
            rememberMeCheckBox.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
