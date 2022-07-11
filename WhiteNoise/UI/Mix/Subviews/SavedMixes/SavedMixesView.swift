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
    
    public func didAppear() {
        refreshSavedMixes()
    }
    
    public func refreshSavedMixes() {
        mixes = DatabaseManager.shared.getMixes()
        mixesTableView.reloadData()
    }
    
    private func setPrimarySettings() {
        backgroundColor = .clear
        addSubview(mixesTableView)
//        refreshSavedMixes()
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

extension SavedMixesView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mixes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedMixTableViewCell.nameOfClass, for: indexPath) as? SavedMixTableViewCell else { return UITableViewCell() }
        cell.setCellParameters(mix: mixes[indexPath.row], trackNumber: indexPath.row)
        cell.delegate = self
        return cell
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SavedMixTableViewCell else { return }
        cell.refreshCell()
    }
    
}

extension SavedMixesView: SavedMixTableViewCellDelegate {
    func delete(at cell: SavedMixTableViewCell) {
        guard let indexPath = mixesTableView.indexPath(for: cell) else { return }
        
        mixesTableView.performBatchUpdates {
            mixesTableView.deleteRows(at: [indexPath], with: .fade)
            DatabaseManager.shared.delete(mixModel: mixes[indexPath.row]) {
                mixes.remove(at: indexPath.row)
            }
        }
        
    }
    
    
}


