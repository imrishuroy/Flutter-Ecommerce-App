import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/screens/login_screen.dart';
import 'package:flutter_ecommerce_app/screens/products_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _username, _email, _password;

  bool _isSubmitting = false, _obscureText = true;

  Text _showTitle(BuildContext context) {
    return Text(
      'Register',
      style: Theme.of(context).textTheme.headline5,
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      //  print(
      //   'Username : $_username \n Email : $_email \n Password : $_password',
      // );
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });
    http.Response response =
        await http.post('http://localhost:1337/auth/local/register', body: {
      "username": _username,
      "email": _email,
      "password": _password,
    });
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isSubmitting = false;
      });
      _showSnackBar();

      Navigator.pushReplacementNamed(context, ProductsScreen.routeName);

      // print(responseData[0]);
    } else {
      setState(
        () => _isSubmitting = false,
      );

      final String errorMessage =
          (responseData['message'][0]['messages'][0]['message']).toString();
      print(errorMessage);
      _showErrorSnack(errorMessage);
    }
  }

  _showErrorSnack(String errorMessage) {
    final snackbar = SnackBar(
      content: Text(
        errorMessage,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    // throw Exception('Error Regisering $errorMessage');
  }

  _showSnackBar() {
    final snackbar = SnackBar(
      content: Text(
        'User $_username succussfully created',
        // message,
        style: TextStyle(
          color: Colors.green,
        ),
      ),
    );

    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  // _redirectUser() {
  //   Future.delayed(Duration(seconds: 2), () {
  //     Navigator.pushReplacementNamed(context, ProductsScreen.routeName);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _showTitle(context),
                  _showUsernameInput(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showFormActions(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _showFormActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          _isSubmitting
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Colors.green,
                  ),
                )
              : RaisedButton(
                  elevation: 8.0,
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: _submit,
                  child: Text(
                    'Submit',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.white),
                  ),
                ),
          FlatButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            child: Text(
              'Already have an account? Login',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (value) => _password = value,
        validator: (value) => value.length < 6 ? 'Password too short' : null,
        obscureText: _obscureText,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(
                () => _obscureText = !_obscureText,
              );
            },
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          border: OutlineInputBorder(),
          labelText: 'Password',
          hintText: 'Enter password min len 6',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Padding _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (value) => _email = value,
        validator: (value) => !(value.contains('@')) ? 'Invalid Input' : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          hintText: 'Enter your email',
          icon: Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Padding _showUsernameInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (value) => _username = value,
        validator: (value) => value.length < 6 ? 'Username too short' : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Username',
          hintText: 'Enter username min len 6',
          icon: Icon(
            Icons.face,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
