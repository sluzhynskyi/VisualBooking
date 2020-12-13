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

    var reservations: [Reservation] = []

    @UsesAutoLayout
    var restaurantView: MacawView = {
        let node = try! SVGParser.parse(path: Constants.svgFileName)
        let view = MacawView(node: node, frame: CGRect.zero)
        return view
    }()

    @UsesAutoLayout
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = NSTimeZone.local
        picker.backgroundColor = UIColor.white
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }()
    @UsesAutoLayout
    var inputDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Pick a Day"
        textField.textAlignment = .center
        textField.layer.zPosition = 2
        return textField
    }()
    @UsesAutoLayout
    var timeSlider: MultiSlider = {
        let slider = MultiSlider()
        slider.minimumValue = Constants.openTime
        slider.maximumValue = Constants.closeTime
        slider.snapStepSize = Constants.snapTime
        slider.distanceBetweenThumbs = Constants.minimalTimeReservation
        slider.value = Constants.thumbsInitialPosition
        slider.orientation = .horizontal
        slider.valueLabelPosition = .top
        slider.tintColor = Constants.inSlideColor
        slider.outerTrackColor = Constants.outSlideColor
        slider.layer.zPosition = 1
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged) // continuous changes
        slider.addTarget(self, action: #selector(sliderDragEnded(_:)), for: . touchUpInside) // sent when drag ends
        return slider
    }()
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        [restaurantView, inputDateTextField, timeSlider].forEach { view.addSubview($0) }
        setupRestaurantViewLayout()
        setupDatePickerLayout()
        setupTimeSliderLayout()


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.tableId.forEach { id in
            registerForSelection(nodeTag: id)
        }
        datePicker.frame = CGRect(x: view.frame.minX, y: view.frame.maxY - 250, width: view.frame.width, height: 250)
        inputDateTextField.inputView = datePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOutsideDate(_:)))
        view.addGestureRecognizer(tapGesture)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let st = formatter.date(from: "2020/12/12 18:30")!
//        let end = formatter.date(from: "2020/12/12 19:30")!
//        let DanyloId = "vP2s62SjcTq3FOVaKhDE"
//
//        let r1 = Reservation(userId: DanyloId, tableId: "1", startReservation: st, endReservation: end)
//        FIRFirestoreService.shared.create(for: r1, in: .reservations)
//        print("LOADED")

    }

    private func registerForSelection(nodeTag: String) {
        self.restaurantView.node.nodeBy(tag: nodeTag)?.onTouchPressed({ (touch) in
            let nodeShape = self.restaurantView.node.nodeBy(tag: nodeTag) as! Shape
            nodeShape.fill = (nodeShape.fill == Constants.tableColor) ? Color.whiteSmoke : Constants.tableColor
            print(nodeTag)
        })
    }
    @objc func tappedOutsideDate(_ sender: UIView) {
        inputDateTextField.endEditing(true)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy"
        inputDateTextField.text = dateFormatter.string(from: datePicker.date)
        inputDateTextField.endEditing(true)
    }

    // MARK:- Slider functions
    @objc func sliderChanged(_ slider: MultiSlider) {
        let dateOfDay = Calendar.current.startOfDay(for: datePicker.date)
        let values = slider.value.map { (dateOfDay + TimeInterval(Int($0) * 60)).timeIntervalSince1970 }
        let start = values[0], end = values[1]

        FIRFirestoreService.shared.read(from: .reservations, returning: Reservation.self, orderBy: "startReservation", startAt: [start], endAt: [end]) { (reservations) in
            self.reservations = reservations
        }
        print(self.reservations)
    }

    @objc func sliderDragEnded(_ sender: MultiSlider) {
//        print(sender.value)
    }

    // MARK: Layout

    // Restourant view constraints
    private func setupRestaurantViewLayout() {
        let constraints = [
            restaurantView.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 20),
            restaurantView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restaurantView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            restaurantView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
//            restaurantView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func setupDatePickerLayout() {
        let constraints = [
            inputDateTextField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            inputDateTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputDateTextField.heightAnchor.constraint(equalToConstant: 50),
            inputDateTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func setupTimeSliderLayout() {
        let constraints = [
            timeSlider.topAnchor.constraint(equalTo: inputDateTextField.bottomAnchor, constant: 10),
            timeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ]
        NSLayoutConstraint.activate(constraints)
    }

}


