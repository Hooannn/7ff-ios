//
//  ViewControllerWithoutNavigationBar.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 20/08/2023.
//

import UIKit


class ViewControllerWithoutNavigationBar: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
