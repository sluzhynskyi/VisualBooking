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

    let restView: MacawView = {
        let node = try! SVGParser.parse(path: Constants.svgFileName)
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

    let timeSlider: TimeSlider = {
        let slider = TimeSlider()
        slider.minimumValue = Constants.openTime
        slider.maximumValue = Constants.closeTime
        slider.snapStepSize = Constants.snapTime
        slider.distanceBetweenThumbs = Constants.minimalTimeReservation
        slider.value = Constants.thumbsInitialPosition
        slider.orientation = .horizontal
        slider.valueLabelPosition = .top
        slider.tintColor = Constants.inSlideColor
        slider.outerTrackColor = Constants.outSlideColor
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
        Constants.tableId.forEach { id in
            registerForSelection(nodeTag: id)
        }
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
        self.restView.node.nodeBy(tag: nodeTag)?.onTouchPressed({ (touch) in
            let nodeShape = self.restView.node.nodeBy(tag: nodeTag) as! Shape
            nodeShape.fill = (nodeShape.fill == Constants.tableColor) ? Color.whiteSmoke : Constants.tableColor
            print(nodeTag)
        })
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
//        let dateFormatter: DateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        let selectedDate: String = dateFormatter.string(from: sender.date)
//        print("Selected value \(selectedDate)")
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

    // MARK: - Layout
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
//        datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
    }

    private func setupTimeSliderLayout() {
        timeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        timeSlider.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: -32).isActive = true
        timeSlider.bottomAnchor.constraint(equalTo: restView.topAnchor).isActive = true
    }

}


