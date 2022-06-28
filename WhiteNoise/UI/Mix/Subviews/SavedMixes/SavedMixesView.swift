//
//  SavedMixesView.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 18.06.2022.
//

import UIKit



final class SavedMixesView: UIView {
    
    private var mixes = Array<MixModel>()
    
    lazy var mixesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.backgroundColor = .clear
        
        tableView.register(SavedMixTableViewCell.self, forCellReuseIdentifier: SavedMixTableViewCell.nameOfClass)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPrimarySettings()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPrimarySettings() {
        backgroundColor = .clear
        addSubview(mixesTableView)
        mixes = DatabaseManager.shared.getMixes()
        mixesTableView.reloadData()
    }
    
    private func setupConstraints() {
        mixesTableView.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        mixesTableView.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        mixesTableView.heightAnchor.constraint(equalTo: heightAnchor)
            .isActive = true
    }
}

extension SavedMixesView: UITableViewDataSource ,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mixes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedMixTableViewCell.nameOfClass, for: indexPath) as? SavedMixTableViewCell else { return UITableViewCell() }
        cell.setCellParameters(mix: mixes[indexPath.row])
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let cell = cell as? SavedMixTableViewCell else { return }
//        cell.refreshCell()
//        print("visible rows:", indexPath.row)
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SavedMixTableViewCell else { return }
        cell.refreshCell()
    }
    
}

