import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/user_model.dart';

class AuthService{

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final CollectionReference _userCollection= FirebaseFirestore.instance.collection('users');


  Future <UserCredential?>registerUser(UserModel user)async{

    UserCredential userData= await FirebaseAuth.instance.createUserWithEmailAndPassword(
       email: user.email.toString(), 
       password:user.password.toString());
       FirebaseFirestore.instance
                      .collection('users')
                      .doc(userData.user!.uid)
                      .set({
                        'uid' : userData.user!.uid,
                        'email':userData.user!.email,
                        'name':user.name,
                        'createAt':user.createdAt,
                        'status':user.status
                      });

    return userData;

  }

  //add

  //login//save the data to shared pref
 Future<DocumentSnapshot?> loginUser(UserModel user) async {
  try {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: user.email.toString(),
      password: user.password.toString(),
    );

    String? token = await userCredential.user!.getIdToken(); 
    if (token != null) {
      DocumentSnapshot snap = await _userCollection.doc(userCredential.user!.uid).get();
      if (snap.exists) {
        await _pref.setString('token', token);
        await _pref.setString('name', snap['name']);
        await _pref.setString('email', snap['email']);
        await _pref.setString('uid', snap['uid']);
        return snap;
      }
    }
  } catch (e) {
    print('Failed to log in and fetch user data: $e');
    throw e;
  }
  return null;
}

 
  //logout
  Future<void>logout()async{
    SharedPreferences _pref=await SharedPreferences.getInstance();
    await _pref.clear();
    await _auth.signOut();
  }


  //islogged in checking
  Future<bool?>isLoggedIn()async{
    SharedPreferences _pref=await SharedPreferences.getInstance();
    String? _tocken=await _pref.getString('tocken');

    if(_tocken==null){
      return false;
    }else{
      return true;
    }

  }

}