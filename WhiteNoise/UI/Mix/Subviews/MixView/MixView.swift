//
//  MixView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit


final class MixView: UIView {
    
    public var playingSounds: [Sound] {
        sounds.filter {$0.isPlaying}
    }
    
    private let filterTags = FilterTag.getAllFilterTags()
    private let deviceName = UIDevice.modelName
    private var sounds = Sound.getAllSounds()
    private var filtredSounds = Array<Sound>()
        
    private weak var mixViewDisplayLogic: MixViewDisplayLogic!
    
    
//        MARK: - UI Elements
    

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

 
    private lazy var filterTagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset.left = 15
        collectionView.register(FilterTagCollectionViewCell.self, forCellWithReuseIdentifier: FilterTagCollectionViewCell.nameOfClass)
        
        return collectionView
    }()
    
    private lazy var soundsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(SoundCollectionViewCell.self, forCellWithReuseIdentifier: SoundCollectionViewCell.nameOfClass)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    // MARK: - Initialization and lifecycle
    
    convenience init(displayLogic: MixViewDisplayLogic) {
        self.init()
        mixViewDisplayLogic = displayLogic
        setPrimarySettings()
    }
    
    public func refreshSoundsData() {
        if let indexPaths = soundsCollectionView.indexPathsForSelectedItems {
        soundsCollectionView.reloadItems(at: indexPaths)
        }
    }
    
    
        // MARK: - Scroll methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == soundsCollectionView else { return }
        mixViewDisplayLogic.halfFadeOutTabBar()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == soundsCollectionView else { return }
        mixViewDisplayLogic.halfFadeInTabBar()
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == soundsCollectionView else { return }
        mixViewDisplayLogic.halfFadeOutTabBar()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == soundsCollectionView else { return }
        mixViewDisplayLogic.halfFadeInTabBar()
    }
    
    
//    MARK: - Actions
    
    private func tryToPlayLockedSound(for indexPath: IndexPath) {
        soundsCollectionView.deselectItem(at: indexPath, animated: true)
        mixViewDisplayLogic.showAlertForLockedSound(sound: filtredSounds[indexPath.row])
    }
    
    // MARK: - GUI Settings
    
    public func setCollectionViewSettings() {
        let indexPath = IndexPath(item: .zero, section: .zero)
        collectionView(filterTagCollectionView, didSelectItemAt: indexPath)
        filterTagCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    public func setCollectionViewAppearence() {
        setCollectionViewSettings()
    }
 
    public func setSoundsCollectionViewBottomInset(_ inset: CGFloat) {
        soundsCollectionView.contentInset.bottom = inset * 1.5
    }
    
    private func setPrimarySettings() {
        addSubview(filterTagCollectionView)
        addSubview(soundsCollectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        filterTagCollectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        filterTagCollectionView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        filterTagCollectionView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        filterTagCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10)
            .isActive = true
        
        soundsCollectionView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        soundsCollectionView.topAnchor.constraint(equalTo: filterTagCollectionView.bottomAnchor, constant: 16)
            .isActive = true
        soundsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            .isActive = true
        soundsCollectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
            .isActive = true
    }
 
}

// MARK: - CollectionView methods

extension MixView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == soundsCollectionView ? filtredSounds.count : filterTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            
        case soundsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundCollectionViewCell.nameOfClass, for: indexPath) as? SoundCollectionViewCell else { return UICollectionViewCell() }
            cell.contentView.isHidden = true
            let sound = filtredSounds[indexPath.item]
            cell.delegate = self
            cell.setCellParameters(sound: sound)
            if sound.isPlaying {
                soundsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                cell.setBackgroundStyle(selectedStyle: .selected(animated: false, volume: sound.volume))
            }
//            customTabBar.setNumberForBadge(number: playingSounds.count)
            mixViewDisplayLogic.setNumberForBadge(number: playingSounds.count)
            cell.contentView.fadeIn(duration: 0.4, completionAnimation: {})
            return cell
        case filterTagCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterTagCollectionViewCell.nameOfClass, for: indexPath) as? FilterTagCollectionViewCell else { return UICollectionViewCell() }
                cell.setCellParameters(filterTag: filterTags[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (24.552 * 1.5 ) + 100 + 10 // 24.552 is font height of label
        let heightForSound = (deviceName == "iPod9,1" || deviceName == "Simulator iPod touch (7th generation)") ? (24.552 * 1.5 ) + 70 + 10 : height
        let widthForSound = (deviceName == "iPod9,1" || deviceName == "Simulator iPod touch (7th generation)") ? 70.0 : 100.0
        switch collectionView {
        case soundsCollectionView:
            return CGSize(width: widthForSound, height: heightForSound)
        case filterTagCollectionView:
            return CGSize(width: 100, height: 50)
        default:
            return CGSize(width: 100, height: 100)
        }
    }
    
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case filterTagCollectionView:
            let selectedTag = filterTags[indexPath.row].title
            guard let cell = filterTagCollectionView.cellForItem(at: indexPath) as? FilterTagCollectionViewCell else { return }
            cell.setSelectedStyle()
            filtredSounds = selectedTag != "All" ? sounds.filter { $0.category == selectedTag } : sounds
            soundsCollectionView.reloadData()
            break
        case soundsCollectionView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? SoundCollectionViewCell else { return }
            guard !filtredSounds[indexPath.item].isLocked else {
                tryToPlayLockedSound(for: indexPath)
                return }
            let sound = filtredSounds[indexPath.item]
            cell.isUserInteractionEnabled = false
            AudioManager.shared.pauseAllSounds(.saved)
            AudioManager.shared.changeViewsState(to: .pause, mixType: .saved)
            AudioManager.shared.changePlaybackState(to: .play, mixType: .current)
            AudioManager.shared.prepareToPlay(sound: sound, mixType: .current) {
                cell.isUserInteractionEnabled = true
            }
            cell.setBackgroundStyle(selectedStyle: .selected(animated: true, volume: sound.volume))
            break
        default:
            return
        }
        mixViewDisplayLogic.setNumberForBadge(number: playingSounds.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case soundsCollectionView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? SoundCollectionViewCell else { return }
            guard !filtredSounds[indexPath.item].isLocked else { return }
//            filtredSounds[indexPath.item].isPlaying = false
            cell.isUserInteractionEnabled = false
            let sound = filtredSounds[indexPath.item]
            sound.isPlaying = false
            AudioManager.shared.stopPlayback(sound: sound) {
                cell.isUserInteractionEnabled = true
            }
            cell.setBackgroundStyle(selectedStyle: .unselected(animated: true))
        default:
            return
        }
        mixViewDisplayLogic.setNumberForBadge(number: playingSounds.count)
    }
    
}


// MARK: - SoundCollectionViewCell Methods
extension MixView: SoundCollectionViewCellDelegate {
    func selectingVolumeBegan(in cell: SoundCollectionViewCell) {
        guard let indexPath = soundsCollectionView.indexPath(for: cell) else { return }
        collectionView(soundsCollectionView, didSelectItemAt: indexPath)
        soundsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    }
    
    func selectingVolumeEnded(in cell: SoundCollectionViewCell) {
        guard let indexPath = soundsCollectionView.indexPath(for: cell) else { return }
        collectionView(soundsCollectionView, didDeselectItemAt: indexPath)
        soundsCollectionView.deselectItem(at: indexPath, animated: true)
    }
}
