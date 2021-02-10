//
//  REVEXDataHelper.swift
//  revenueAndExpance
//
//  Created by Vijay on 10/02/21.
//
import Foundation
import SQLite3



var itemId: Int = 0
var itemName: String = ""
var date: String = ""
var isRevenue : Bool = true

let dbPath: String = "myDb.sqlite"
var db:OpaquePointer?

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        print(fileURL.path)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS revexpance (itemid INTEGER PRIMARY KEY, itemname TEXT, date TEXT, isrevenue INTEGER , amount INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("revexpance table created.")
            } else {
                print("revexpance table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(itemName:String, date: String, isRevenue : Int, amount: Int)
    {
        let insertStatementString = "INSERT INTO revexpance (itemid, itemname, date, isrevenue, amount) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(3))
            sqlite3_bind_text(insertStatement, 2, (itemName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(isRevenue))
            sqlite3_bind_int(insertStatement, 4, Int32(amount))
           
           
            if sqlite3_step(insertStatement) == SQLITE_OK {
                print("Successfully inserted row. " )
                
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    func countNoOfItemInDataBase() -> Int
    {
        let selectStatementString = "select COUNT(itemid) from revexpance;"
        var selectStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, selectStatementString, -1, &selectStatement, nil) == SQLITE_OK
        {
            while(sqlite3_step(selectStatement) == SQLITE_ROW){
              let NoOfItemInTable = sqlite3_column_int(selectStatement, 0)
             // print(" NO OF Q: \(NoOfQuetionInTable)")
          return Int(NoOfItemInTable)
          }
        }
        else
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
             
        return 0
    }
    func readAll() -> [RevExpance] {
        let queryStatementString = "SELECT * FROM revexpance;"
        var queryStatement: OpaquePointer? = nil
        var revex : [RevExpance] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let itemId = sqlite3_column_int(queryStatement, 0)
                let ItemName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let isRevenue = sqlite3_column_int(queryStatement, 3)
                let amount = sqlite3_column_int(queryStatement, 4)
                revex.append(RevExpance(itemId: Int(itemId), itemName: ItemName, date: date, isRevenue: Int(isRevenue), amount: Int(amount) ))
                print("Query Result:")
                print("\(itemId) | \(ItemName) | \(date) | \(isRevenue)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return revex
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func readOnlyRevenue() -> [RevExpance]
    {
        let queryStatementString = "SELECT * FROM revexpance WHERE isrevenue=1;"
        var queryStatement: OpaquePointer? = nil
        var revex : [RevExpance] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let itemId = sqlite3_column_int(queryStatement, 0)
                let ItemName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let isRevenue = sqlite3_column_int(queryStatement, 3)
                let amount = sqlite3_column_int(queryStatement, 4)
                revex.append(RevExpance(itemId: Int(itemId), itemName: ItemName, date: date, isRevenue: Int(isRevenue), amount: Int(amount)))
                print("Query Result:")
                print("\(itemId) | \(ItemName) | \(date) | \(isRevenue)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return revex
    }
    
    func readOnlyExpance() -> [RevExpance]
    {
        let queryStatementString = "SELECT * FROM revexpance WHERE isrevenue=0;"
        var queryStatement: OpaquePointer? = nil
        var revex : [RevExpance] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let itemId = sqlite3_column_int(queryStatement, 0)
                let ItemName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let isRevenue = sqlite3_column_int(queryStatement, 3)
                let amount = sqlite3_column_int(queryStatement, 4)
                revex.append(RevExpance(itemId: Int(itemId), itemName: ItemName, date: date, isRevenue: Int(isRevenue), amount: Int(amount)))
                print("Query Result:")
                print("\(itemId) | \(ItemName) | \(date) | \(isRevenue)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return revex
    }
    
}
