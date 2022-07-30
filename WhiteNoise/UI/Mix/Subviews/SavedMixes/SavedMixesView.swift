//
//  SavedMixesView.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 18.06.2022.
//

import UIKit



final class SavedMixesView: UIView {
    
    private var mixes = Array<MixModel>()
    private var mixDisplayLogic: MixViewDisplayLogic?
    
    lazy var mixesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.backgroundColor = .clear
        tableView.contentInset.bottom = 100
        tableView.showsVerticalScrollIndicator = false
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
    
    convenience init(displayLogic: MixViewDisplayLogic) {
        self.init()
        mixDisplayLogic = displayLogic
    }
    
    public func refreshData() {
        refreshSavedMixes()
    }
    
    public func refreshSavedMixes() {
        mixes = DatabaseManager.shared.getMixes()
        mixesTableView.reloadData()
        mixesTableView.visibleCells.forEach { cell in
            guard let cell = cell as? SavedMixTableViewCell else { return }
            cell.refreshCell()
        }
    }
    
    private func setPrimarySettings() {
        backgroundColor = .clear
        addSubview(mixesTableView)
//        refreshSavedMixes()
    }
    
    private func setupConstraints() {
        mixesTableView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            .isActive = true
        mixesTableView.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        mixesTableView.heightAnchor.constraint(equalTo: heightAnchor)
            .isActive = true
    }
    
    // MARK: - Scroll methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        mixDisplayLogic?.halfFadeOutTabBar()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        mixDisplayLogic?.halfFadeInTabBar()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        mixDisplayLogic?.halfFadeOutTabBar()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        mixDisplayLogic?.halfFadeInTabBar()
    }
}
// MARK: - TableView Methods
extension SavedMixesView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mixes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedMixTableViewCell.nameOfClass, for: indexPath) as? SavedMixTableViewCell else { return UITableViewCell() }
        cell.setCellParameters(mix: mixes[indexPath.row], trackNumber: indexPath.row)
        cell.refreshCell()
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SavedMixTableViewCell else { return }
        cell.refreshCell()
    }
    
    
}


//MARK: - SaveMixTableViewCellDelegate methods
extension SavedMixesView: SavedMixTableViewCellDelegate {
    func showOptions(for mixModel: MixModel?, delegate: MixerSettingDelegate) {
        guard let mixModel = mixModel else { return }

        viewController?.show(MixerSettingsViewController(mixModel: mixModel, delegate: delegate), sender: nil)
    }
    
    
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


