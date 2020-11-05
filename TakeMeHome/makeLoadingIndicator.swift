//
//  Loading.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/05.
//

import Foundation
import NVActivityIndicatorView

func makeLoadingIndicator() {
   let indicator = NVActivityIndicatorView(frame: CGRect(x: 162, y: 100, width: 50, height: 50),
                                           type: .circleStrokeSpin,
                                           color: .black,
                                           padding: 0)
}

