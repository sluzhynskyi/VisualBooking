//
//  ViewController.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 10.12.2020.
//

import UIKit
import Macaw
import FirebaseFirestore
class ViewController: UIViewController {


    let restView: MacawView = {
        let node = try! SVGParser.parse(path: "restaurant_with_sofa")
        let view = MacawView(node: node, frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = NSTimeZone.local
        picker.backgroundColor = UIColor.white
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: .valueChanged)
        return picker
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
        setupRestaurantViewLayout()

        view.addSubview(datePicker)
        setupDatePickerLayout()


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
            print(nodeTag)
        })
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {

        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()

        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy"

        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)

        print("Selected value \(selectedDate)")
    }


    private func setupRestaurantViewLayout() {
        restView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        restView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        restView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }

    private func setupDatePickerLayout() {
        datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: restView.topAnchor, constant: -10).isActive = true
    }

}


