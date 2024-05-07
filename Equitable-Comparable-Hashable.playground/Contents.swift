import Cocoa

var greeting = "Hello, playground"


// --------------------------------------------------------------------------------------------------------------------------------------------------------------  //

// Equatable - A type that can be compared for value equality.


// For a struct, all its stored properties must conform to Equatable.
// For an enum, all its associated values must conform to Equatable. (An enum without associated values has Equatable conformance even without the declaration.)

struct Product: Equatable{
    var name: String
    var type: String
    var id: Int
}

let pr1 = Product(name: "Iphone", type: "Apple", id: 1)
let pr2 = Product(name: "Iphone", type: "Apple", id: 1)
let pr3 = Product(name: "Iphone", type: "Apple", id: 2)
let pr4 = Product(name: "Camera", type: "DSLR", id: 0)

pr1 == pr2  // true
pr1 == pr3  // false
pr2 == pr4  // false
 

//Note - Binary operator '==' cannot be applied to two 'Product' operands  // if not conform to type Equatable



struct User: Equatable {
    public static func == (lhs: Self, rhs: Self)-> Bool {   // Here Self is used not self and we can also write User in place of Self
        return lhs.userName == rhs.userName
    }
    var userName: String
    var followers: Int
    var createdAt: Date
}

/*  This is another way using extension
 
 extension User: Equatable {
    public static func == (lhs: Self, rhs: Self)-> Bool {
        return lhs.userName == rhs.userName
    }
}
*/


let user1 = User(userName: "qwerty", followers: 0, createdAt: Date())
let user2 = User(userName: "qwerty", followers: 10, createdAt: Date())  // the date in the above abject is different from this object so both object are not unique.
let user3 = User(userName: "qwerty", followers: 12, createdAt: Date())
 
print(user1 == user2) // true because username is same for both as it checks only username on the basis of above static == function.

let userArray = [user1, user2]

userArray.contains(user3) // true --- since you can see above user3 is not in array but still it returned us true. The reason is beacuse of above static func == it returned                                    us true because it has only chacked username of user3 and it is there in an array.

// Note: In this we have defined what eqality operator(==) will check in our object. In above example it will only compare username


struct Moon<T>{
    let name: T
}


extension Moon: Equatable where T: Equatable {
    static func == (lhs: Moon<T>, rhs: Moon<T>) ->Bool {
        return lhs.name == rhs.name
    }
}

let planetOneMoons = [Moon<String>(name: "Moons")]
let planetTwoMoons = [Moon<String>(name: "Moons")]
 
planetOneMoons == planetTwoMoons   // true


// ------------------------------------------------------------------------------------------------------------------------------------------------------------- //



// Comparable

// protocol Comparable: Equatable - helps in comparing ( <, >, <=, >= ) and sorting custom class object.

struct Employee: Comparable {
    static func < (lhs: Employee, rhs: Employee) -> Bool {
         if lhs.age < rhs.age {
            return true
        }
        return false
    }
    
    let name: String
    let age: Int
}

let person1 = Employee(name: "AB", age: 10)
let person2 = Employee(name: "BA", age: 13)
let person3 = Employee(name: "CA", age: 12)
let person4 = Employee(name: "AD", age: 10)

// this calculates on the basis of age
if person1 < person2 {
    print("person1 age is less than person2")
}

//  this calculates on the basis of age
if person2 > person3 {
    print("person2 age is greater than person1")
}

// this <= and >= works in struct but not in class for that you need to implement static func == in class.
if person1 <= person4 {
    print("person1 age is equal to person4 age")
}


let personList = [person1, person2, person3]

let newList = personList.sorted() // sorted in ascending order of age
print(newList)

let newList1 = personList.sorted(by: >) // descending order of age
print(newList1)





// class must also implement static func == beacuase which is not necessary in case of Struct.

class Student: Comparable {
    static func == (lhs: Student, rhs: Student) -> Bool {
        return lhs.age == rhs.age
    }
    
    static func < (lhs: Student, rhs: Student) -> Bool {
         if lhs.age < rhs.age {
            return true
        }
        return false
    }
    
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

let st1 = Student(name: "A", age: 1)
let st2 = Student(name: "B", age: 2)
let st3 = Student(name: "C", age: 1)

if st1 <= st3 {
    print("age is same")
}




 // ------------------------------------------------------------------------------------------------------------------------------------------------------------- //

// Hashable

// Hashable: Equatable -> Hashable conforms to Equatable protocol


// Hashable with class
class Test: Hashable {   // our custom type hashabale
    static func == (lhs: Test, rhs: Test) -> Bool {
        return lhs.id == rhs.id
    }
    
    // we can also create this hash function in struct if we want to customize the stored property of a struct to conform to hashing type
    func hash(into hasher: inout Hasher) {  // these are the property which will be hashed......1->id. Approach by which we are hashing the stored property of class. We can                                         hash more than one stored property here. Here we have only hashed our id property.
    hasher.combine(id)
        
    }
    
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

let dict: [Test: String] = [:]




// Hashable with struct
struct StructTest: Hashable {
    let id: Int
    let name: String
}

let structDict: [StructTest: String] = [:]

let s1 = StructTest(id: 1, name: "1")
let s2 = StructTest(id: 1, name: "2")
let s3 = StructTest(id: 1, name: "1")

print(s1.hashValue)
print(s2.hashValue)
print(s3.hashValue)

// s1 and s3 have same hash-value because both objects are unique.
// s2 has a different hash-value.



// Hashable with enum
enum TestEnum: Int {
    case test1
    case test2
}


let enumDict: [TestEnum: String] = [:]

// Set -> Values are unique should conform to hashing
// Dictionary -> Key should be unique and it should also conform to hashable if using custom type because key uses hashing approach to store it's key.



let mySet: Set<Test> = [Test(id: 1, name: "1"), Test(id: 2, name: "2"), Test(id: 1, name: "1")]
mySet.count  // Here we can see we have added 3 objects but our output only shows 2 becuase only 2 are unique as it conforms to hashable type.

let mySet2: Set<Test> = [Test(id: 1, name: "1"),Test(id: 1, name: "2"),Test(id: 1, name: "3")]
mySet2.count  // Now above you can see we have added 3 objects which are not unique but still it shows count as 1. The reason is because only our id property is hashed                    and it is not unique in every case. To show the count as 3 our name property should also be hashed.


// To make both property hashed we can do it like shown in AnotherTest class down.

class AnotherTest: Hashable {   // our custom type hashabale
   
    static func == (lhs: AnotherTest, rhs: AnotherTest) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {  // making both the proerty hashed.
    hasher.combine(id)
    hasher.combine(name)
        
    }
    
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

let anotherSet: Set<AnotherTest> = [AnotherTest(id: 1, name: "1"), AnotherTest(id: 1, name: "2"),AnotherTest(id: 1, name: "3")]
anotherSet.count   // the count is 3 here since all objects are unique.


