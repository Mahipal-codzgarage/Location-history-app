//
//  DatabaseManager.swift
//  LocationHistoryApp
//
//  Created by Mahipal sinh on 10/07/21.
//

import Foundation
import FMDB

// MARK: - Database Manager
class DatabaseManager: NSObject {
    
    private let storyTemplateFileName = "LocationHistoryDB.db"
    private var database = FMDatabase()
    var databasePath: String = ""
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    struct SharedInstance {
        static let instance = DatabaseManager()
    }
    
    class var shared: DatabaseManager {
        return SharedInstance.instance
    }
    
    override init() {
        super.init()
        
        self.copyDBFile(storyTemplateFileName)
    }
    
    // copy database into document directory
    func copyDBFile(_ fileName: String) {
        
        let dbPath: String = getPath(fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            
            do {
                databasePath = dbPath
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch let error as NSError {
                print(error.description)
            }
            
        } else {
            databasePath = dbPath
        }
    }
    
    // get database path
    func getPath(_ fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        print("dbpath \(fileURL.path)")
        return fileURL.path
    }
    
    // Open database
    func openUserStoryDatabase() -> Bool {
        
        if FileManager.default.fileExists(atPath: databasePath) {
            database = FMDatabase(path: databasePath)
        }
        if database.open() {
            return true
        }
        return false
    }
    
    //MARK: - Database CRUD Operation
    func insertLocationRecord(address: String,place placeId: String, getLatitude latitude: Double, getLongitude longitude: Double, getDate date: String, getTime time: String, getNote note: String, completionHandler: CompletionHandler) {
        
        database = FMDatabase(path: databasePath)
        if openUserStoryDatabase() {
            do {
                try database.executeUpdate("insert into History (address, place_id, latitude, longitude, date, time, note) values (?,?,?,?,?,?,?)", values: [address, placeId, latitude, longitude, date, time, note])
                completionHandler(true)
            } catch {
                print("insert template error = \(error)")
                completionHandler(false)
            }
        }
        database.close()
    }
    
    func fetchLocationRecord(query getQuery: String) -> [[AnyHashable: Any]] {
        
        var dataArray = [[AnyHashable: Any]]()
        database = FMDatabase(path: databasePath)
        if openUserStoryDatabase() {
            if let rs = database.executeQuery(getQuery, withArgumentsIn: []) {
                while rs.next() {
                    dataArray.append(rs.resultDictionary ?? [AnyHashable: Any]())
                }
            } else {
                print("select failure: \(database.lastErrorMessage())")
            }
        }
        database.close()
        return dataArray
    }
    
    func deleteLocation(getPlaceId: String) {
        
        database = FMDatabase(path: databasePath)
        if openUserStoryDatabase() {
            database.executeStatements("DELETE FROM History WHERE place_id = '\(getPlaceId)'")
        }
        database.close()
    }
    
    func updateNote(getNote: String, placeId: String) {
        
        database = FMDatabase(path: databasePath)
        if openUserStoryDatabase() {
            do {
                try database.executeUpdate("UPDATE History SET note=? WHERE place_id=?", values: [getNote, placeId])
            } catch {
                print("update error = \(error.localizedDescription )")
            }
        }
        database.close()
    }
}
