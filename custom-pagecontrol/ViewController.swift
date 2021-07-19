//
//  ViewController.swift
//  custom-pagecontrol
//
//  Created by user195713 on 7/18/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var pageControll: SnapPageControll!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollview.delegate = self
        scrollview.isPagingEnabled = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let contentSize = CGSize(width: scrollview.bounds.width * 3, height: scrollview.bounds.height)
        scrollview.contentSize = contentSize
    }
}
extension ViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollview.bounds.width
        let progressInPage = scrollview.contentOffset.x - (page * scrollview.bounds.width)
        let progress = CGFloat(page) + progressInPage
        print(progress)
        pageControll.progress = progress
    }
}

