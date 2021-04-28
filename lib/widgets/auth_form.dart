import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail, _userName, _userPassword;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      //use auth request
      widget.submitFn(
        _userEmail.toString().trim(),
        _userName.toString().trim(),
        _userPassword.toString().trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                      ),
                      onSaved: (value) => _userEmail = value,
                    ),
                    if (!_isLogin)
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return "Please insert 4 character username";
                          }
                          return null;
                        },
                        key: ValueKey('username'),
                        decoration: InputDecoration(
                          labelText: 'Username',
                        ),
                        onSaved: (value) => _userName = value,
                      ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return "Please insert 7 character password";
                        }
                        return null;
                      },
                      key: ValueKey('password'),
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      onSaved: (value) => _userPassword = value,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      RaisedButton(
                          child: Text(_isLogin ? 'Login' : 'Sign Up'),
                          onPressed: _trySubmit),
                    SizedBox(
                      height: 20,
                    ),
                    if (!widget.isLoading)
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create new account'
                            : 'I already have an account'),
                        textColor: Theme.of(context).primaryColor,
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
