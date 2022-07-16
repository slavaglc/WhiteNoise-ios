//
//  MixerSettingsViewController.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 16.07.2022.
//

import UIKit

protocol MixerSettingDelegate {
    func deleteMix()
}

final class MixerSettingsViewController: UIViewController {

    var mixModel: MixModel?
    private var delegate: MixerSettingDelegate?
    
    private lazy var mixerSettingsView = MixerSettingsView(viewController: self, mixModel: mixModel)
    
    convenience init(mixModel: MixModel, delegate: MixerSettingDelegate) {
        self.init()
        self.mixModel = mixModel
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        view = mixerSettingsView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public func closeDisplay() {
        navigationController?.popViewController(animated: true)
    }
    
    public func deleteSelectedMix() {
        delegate?.deleteMix()
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
