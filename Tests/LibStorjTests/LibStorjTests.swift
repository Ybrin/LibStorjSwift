//
//  LibStorjTests.swift
//  LibStorj
//
//  Created by Koray Koska on 07/09/2017.
//
//

import XCTest
@testable import LibStorj

class LibStorjTests: XCTestCase {

    static let allTests = [
        ("testMnemonic", testMnemonic),
        ("testGetInfo", testGetInfo),
        ("testBuckets", testBuckets)
    ]

    var libStorj: LibStorj!

    override func setUp() {
        let user = "libstorj@trash-mail.com"
        let pass = "libstorj"
        let mnemonic = "punch shed page indicate rival same defense first oppose focus cricket asthma park since liberty menu immune fix item kick palace friend gloom maple"

        let b = StorjBridgeOptions(proto: .https, host: "api.storj.io", port: 443, user: user, pass: pass)
        let e = StorjEncryptOptions(mnemonic: mnemonic)

        libStorj = LibStorj(bridgeOptions: b, encryptOptions: e)

        XCTAssertNotNil(libStorj)
    }

    func testMnemonic() throws {
        let mn = LibStorj.mnemonicGenerate(strength: 128)
        // print(mn)
        XCTAssertNotNil(mn)

        // Test check mnemonic
        XCTAssert(LibStorj.mnemonicCheck(mnemonic: mn!))

        XCTAssertFalse(LibStorj.mnemonicCheck(mnemonic: "abc def ghi jkl mno pqr stu vwx yz"))
    }

    func testGetInfo() throws {
        let success = libStorj.getInfo() { (success, req) in
            print("PRINTING SUCCESS: \(success)")
            print("SUCCESS!")
            let resp = try? req.response?.serialize().makeString() ?? ""
            // print(resp ?? "***")

            XCTAssertNotNil(resp)
        }

        XCTAssert(success)
    }

    func testBuckets() throws {
        let buckName = UUID().uuidString
        let createBucketSuccess = libStorj.createBucket(name: buckName) { (success, req) in
            XCTAssertEqual(req.bucketName, buckName)
            XCTAssert(success)
            XCTAssertEqual(req.statusCode, 201)

            XCTAssertNotNil(req.bucket.name)
            XCTAssertEqual(req.bucket.name, buckName)

            XCTAssertNotNil(req.bucket.id)

            let r = self.libStorj.getBucket(id: req.bucket.id!, completion: { (s, re) in
                XCTAssert(s)

                // Check id
                XCTAssertEqual(req.bucket.id, re.response?["id"]?.string)
            })
            XCTAssert(r)
        }
        XCTAssert(createBucketSuccess)

        let getBucketsSuccess = libStorj.getBuckets { (success, req) in
            for b in req.buckets {
                XCTAssertNotNil(b.id)
                XCTAssertNotNil(b.created)
                let deleted = self.libStorj.deleteBucket(id: b.id!, completion: { (s, re) in
                    XCTAssert(s)
                })
                XCTAssert(deleted)
            }

            // All buckets should be deleted now
            let bucketsSuccess = self.libStorj.getBuckets(completion: { (s, re) in
                XCTAssert(s)
                XCTAssertEqual(re.totalBuckets, 0)
            })
            XCTAssert(bucketsSuccess)
        }
        XCTAssert(getBucketsSuccess)
    }

    func testFiles() throws {
        // Create a tmp file

        // Create tmp bucket
        let buckName = UUID().uuidString
        print("BUCKNAME: \(buckName)")
        let createBucketSuccess = libStorj.createBucket(name: buckName) { (success, req) in
            XCTAssert(success)
            let id = req.bucket.id ?? ""
            print("BUCKETID: \(id)")

            let uploadSuccess = self.libStorj.uploadFile(
                bucketId: id,
                fileName: "blabla.txt",
                filePath: "tmpPath",
                progress: { (progress, bytes, totalBytes) in
                    print("PROGRESS: \(progress)")
                    print("BYTES: \(bytes)")
                    print("TOTALBYTES: \(totalBytes)")},
                completion: { success, fileId in
                    XCTAssert(success)
                    XCTAssertNotNil(fileId)
                    print("FILEID: \(fileId ?? "***")")

                    // Delete bucket after we are done...
                    let deleted = self.libStorj.deleteBucket(id: id, completion: { (s, re) in
                        XCTAssert(s)
                    })
                    XCTAssert(deleted)}
            )

            XCTAssert(uploadSuccess)
        }
        XCTAssert(createBucketSuccess)
    }
}
