//
//  FIRFirestoreService.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 11.12.2020.
//

import Foundation
import Firebase
import FirebaseFirestore


protocol FirebaseObject {
    var id: String? { get set }
}


class FIRFirestoreService {
    private init() { }
    static let shared = FIRFirestoreService()

    func configure() {
        FirebaseApp.configure()
    }

    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }

    func create<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            reference(to: collectionReference).addDocument(data: json)
        } catch {
            print(error)
        }
    }

    func read<T: Decodable>(from collectionReference: FIRCollectionReference, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        reference(to: collectionReference).addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            do {
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self, includingId: true)
                    objects.append(object)
                }
                completion(objects)
            } catch {
                print(error)
            }


        }

    }

    func update<T:Encodable & FirebaseObject>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            guard let id = encodableObject.id else { throw JsonError.identificationError }
            reference(to: collectionReference).document(id).setData(json)
        } catch {
            print(error)
        }


    }
    func delete<T:FirebaseObject>(_ firebaseObject: T, in collectionReference: FIRCollectionReference) {
        do {
            guard let id = firebaseObject.id else { throw JsonError.identificationError }
            reference(to: collectionReference).document(id).delete()
        } catch {
            print(error)
        }
    }

}
