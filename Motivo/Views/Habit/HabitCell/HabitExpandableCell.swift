//
//  HabitExpandableCell.swift
//  Motivo
//
//  Created by Aaron Lee on 4/25/25.
//

import UIKit

class HabitExpandableCell: UITableViewCell {
    static let identifier = "HabitExpandableCell"
    
    // MARK: - UI Elements
    private let separatorView = UIView()
    private let habitExpandedView = HabitExpandedView()
    
    // Border layers
    private let borderLayer = CAShapeLayer()
    private let borderWidth: CGFloat = 2
    private let cornerRadius: CGFloat = 20
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        withHabitWithRecord habitWithRecord: HabitWithRecord,
        withRejectVotes rejectVotes: [VoteModel]
    ) {
        habitExpandedView.configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        showBottomAndSideBordersOnly()
    }
}

// MARK: - UI Setup
extension HabitExpandableCell {
    private func setupUI() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.backgroundColor = colorMainAccent

        contentView.addSubview(separatorView)
        contentView.addSubview(habitExpandedView)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        habitExpandedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            habitExpandedView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            habitExpandedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habitExpandedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            habitExpandedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func showBottomAndSideBordersOnly() {
        borderLayer.removeFromSuperlayer()
        
        let width = bounds.width
        let height = bounds.height
        let bw = borderWidth / 2
        let cr = cornerRadius
        
        // Start at top-left, just under separator
        // Start a few pixels above the visible top
        // Start at top-left (bw, 0)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bw, y: -borderWidth))
        
        // Down left edge
        path.addLine(to: CGPoint(x: bw, y: height - cr - bw))
        // Bottom-left corner
        path.addArc(withCenter: CGPoint(x: bw + cr, y: height - cr - bw),
                    radius: cr,
                    startAngle: .pi,
                    endAngle: .pi/2,
                    clockwise: false)
        // Bottom edge
        path.addLine(to: CGPoint(x: width - cr - bw, y: height - bw))
        // Bottom-right corner
        path.addArc(withCenter: CGPoint(x: width - cr - bw, y: height - cr - bw),
                    radius: cr,
                    startAngle: .pi/2,
                    endAngle: 0,
                    clockwise: false)
        // Up right edge
        path.addLine(to: CGPoint(x: width - bw, y: -borderWidth))
        
        // (No top border)
        
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = colorMainAccent.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = bounds
        
        // Only bottom corners rounded
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.masksToBounds = true
        
        layer.addSublayer(borderLayer)
    }

}
