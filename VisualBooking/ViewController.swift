//
//  ViewController.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 10.12.2020.
//

import UIKit
import Macaw

class ViewController: UIViewController {
    var restView: MacawView = {
        let node = try! SVGParser.parse(path: "restaurant")
        let view = MacawView(node: node, frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var tableId = [
        "0",
        "1",
        "2",
        "3",
        "4",
        "5"
    ]
    var tableColour = Color(0x56595f)
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        view.addSubview(restView)
        restView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restView.centerYAnchor .constraint(equalTo: view.centerYAnchor).isActive = true
        restView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        restView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableId.forEach { id in
            registerForSelection(nodeTag: id)
        }
    }

    private func registerForSelection(nodeTag: String) {
        self.restView.node.nodeBy(tag: nodeTag)?.onTouchPressed({ (touch) in
            let nodeShape = self.restView.node.nodeBy(tag: nodeTag) as! Shape
            nodeShape.fill = (nodeShape.fill == self.tableColour) ? Color.red : self.tableColour
        })
    }

}


