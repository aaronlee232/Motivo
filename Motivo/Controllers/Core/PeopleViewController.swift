//
//  PeopleViewController.swift
//  Motivo
//
//  Created by Aaron Lee on 3/8/25.
//

import UIKit

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HeaderViewDelegate {

    // DUMMY DATA
    var myUser:UserModel = UserModel(username: "Joboe", email: "Joboe@example.com", unverifiedPhotos: 0, favoritesUsers: ["Bob", "Alice"], hiddenUsers: ["Charlie"])
    
    var users: [UserModel] = [
        UserModel(username: "Alice", email: "alice@example.com", unverifiedPhotos: 0, favoritesUsers: [], hiddenUsers: []),
        UserModel(username: "Bob", email: "bob@example.com", unverifiedPhotos: 0, favoritesUsers: [], hiddenUsers: []),
        UserModel(username: "Charlie", email: "charlie@example.com", unverifiedPhotos: 0, favoritesUsers: [], hiddenUsers: [])
    ]
    

    private let headerView = HeaderView()
    private let peopleTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(peopleTableView)
        setupConstraints()
        configureScreen()
    }
    
    private func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func configureScreen() {
        headerView.titleLabel.text = "People"
    }
    
    func didTapHeaderButton(_ button: HeaderButtonType) {
        switch button {
        case .menu:
            // TODO: Add dropdown menu for "Hide People", "View Hidden"
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Replace with sections after organizing into favorites, alphabetical...
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: Implement
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
