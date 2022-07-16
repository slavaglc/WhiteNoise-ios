//
//  MixerSettingsViewController.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 16.07.2022.
//

import UIKit

class MixerSettingsViewController: UIViewController {

    private lazy var mixerSettingsView = MixerSettingsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        view = mixerSettingsView
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
