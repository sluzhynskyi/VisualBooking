//
//  ViewController.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 10.12.2020.
//

import UIKit
import Macaw

class ViewController: UIViewController {
    @IBOutlet weak var svgView: SVGView!
    var tableId = [
        "0",
        "1",
        "2",
        "3",
        "4",
        "5"
    ]
    var tableColour = Color(0x56595f)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableId.forEach { id in
            registerForSelection(nodeTag: id)
        }
    }

    private func registerForSelection(nodeTag: String) {
        self.svgView.node.nodeBy(tag: nodeTag)?.onTouchPressed({ (touch) in
            let nodeShape = self.svgView.node.nodeBy(tag: nodeTag) as! Shape
            nodeShape.fill = (nodeShape.fill == self.tableColour) ? Color.red : self.tableColour
        })
    }

}


