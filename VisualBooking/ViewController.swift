//
//  ViewController.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 10.12.2020.
//

import UIKit
import Macaw
import FirebaseFirestore
import MultiSlider
class ViewController: UIViewController {
    var tableColor = Color(0x56595f)
    var slideColor = UIColor(hex: "#c6b8a7ff")
    var tableId = [
        "0",
        "1",
        "2",
        "3",
        "4",
        "5"
    ]


    let restView: MacawView = {
        let node = try! SVGParser.parse(path: "restaurant_croped")
        let view = MacawView(node: node, frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = NSTimeZone.local
        picker.backgroundColor = UIColor.white
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }()

    let timeSlider: MultiSlider = {
        let slider = MultiSlider()
        slider.minimumValue = 0 // default is 0.0
        slider.maximumValue = 720 // default is 1.0
        slider.snapStepSize = 15
        slider.distanceBetweenThumbs = 90
        slider.valueLabelPosition = .top
        slider.orientation = .horizontal // default is .vertical
        slider.tintColor = UIColor(hex: "#c6b8a7ff")
        slider.value = [1, 720]
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged) // continuous changes
        slider.addTarget(self, action: #selector(sliderDragEnded(_:)), for: . touchUpInside) // sent when drag ends
        slider.translatesAutoresizingMaskIntoConstraints = false

        return slider
    }()
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        [restView, datePicker, timeSlider].forEach { view.addSubview($0) }
        setupRestaurantViewLayout()
        setupDatePickerLayout()
        setupTimeSliderLayout()


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
            nodeShape.fill = (nodeShape.fill == self.tableColor) ? Color.red : self.tableColor
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
    @objc func sliderChanged(_ slider: MultiSlider) {
        print("thumb \(slider.draggedThumbIndex) moved")
        print("now thumbs are at \(slider.value)") // e.g., [1.0, 4.5, 5.0]
    }
    @objc func sliderDragEnded(_ sender: MultiSlider) {
        print(sender.value)
    }


    private func setupRestaurantViewLayout() {
        restView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        restView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        restView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
    }

    private func setupDatePickerLayout() {
        datePicker.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: timeSlider.topAnchor).isActive = true
    }

    private func setupTimeSliderLayout() {
        timeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        timeSlider.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: -32).isActive = true
        timeSlider.bottomAnchor.constraint(equalTo: restView.topAnchor).isActive = true
    }

}


