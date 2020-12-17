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
    var reservationsInTimeRange: [Reservation] = []
    var tables: [Table] = []

    var user: User!
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
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(pickedDay(_:)), for: .valueChanged)
        return picker
    }()

    @UsesAutoLayout
    var inputDateTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = UIColor.white

        textField.backgroundColor = Constants.backgroundColor

        textField.layer.borderColor = Constants.borderColor
        textField.borderStyle = .none
        textField.layer.borderWidth = 0.25

        textField.layer.zPosition = 2

//        textField.layer.cornerRadius = 4



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
        slider.labelColor = .black
        slider.layer.zPosition = 1
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged) // continuous changes
        slider.addTarget(self, action: #selector(sliderDragEnded(_:)), for: . touchUpInside) // sent when drag ends
        return slider
    }()

    @UsesAutoLayout
    var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit reservation", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)

        button.backgroundColor = Constants.backgroundColor

        button.layer.borderColor = Constants.borderColor
        button.layer.borderWidth = 0.25

        return button
    }()
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        inputDateTextFieldPreparation()
        [restaurantView, inputDateTextField, timeSlider, submitButton].forEach { view.addSubview($0) }
        setupRestaurantViewLayout()
        setupDatePickerLayout()
        setupTimeSliderLayout()
        setupButtonLayout()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [inputDateTextField, submitButton].forEach { $0.addShadow(); $0.addCorners() }
        Constants.tableId.forEach { tables.append(Table(id: $0, node: restaurantView.node.nodeBy(tag: $0)!)) }
        user = User(name: "Danylo", phone: "0638800949")
        FIRFirestoreService.shared.create(for: user, in: .users)


    }
    // MARK: SVG updating function
    func renderRestaurantTablesStatus(on view: MacawView, from reservationsList: [Reservation]) {
        tables.forEach { table in
            if (table.node as! Shape).fill == Constants.tableReservedColor {
                (table.node as! Shape).fill = Constants.tableColor
            }
        }
        let reservedTables = reservationsList.map { $0.tableId }
        tables.forEach {
            if reservedTables.contains($0.id) {
                ($0.node as! Shape).fill = Constants.tableReservedColor
            }
        }
    }
    // MARK: SVG FIlling node functions
    private func registerForSelectionToggle(with id: String, baseColor: Color, toggleColor: Color) {
        tables.first { $0.id == id }!.node.onTouchPressed({ (touch) in
            let nodeShape = self.tables.first { $0.id == id }!.node as! Shape
            let color = (nodeShape.fill == baseColor) ? toggleColor : baseColor
            nodeShape.fill = color
            print("tapping")
        })
    }

    // MARK: InputTextField functions
    private func inputDateTextFieldPreparation() {
        pickedDay(datePicker)
        inputDateTextField.inputView = datePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOutsideDate(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func tappedOutsideDate(_ sender: UIView) {
        inputDateTextField.endEditing(true)
    }


    @objc func pickedDay(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy"
        inputDateTextField.text = dateFormatter.string(from: datePicker.date)
        inputDateTextField.endEditing(true)

        let values = getStartEndTimeValues(dayPicker: datePicker, leftRange: Constants.openTime, rightRange: Constants.closeTime)
        let start = values[0], end = values[1]

        FIRFirestoreService.shared.read(from: .reservations, returning: Reservation.self, orderBy: "startReservation", startAt: [start], endAt: [end]) { (reservations) in
            self.reservations = reservations
            self.reloadReservations(slider: self.timeSlider, dayPicker: self.datePicker)
            self.renderRestaurantTablesStatus(on: self.restaurantView, from: self.reservationsInTimeRange)
            self.setUpHandlers()
        }

    }

    // MARK: Hellper functions

    func getStartEndTimeValues<T:BinaryFloatingPoint>(dayPicker: UIDatePicker, leftRange: T, rightRange: T) -> [TimeInterval] {
        let dateOfDay = Calendar.current.startOfDay(for: dayPicker.date)
        let values = [leftRange, rightRange].map { (dateOfDay + TimeInterval(Int($0) * 60)).timeIntervalSince1970 }
        return values
    }
    func reloadReservations(slider: MultiSlider, dayPicker: UIDatePicker) {
        let values = getStartEndTimeValues(dayPicker: dayPicker, leftRange: slider.value[0], rightRange: slider.value[1])
        let start = values[0], end = values[1]
        reservationsInTimeRange = reservations.filter { (start < $0.startReservation) && (end > $0.endReservation) }
    }

    func setUpHandlers() {
        print(reservationsInTimeRange)
        tables.forEach { table in
            table.node.remveAllTouchPressedHanders()
            registerForSelectionToggle(with: table.id, baseColor: Constants.tableColor, toggleColor: Color.white)
        }
        reservationsInTimeRange.forEach { reservation in
            tables.first { $0.id == reservation.tableId }?.node.remveAllTouchPressedHanders()
        }
    }

    // MARK: Slider functions
    @objc func sliderChanged(_ slider: MultiSlider) {
        reloadReservations(slider: slider, dayPicker: datePicker)
        renderRestaurantTablesStatus(on: restaurantView, from: reservationsInTimeRange)
        print("sliderChanged")
    }

    @objc func sliderDragEnded(_ sender: MultiSlider) {
        setUpHandlers()
        print("slider Drag ended")
    }

    // MARK: Layout

    // Restourant view constraints
    private func setupRestaurantViewLayout() {
        let constraints = [
            restaurantView.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: -20),
            restaurantView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restaurantView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
//            restaurantView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
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
            timeSlider.topAnchor.constraint(equalTo: inputDateTextField.bottomAnchor, constant: 25),
            timeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func setupButtonLayout() {
        let constraints = [
            submitButton.topAnchor.constraint(equalTo: restaurantView.bottomAnchor, constant: 10),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        ]
        NSLayoutConstraint.activate(constraints)
    }

}


