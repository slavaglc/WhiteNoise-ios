//
//  PrivacyView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 18.04.2022.
//

import UIKit

class PrivacyView: UIView {
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset.top = 16
        view.contentInset.bottom = 300
        return view
    }()
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Nunito-Bold", size: 22)
        view.textColor = .fromNormalRgb(red: 241, green: 233, blue: 255)
        view.text = "Privacy"
        
        return view
    }()
    
    private lazy var closeBtn: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "CloseButton")
        view.alpha = 0.8
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var text: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Nunito-Bold", size: 16)
        view.textColor = .fromNormalRgb(red: 241, green: 233, blue: 255)
        view.text = magicString
        view.numberOfLines = 0
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add views
        headerStackView.addArrangedSubview(label)
        headerStackView.addArrangedSubview(closeBtn)
        addSubview(scrollView)
        addSubview(headerStackView)
        scrollView.addSubview(text)
       
        setUpConstraints()
        setBlurEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func viewDidAppear(_ animated: Bool) {
        setBlurEffectForStatusBar() //In viewDidAppear because statusBar height avaible after view loaded only
    }
    
    private func setUpConstraints() {
        //headerStackView
        let horizontalBarHeight: CGFloat = 45
        let padding = 16.0
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            headerStackView.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
        ])
        
        //closeBtn
        NSLayoutConstraint.activate([
            closeBtn.widthAnchor.constraint(equalToConstant: horizontalBarHeight),
            closeBtn.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
        ])
            
        
        // scrollView
        NSLayoutConstraint.activate([
//            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // label
//        NSLayoutConstraint.activate([
//            label.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 19),
//            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -32),
//            label.widthAnchor.constraint(equalToConstant: 100),
//            label.heightAnchor.constraint(equalToConstant: 40)
//        ])
        
        // text
        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            text.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            text.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            text.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
//            text.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor),
        ])
    }
    
    @objc
    private func closeView(view: UIView) {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    private func setBlurEffect() {
//        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
//        let blurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.08)
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        headerStackView.insertSubview(blurEffectView, at: .zero)
    }
    
    private func setBlurEffectForStatusBar() {
        guard let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame else { return }
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.08)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let headerHeight = headerStackView.frame.height
        blurEffectView.frame = CGRect(x: statusBarFrame.minX, y: statusBarFrame.minY, width: statusBarFrame.width, height: headerHeight + statusBarFrame.height)
        guard let blurEffectIndex =  subviews.firstIndex(of: headerStackView) else { return }
        insertSubview(blurEffectView, at: blurEffectIndex)

    }
    
    
}

