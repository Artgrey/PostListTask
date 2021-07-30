//
//  UserDetailsController.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-04.
//

import UIKit
import MessageUI

class UserDetailsController: BaseViewController, MFMailComposeViewControllerDelegate {

    var postsModel: PostsViewModel!
    var detailsModel: DetailsViewModel!
    var refreshControl = UIRefreshControl()
    private var postsListModel = PostsListViewModel()
    private var postsListDetailsModel = DetailsListViewModel()
    private var postID: Int64!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var company: UILabel!
    @IBOutlet var body: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var phoneButton: UIButton!
    @IBOutlet var addressButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        postID = postsModel.id
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    @objc func refresh(_ sender: AnyObject) {
        CoreDataManager.sharedInstance.loadPostsData()
        retrieveData()
        let post = postsListModel.object(id: postID)
        postsModel = PostsViewModel(postsInfo: post)
        let details = postsListDetailsModel.object(id: postsModel.userId)
        detailsModel = DetailsViewModel(details: details)
        updateUI()
        refreshControl.endRefreshing()
    }
    private func retrieveData() {
        postsListModel.retrieveDataFromCoreData()
        postsListDetailsModel.retrieveDataFromCoreData()
    }
    private func updateUI() {
        self.titleLabel.text = postsModel.title
        self.body.text = postsModel.body
        self.body.sizeToFit()
        self.userName.text = detailsModel.name
        self.company.text = detailsModel.company
        self.emailButton.setTitle(detailsModel.email, for:.normal)
        self.phoneButton.setTitle(detailsModel.phone, for:.normal)
        self.addressButton.setTitle(detailsModel.address, for:.normal)
        
        self.imageView.setImageFromPath("\(postsModel.userId)")
        self.imageView.makeRounded()
    }
    @IBAction func sendEmailPressed(_ sender: Any) {
        let mailComposeViewController = configureMailComposer()
           if MFMailComposeViewController.canSendMail(){
               self.present(mailComposeViewController, animated: true)
           }else{
               print("Can't send email")
           }
    }
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["\(detailsModel.email ?? "")"])
        mailComposeVC.setSubject("")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    @IBAction func openMapPressed(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(URL(string:"https://www.google.com/maps/")!))
        {
            UIApplication.shared.openURL(URL(string:
                                                            "https://www.google.com/maps/@\(detailsModel.geoLat ?? ""),\(detailsModel.geoLng ?? ""),6z")!)

        } else
        {
            print("Can't use com.google.maps://");
        }
            
    }
    @IBAction func callPressed(_ sender: Any) {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(detailsModel.phone ?? "")") {
                   let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.openURL(phoneCallURL as URL);
                   }
               }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension UIImageView {
    func setImageFromPath(_ path: String?) {
        image = nil
        DispatchQueue.global(qos: .background).async {
            var image: UIImage?
            guard let imagePath = path else {return}
            if let imageURL = URL(string: APIConstant.imageURL + imagePath) {
                if let imageData = NSData(contentsOf: imageURL) {
                    image = UIImage(data: imageData as Data)
                } else {
                    image = UIImage(named: "noImageAvailable")
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
    func makeRounded() {
            self.layer.borderWidth = 2
            self.layer.masksToBounds = false
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.cornerRadius = self.frame.height / 2
            self.clipsToBounds = true
    }
}
