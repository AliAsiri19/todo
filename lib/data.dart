
// Fack data for testing
//List<Todo> items = [];
//
//  ..add(Todo('Repair your car'))
//  ..add(Todo('buy mom\'s gift'))
//  ..add(Todo('Send email tro friends'))
//  ..add(Todo('Complete your work report'))
//  ..add(Todo('Lorem Ipsum is simply dummy text of the printing '));
//



class Todo {
  // private _todo Fields
  int _id ;
  String _body;
  bool _isCompleted = false;

  // Constructors
  Todo(this._body);
  // Name Constructor
  Todo.all(this._id,this._body,this._isCompleted);


  // setters all private fields.
  set id(int value) { _id = value; }
  set body(String value) {  _body = value;  }
  set isCompleted(bool value) { _isCompleted = value; }

  // getters all private fields to caller
  int get id => _id;
  String get body => _body;
  bool get isCompleted => _isCompleted;

///  Convert (todo object to map prepare to save it in database table
  Map<String,dynamic> toMap(){
    Map map = Map<String,dynamic>();
    map['id']= this._id;
    map['body']= this._body;
    // replace true|false to 1:0 prepare to database .
    map['isCompleted']= this._isCompleted ? 1 : 0;
    return map;
  }

  // Named constructor - to convert map to Todo oject.
  // normally when get from query to Todo
  Todo.fromMapObject(Map<String,dynamic> map){
    this._id = map['id'];
    this._body = map['body'];
    // reconvert 1:0 to true:false
    this._isCompleted = map['isCompleted']==1 ? true : false;
  }
}