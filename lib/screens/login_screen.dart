import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email, _password;
  bool _obscureText = true;

  Text _showTitle(BuildContext context) {
    return Text(
      'Login',
      style: Theme.of(context).textTheme.headline5,
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      print(
        'Email : $_email \n Password : $_password',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
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
          RaisedButton(
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
              Navigator.pushReplacementNamed(context, '/');
            },
            child: Text(
              'New User? Register',
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
              setState(() {
                _obscureText = !_obscureText;
              });
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
}
