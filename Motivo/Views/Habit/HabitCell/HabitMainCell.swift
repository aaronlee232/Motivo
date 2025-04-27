//
//  HabitCellRevised.swift
//  Motivo
//
//  Created by Aaron Lee on 4/24/25.
//

import UIKit

class HabitMainCell: UITableViewCell {
    static let identifier = "HabitMainCell"
    
    // MARK: - UI Elements
    private let habitCellMainView = HabitCellMainView()
    
    // Border layers
    private let borderLayer = CAShapeLayer()
    private let borderWidth: CGFloat = 2
    private let cornerRadius: CGFloat = 20
    
    private var isExpanded = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        cameraDelegate: HabitCellViewCameraDelegate,
        expandDelegate: HabitCellViewExpansionDelegate,
        withHabitWithRecord habitWithRecord: HabitWithRecord,
        categoryIDToName: Dictionary<String, String>,
        isExpanded: Bool
    ) {
        self.isExpanded = isExpanded
        habitCellMainView.configure(
            cameraDelegate: cameraDelegate,
            expandDelegate: expandDelegate,
            withHabitWithRecord: habitWithRecord,
            categoryIDToName: categoryIDToName,
            isExpanded: isExpanded
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (isExpanded) {
            showTopAndSideBordersOnly()
        } else {
            showFullBorders()
        }
    }
}

// MARK: - UI Setup
extension HabitMainCell {
    private func setupUI() {
        contentView.addSubview(habitCellMainView)
        
        habitCellMainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitCellMainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            habitCellMainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habitCellMainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            habitCellMainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func showFullBorders() {
        borderLayer.removeFromSuperlayer()
        
        let rect = bounds.insetBy(dx: borderWidth/2, dy: borderWidth/2)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = colorMainAccent.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = bounds
        
        // Mask with rounded corners (all)
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner,
            .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        ]
        layer.masksToBounds = true

        layer.addSublayer(borderLayer)
    }
    
    func showTopAndSideBordersOnly() {
        borderLayer.removeFromSuperlayer()

        let width = bounds.width
        let height = bounds.height
        let bw = borderWidth / 2

        let path = UIBezierPath()
        // Start at bottom-left (just above bottom, inset)
        path.move(to: CGPoint(x: bw, y: height))
        // Up left edge
        path.addLine(to: CGPoint(x: bw, y: cornerRadius + bw))
        // Top-left corner
        path.addArc(withCenter: CGPoint(x: cornerRadius + bw, y: cornerRadius + bw),
                    radius: cornerRadius,
                    startAngle: .pi,
                    endAngle: 3 * .pi / 2,
                    clockwise: true)
        // Top edge
        path.addLine(to: CGPoint(x: width - cornerRadius - bw, y: bw))
        // Top-right corner
        path.addArc(withCenter: CGPoint(x: width - cornerRadius - bw, y: cornerRadius + bw),
                    radius: cornerRadius,
                    startAngle: 3 * .pi / 2,
                    endAngle: 0,
                    clockwise: true)
        // Down right edge
        path.addLine(to: CGPoint(x: width - bw, y: height))
        // (No bottom edge!)

        borderLayer.path = path.cgPath
        borderLayer.strokeColor = colorMainAccent.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = bounds

        // Top corners only
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true

        layer.addSublayer(borderLayer)
    }

}
