# Project-M

### Motivation
Marshalling is super important. In paticular for sending and storing data. Unfortunately, it's often a clunky process and marshalled data ends up having a sub-optimal representation within the code.

## Language features
- Static and explicit types
- All objects _must_ be able to be marshalled. So for example, references to itself are illegal.
- Marshalling is as simple as casting an object to a string and vice versa
- Marshalling, by default, converts all properties to a (maybe JSON format) unless the class overrides the behavior
- Objects inside other objects are marshalled recursively
- If a code file contains a class named `Storage`, an instance of it `storage` will automatically be created
- The `storage` object will automatically be saved and read from a db file, created next to the code file.
- 3 special methods exist to override default marshalling: `from_string`, `to_string` and `setup`
- A class missing an init function, will be attempted to be created from an empty string
- The dict (map) type can be used to catch all the data stored in a string, similar to JS and json

## Examples
### Example 1
```java
class Storage {
  string msg = "hello World"
}

void main() {
  print(storage.msg)
  storage.msg = "hello Project-M"
}
```
#### First run
```
hello World
```
#### Second run
```
hello Project-M
```
#### Explanation
First run:
A db file is missing. `Storage storage = Storage()` is implicitly called. Storage is missing a constructor so this is the same as calling `Storage storage = ""`. The string doesn't specify a value for `storage.msg`, so it's assigned the default value `"hello World"`. `"hello Project-M"` is assigned to `storage.msg`. Before the program exits, the db file is created and `storage` written to the file as `{msg: "Hello Project-M"}`

Second run:
The db file is found. `Storage storage = "{msg: "Hello Project-M"}"` is implicitly called, and this time the default value isn't needed.

### Example 2
```java
class AddTwo {
  int left
  int right
  int result = None

  AddTwo(int a, int b) {
    left = a
    right = b
    result = left + right
    print("Constructor called")
  }
  
  setup() {
    if result == None {
      AddTwo(left, right)
    }
  }
}

void main() {
  AddTwo a = "{"left":5, "right":10}"
  print(a.result)
  AddTwo b = "{"left":5, "right":10, "result":20}"
  print(b.result)
  AddTwo c = "{"left":5, "right":10, "mystery":20}"
  print(c.result)
  AddTwo d = "{"left":5, "result":20}"
  print(d.result)
}
```
#### Run
```
Constructor called
15
20
Constructor called
15
<Exception is thrown here>
```
#### Explanation
Keep in mind, `setup` is only called when we create the object from a string, it shouldn't be confused with the constructor.
When `a` is created, result is assigned the default value of `None`. Therefore when `setup` is called, it calls the constructor which makes sure to assign a proper value to `result`. When `b` is created, the string already contains a value for `result` (albeit wrong), and therefore the constructor doesn't need to be called. `c` is created the same way as `a` except that a mystery value appears in the string. Extra values in the string are ignored though. `d` fails to be created because a default value doesn't exist for `right`


### Example 3
```java

class SearchResults {
  string query
  list<SearchResult> results
  int len = list.len()
  dict meta = None
}

class SearchResult {
  string title
  string desc
  string firstWord = None
  
  setup() {
    firstWord = desc.split(" ").first()
  }
}

string getResults() {
  http.get("https://api.google.com/search?q=cats")
}

void main() {
  SearchResults res = getResults()
}
```
#### Explanation
`res.len` will contain how many search results there are, and the first word in the description of the third results is in `res.results[2].firstWord`. Any arbitrary data that the API returned as `meta` has been stored in `res.meta` 

### Example 4
```java
class Member {
  string name
  int points
  
  Member(string memName) {
  name = memName
  points = 0
  }
}

string readDB() {
  return db.getMember()
}

setDB(string Member) {
  db.setMember(string)
}

void main() {
  member = Member("Astolfo")
  setDB(member)
  print(member.points)
}
```
#### First run
```
0
```
#### The code changed!!!
```java
class Member {
  string name
  int points
  string favColor = None
  boolean premium = False
  
  Member(string memName) {
    name = memName
    points = 0
    setup()
  }
  
  setup() {
    if not favColor {
      favColor = requestFavColor()
    }
  } 
}

string readDB() {
  return db.getMember()
}

setDB(string Member) {
  db.setMember(string)
}

void main() {
  member = ReadDB()
  print(member.name)
  print(member.premium)
}
```
#### Second run
```
astolfo
False
```
#### Explanation
Even though we changed the member class, by adding appropriate default values and the setup function, we could still use the old data.
