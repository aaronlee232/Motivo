//
//  HeaderView.swift
//  Motivo
//
//  Created by Aaron Lee on 3/10/25.
//

import UIKit

enum HeaderButtonType {
    case menu
//    case search
//    case settings
}

protocol HeaderViewDelegate: AnyObject {
    func didTapHeaderButton(_ button: HeaderButtonType)
}

class HeaderView: UIView {
    
    weak var delegate: HeaderViewDelegate?
    
    let titleLabel = UILabel()
    let menuButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.text = "Title"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self, action: #selector(headerMenuButtonTapped), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(menuButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            menuButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func headerMenuButtonTapped() {
        delegate?.didTapHeaderButton(.menu)
    }
    
//    @objc private func headerSearchButtonTapped() {
//        delegate?.didTapHeaderButton(.search)
//    }
//    
//    @objc private func headerSettingsButtonTapped() {
//        delegate?.didTapHeaderButton(.settings)
//    }

}
