//
//  CategorySelectionView.swift
//  Motivo
//
//  Created by Aaron Lee on 3/19/25.
//

import UIKit

protocol CategorySelectionViewDelegate: AnyObject {
    func didUpdateSelectedCategories(_ selectedCategories: Set<CategoryModel>)
}

class CategorySelectionView: UIView, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    
    var categories: [CategoryModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedCategories = Set<CategoryModel>()
    weak var delegate: CategorySelectionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        let category = categories[indexPath.row]
        
        cell.configureWith(category: category, isSelected: false)
        cell.accessoryType = selectedCategories.contains(category) ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        delegate?.didUpdateSelectedCategories(selectedCategories)
    }
}