let magicString = """
This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.

We use Your Personal data to provide and improve the Service. By using the Service, you agree to the collection and use of information in accordance with this Privacy Policy.

Interpretation and Definitions
Collecting and Using Your Personal Data
Detailed Information on the Processing of Your Personal Data
GDPR Privacy
CCPA Privacy
"Do Not Track" Policy as Required by California Online Privacy Protection Act (CalOPPA)
Children's Privacy
Your California Privacy Rights (California Business and Professions Code Section 22581)
Links to Other Websites
Changes to this Privacy Policy
Contact Us
Interpretation and Definitions
Interpretation
The words of which the initial letter is capitalized have meanings defined under the following conditions.

The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.

Definitions
For the purposes of this Privacy Policy:

You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.
Under GDPR (General Data Protection Regulation), You can be referred to as the Data Subject or as the User as you are the individual using the Service.

Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Leap Fitness Group.
For the purpose of the GDPR, the Company is the Data Controller.

Application means the software program provided by the Company downloaded by You on any electronic device, named Sleep Sounds.
Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.
Account means a unique account created for You to access our Service or parts of our Service.
Service refers to the Application.
Country refers to: United States
Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.
For the purpose of the GDPR, Service Providers are considered Data Processors.

Third-party Social Media Service refers to any website or any social network website through which a User can log in or create an account to use the Service.
Personal Data is any information that relates to an identified or identifiable individual.
For the purposes for GDPR, Personal Data means any information relating to You such as a name, an identification number, location data, online identifier or to one or more factors specific to the physical, physiological, genetic, mental, economic, cultural or social identity.

For the purposes of the CCPA, Personal Data means any information that identifies, relates to, describes or is capable of being associated with, or could reasonably be linked, directly or indirectly, with You.

Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.
Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).
Data Controller, for the purposes of the GDPR (General Data Protection Regulation), refers to the Company as the legal person which alone or jointly with others determines the purposes and means of the processing of Personal Data.

Do Not Track (DNT) is a concept that has been promoted by US regulatory authorities, in particular the U.S. Federal Trade Commission (FTC), for the Internet industry to develop and implement a mechanism for allowing internet users to control the tracking of their online activities across websites.
Business, for the purpose of the CCPA (California Consumer Privacy Act), refers to the Company as the legal entity that collects Consumers' personal information and determines the purposes and means of the processing of Consumers' personal information, or on behalf of which such information is collected and that alone, or jointly with others, determines the purposes and means of the processing of consumers' personal information, that does business in the State of California.
Consumer, for the purpose of the CCPA (California Consumer Privacy Act), means a natural person who is a California resident. A resident, as defined in the law, includes (1) every individual who is in the USA for other than a temporary or transitory purpose, and (2) every individual who is domiciled in the USA who is outside the USA for a temporary or transitory purpose.
Sale, for the purpose of the CCPA (California Consumer Privacy Act), means selling, renting, releasing, disclosing, disseminating, making available, transferring, or otherwise communicating orally, in writing, or by electronic or other means, a Consumer's Personal information to another business or a third party for monetary or other valuable consideration.
Collecting and Using Your Personal Data
Types of Data Collected
Personal Data
While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You.

General Information. When you sign up to use the App, we may collect Personal data about you such as:

Email address
First name and last name
Phone number
Gender
Password or passcode
Usage Data
Health data. When you use the App, you may choose to provide personal information about your health such as:

Weight
Height
Body temperature;
Menstrual cycle;
Symptoms;
Other information about your health (including sexual activities), and related activities.
Usage Data
Usage Data is collected automatically when using the Service.

Usage Data may include information such as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.

When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.

We may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device, below list can provide a non-exclusive list of the contents of Usage Data:

Hardware model;
Information about operating system and its version;
Screen size and density;
Language and country;
Unique device identifiers (e.g. IDFA);
Time zone;
Device mute status (related to reminder function)
In order to provide a better user experience, we have integrated data statistics tools in the App, they won't collect users’ health data or privacy data and are only used for CRASH targeting and AB-testing for new features and design， The details are as follows:

Device information
Screen Size
OEM Name
Model
Device system information
OS Name
OS Version
OS Build
Time Zone
System Language
Carrier Country
Carrier Name
Location information
The right to know about Your Personal Data. You have the right to request and obtain from the Company information regarding the disclosure of the following:

The categories of Personal Data collected
The sources from which the Personal Data was collected
The business or commercial purpose for collecting or selling the Personal Data
Categories of third parties with whom We share Personal Data
The specific pieces of Personal Data we collected about You
The right to delete Personal Data. You also have the right to request the deletion of Your Personal Data that have been collected in the past 12 months.
The right not to be discriminated against. You have the right not to be discriminated against for exercising any of Your Consumer's rights, including by:

Denying goods or services to You
Charging different prices or rates for goods or services, including the use of discounts or other benefits or imposing penalties
Providing a different level or quality of goods or services to You
Suggesting that You will receive a different price or rate for goods or services or a different level or quality of goods or services.
Exercising Your CCPA Data Protection Rights
In order to exercise any of Your rights under the CCPA, and if you are a California resident, You can email or call us or visit our "Do Not Sell My Personal Information" section or web page.

The Company will disclose and deliver the required information free of charge within 45 days of receiving Your verifiable request. The time period to provide the required information may be extended once by an additional 45 days when reasonable necessary and with prior notice.

Do Not Sell My Personal Information
We do not sell personal information. However, the Service Providers we partner with (for example, our advertising partners) may use technology on the Service that "sells" personal information as defined by the CCPA law.

If you wish to opt out of the use of your personal information for interest-based advertising purposes and these potential sales as defined under CCPA law, you may do so by following the instructions below.

Please note that any opt out is specific to the browser You use. You may need to opt out on every browser that you use.

Website
You can opt out of receiving ads that are personalized as served by our Service Providers by following our instructions presented on the Service:

From Our "Cookie Consent" notice banner
Or from Our "CCPA Opt-out" notice banner
Or from Our "Do Not Sell My Personal Information" notice banner
Or from Our "Do Not Sell My Personal Information" link
The opt out will place a cookie on Your computer that is unique to the browser You use to opt out. If you change browsers or delete the cookies saved by your browser, you will need to opt out again.

Mobile Devices
Your mobile device may give you the ability to opt out of the use of information about the apps you use in order to serve you ads that are targeted to your interests:

"Opt out of Interest-Based Ads" or "Opt out of Ads Personalization" on Android devices
"Limit Ad Tracking" on iOS devices
You can also stop the collection of location information from Your mobile device by changing the preferences on your mobile device.

"Do Not Track" Policy as Required by California Online Privacy Protection Act (CalOPPA)
Our Service does not respond to Do Not Track signals.

However, some third party websites do keep track of Your browsing activities. If You are visiting such websites, You can set Your preferences in Your web browser to inform websites that You do not want to be tracked. You can enable or disable DNT by visiting the preferences or settings page of Your web browser.

Children's Privacy
Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us.

If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.

Your California Privacy Rights (California Business and Professions Code Section 22581)
California Business and Professions Code section 22581 allow California residents under the age of 18 who are registered users of online sites, services or applications to request and obtain removal of content or information they have publicly posted.

To request removal of such data, and if you are a California resident, You can contact Us using the contact information provided below, and include the email address associated with Your account.

Be aware that Your request does not guarantee complete or comprehensive removal of content or information posted online and that the law may not permit or require removal in certain circumstances.

Links to Other Websites
Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party's site. We strongly advise You to review the Privacy Policy of every site You visit.
We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.
Changes to this Privacy Policy
We may update our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page.

We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.

You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.

Contact Us
It should be noted that whether or not to send us your feedback or bug report is a completely voluntary initiative upon your own decision. If you have a concern about your personal data being misused, or if you want further information about our privacy policy and what it means, please feel free to email us at support@leap.app, we will endeavor to provide clear answers to your questions in a timely manner.
"""
