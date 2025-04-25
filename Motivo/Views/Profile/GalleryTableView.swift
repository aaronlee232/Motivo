//
//  GalleryTableView.swift
//  Motivo
//
//  Created by Aaron Lee on 4/20/25.
//

import UIKit

class GalleryTableView: UIView  {
    let tableView = UITableView()
    var habitsWithImages: [HabitPhotoData] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureTableView()
    }
    
    private func setupUI() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HabitGalleryCell.self, forCellReuseIdentifier: HabitGalleryCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(habitsWithImages: [HabitPhotoData]) {
        self.habitsWithImages = habitsWithImages
        tableView.reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension GalleryTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        habitsWithImages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = habitsWithImages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitGalleryCell.identifier, for: indexPath) as! HabitGalleryCell
        cell.configure(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
