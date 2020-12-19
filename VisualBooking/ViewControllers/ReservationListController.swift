//
//  ReservationListController.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 19.12.2020.
//

import Foundation
import UIKit
import Firebase
class ReservationListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let dafaults = UserDefaults.standard
    var userReservations: [Reservation] = []
    var safeArea: UILayoutGuide!
    var characters = ["Link", "Zelda", "Ganondorf", "Midna"]
    @UsesAutoLayout
    var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        FIRFirestoreService.shared.read(from: .reservations, returning: Reservation.self, child: "userId", equal: Auth.auth().currentUser!.uid) { (reservations) in
            self.userReservations = reservations
            self.tableView.reloadData()
        }
        safeArea = view.layoutMarginsGuide
        navigationItem.title = "Reservation List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut(_:)))
        view.addSubview(tableView)
        setupTableView()
    }

    func setupTableView() {
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userReservations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let startime: TimeInterval = userReservations[indexPath.row].startReservation
        let endtime: TimeInterval = userReservations[indexPath.row].endReservation
        let startDate = NSDate(timeIntervalSince1970: startime)
        let endDate = NSDate(timeIntervalSince1970: endtime)
        let formatterStart = DateFormatter()
        let formatterEnd = DateFormatter()
        formatterStart.dateFormat = "dd MMM HH:mm"
        formatterEnd.dateFormat = "HH:mm"

        let fromAndToo = formatterStart.string(from: startDate as Date) + "-" + formatterEnd.string(from: endDate as Date)
        cell.textLabel?.text = fromAndToo
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        return
    }

}

extension ReservationListController {
    @objc func logOut(_ sender: UIBarItem) {
        do {
            try Auth.auth().signOut()
            dafaults.set(false, forKey: "UserIsLoggedIn")
            let loginVC = UINavigationController(rootViewController: LoginController())
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)

        } catch let err {
            print(err.localizedDescription)
        }

    }
}
