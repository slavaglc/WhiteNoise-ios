
import UIKit


protocol CustomSegmentedControlDelegate: AnyObject {
    func change(to index:Int)
}

final class CustomSegmentedControl: UIView, CAAnimationDelegate {
    public var segmentsCount: Int {
        buttonTitles.count
    }
    
    public var segmentIndices: Range<Int> {
        buttonTitles.indices
    }
    
    private var buttonTitles:[String]!
    private var buttons: [UIButton] = []
    private var selectorView: UIView!
    
    let gradientLayer = CAGradientLayer()
    let gradientColors = [
        UIColor(red: 0.79, green: 0.634, blue: 0.946, alpha: 1).cgColor,
        UIColor(red: 0.456, green: 0.22, blue: 0.958, alpha: 1).cgColor
    ]
    
    var textColor:UIColor = .white
    var selectorViewColor: UIColor = #colorLiteral(red: 0.465685904, green: 0.3625613451, blue: 0.8644735217, alpha: 1)
    var selectorTextColor: UIColor = .white
    
    weak var delegate:CustomSegmentedControlDelegate?
    
    public private(set) var selectedIndex : Int = 0
    
    convenience init(frame:CGRect,buttonTitle:[String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = .clear
        updateView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !buttons.isEmpty {
        setIndex(index: self.selectedIndex)
        }
    }
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    func setIndex(index:Int, animated: Bool = false) {
        guard segmentIndices.contains(index) else { return }
        if animated { animateGradient(to: index) }
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }
    
    @objc func buttonAction(sender:UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                
                animateGradient(to: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
    
    
    private func animateGradient(to index: Int) {
        let currentColors: [CGColor] = index == 0 ? gradientColors.reversed() : gradientColors
        let toColor: [CGColor] = currentColors.reversed()
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.delegate = self
        gradientAnimation.duration = 0.5
        gradientAnimation.fromValue = currentColors
        gradientAnimation.toValue = toColor
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        gradientLayer.add(gradientAnimation, forKey: "colors")
    }
}

//Configuration View
extension CustomSegmentedControl {
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
        
        gradientLayer.colors = gradientColors
        
//        gradientLayer.locations = [0 , 1]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.cornerRadius = 1.5
//        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.21, b: -1.14, c: 1.14, d: 5.3, tx: -0.66, ty: -1.61))
       
        selectorView.layer.insertSublayer(gradientLayer, at: .zero)
//        selectorView.layer.addSublayer(gradientLayer)
        
//        selectorView.backgroundColor = selectorViewColor
        
        gradientLayer.bounds = selectorView.bounds
        addSubview(selectorView)
       
       
        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 22)
            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
        buttons[.zero].setTitleColor(selectorTextColor, for: .normal)
    }
}
