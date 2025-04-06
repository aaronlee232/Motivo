//
//  BarButton.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/3/25.
//
import UIKit

class BarButton: UIBarButtonItem {
//    private var image = UIImage()
//    
//    override init() {
//        <#code#>
//    }
//    
//    init(image: UIImage) {
//        super.init(image: image, style: .plain, target: .none, action: .none)
//        self.image = image
//        setupBarButtonUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupBarButtonUI() {
//        
//    }
}

// ChatGPT code to reference
class CustomBarButtonItem: UIBarButtonItem {

    // Custom button to use for the bar button item
    private var customButton: UIButton!
    
    // You can initialize it with a title, image, or a custom view
    init(title: String?, target: Any?, action: Selector?) {
        super.init()
        
        // Create your custom button
        customButton = UIButton(type: .system)
        
        // Set the title (or you can set an image instead)
        customButton.setTitle(title, for: .normal)
        
        // Set the custom action for the button
        customButton.addTarget(target, action: action!, for: .touchUpInside)
        
        // Customize the appearance (font, color, size, etc.)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        customButton.setTitleColor(UIColor.blue, for: .normal)
        
        // Set the custom button as the custom view of the UIBarButtonItem
        self.customView = customButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
