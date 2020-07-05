import Foundation
import RealmSwift

class RealmHelper {
    static let instance = RealmHelper()

    private init() {}

    func saveObjects<T: Object>(_ objects: [T]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(objects, update: .all)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func getObjects<T: Object>()->[T] {
        let realm = try! Realm()
        let realmResults = realm.objects(T.self)
        return Array(realmResults)

    }
    
    func getObjects<T: Object>(filter: String)->[T] {
        let realm = try! Realm()
        let realmResults = realm.objects(T.self).filter(filter)
        return Array(realmResults)

    }
    
    func cleanRealm() {
        do {
            let realm = try Realm()
            try! realm.write {
                realm.deleteAll()
            }
        } catch {
                print(error)
        }
    }
}
