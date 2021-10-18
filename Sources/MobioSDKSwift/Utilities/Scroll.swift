//
//  File.swift
//  
//
//  Created by LinhNobi on 13/10/2021.
//

import UIKit
import Combine

public class Scroll: NSObject {
    static let shared = Scroll()
    public func trackScrollView(_ scrollView: UIScrollView) {
        scrollView.delegate = self
    }
}

extension Scroll: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let height = scrollView.contentSize.height
        let viewed = scrollView.contentOffset.y + scrollView.bounds.size.height
        let pagePercentScrolled = viewed / height * 100

        print("precent \(Int(pagePercentScrolled))")
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        //        let height = scrollView.contentSize.height
        //            let viewed = scrollView.contentOffset.y + scrollView.bounds.size.height
        //            let pagePercentScrolled = viewed / height * 100.0
        //        print("precent \(pagePercentScrolled)")
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    
}
