import 'package:flutter/material.dart';
import 'package:flutterme/customviews/progress_dialog.dart';
import 'package:flutterme/futures/app_futures.dart';
import 'package:flutterme/models/base/EventObject.dart';
import 'package:flutterme/pages/login_page.dart';
import 'package:flutterme/utils/constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final globalKey = new GlobalKey<ScaffoldState>();

  ProgressDialog progressDialog = ProgressDialog.getProgressDialog(ProgressDialogTitles.USER_REGISTER);

  TextEditingController nameController = new TextEditingController(text: "");

  TextEditingController emailController = new TextEditingController(text: "");

  TextEditingController passwordController =
      new TextEditingController(text: "");



  bool isValidEmail(String em) {
    String pass =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(pass);

    return regExp.hasMatch(em);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Register Your Account"),
        ),
        body: new Stack(
          children: <Widget>[_loginContainer(), progressDialog],
        ));
  }


  Widget _loginContainer() {
    return new Container(
        child: new ListView(
      children: <Widget>[
        new Center(
          child: new Column(
            children: <Widget>[
              _formContainer(),

            ],
          ),
        ),
      ],
    ));
  }

  Widget _formContainer() {
    return new Container(
      padding: EdgeInsets.all(20),
      height: 450,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(blurRadius: 5)],
      ),
      child: new Form(
          child: new Theme(
        data: new ThemeData(primarySwatch: Colors.blue),
        child: new Column(
          children: <Widget>[
            _nameContainer(),
            _emailContainer(),
            _passwordContainer(),
            _registerButtonContainer(),
            _loginNowLabel(),
          ],
        ),
      )),
      margin: EdgeInsets.only(top: 20, left: 25, right: 25),
    );
  }

  Widget _nameContainer() {
    return new Container(
        child: new TextFormField(
            controller: nameController,
            decoration: InputDecoration(
                prefixIcon: new Icon(
                  Icons.face,
                  color: Colors.blue,
                ),
                labelText: Texts.NAME,
                labelStyle: TextStyle(fontSize: 18.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
            ),
            keyboardType: TextInputType.text),
        margin: EdgeInsets.only(bottom: 20.0));
  }


  Widget _emailContainer() {
    return new Container(
        child: new TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                prefixIcon: new Icon(
                  Icons.email,
                  color: Colors.blue,
                ),
                labelText: Texts.EMAIL,
                labelStyle: TextStyle(fontSize: 18.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
            ),
            keyboardType: TextInputType.emailAddress),
        margin: EdgeInsets.only(bottom: 20.0));
  }

  Widget _passwordContainer() {
    return new Container(
        child: new TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
              prefixIcon: new Icon(
                Icons.vpn_key,
                color: Colors.blue,
              ),
              labelText: Texts.PASSWORD,
                labelStyle: TextStyle(fontSize: 18.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
            ),
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
        margin: EdgeInsets.only(bottom: 35.0));
  }

  Widget _registerButtonContainer() {
    return new Container(
        width: double.infinity,
        decoration: new BoxDecoration(color: Colors.blue[400], borderRadius: BorderRadius.circular(5)),
        child: new MaterialButton(
          textColor: Colors.white,
          padding: EdgeInsets.all(15.0),
          onPressed: _registerButtonAction,
          child: new Text(
            Texts.REGISTER,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
        margin: EdgeInsets.only(bottom: 30.0));
  }

  Widget _loginNowLabel() {
    return new GestureDetector(
      onTap: _goToLoginScreen,
      child: new Container(
          child: new Text(
            Texts.LOGIN_NOW,
            style: TextStyle(fontSize: 18.0, color: Colors.blue),
          ),
          margin: EdgeInsets.only(bottom: 30.0)),
    );
  }

  void _registerButtonAction() {
    if (nameController.text == "") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(SnackBarText.ENTER_NAME),
      ));
      return;
    }

    if (emailController.text == "") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(SnackBarText.ENTER_EMAIL),
      ));
      return;
    }

    if (!isValidEmail(emailController.text)) {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(SnackBarText.ENTER_VALID_MAIL),
      ));
      return;
    }

    if (emailController.text == "") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(SnackBarText.ENTER_EMAIL),
      ));
      return;
    }

    if (passwordController.text == "") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(SnackBarText.ENTER_PASS),
      ));
      return;
    }
    FocusScope.of(context).requestFocus(new FocusNode());
    progressDialog.showProgress();
    _registerUser(
        nameController.text, emailController.text, passwordController.text);
  }

  void _registerUser(String name, String emailId, String password) async {
    EventObject eventObject = await registerUser(name, emailId, password);
    switch (eventObject.id) {
      case EventConstants.USER_REGISTRATION_SUCCESSFUL:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(SnackBarText.REGISTER_SUCCESSFUL),
            ));
            progressDialog.hideProgress();
            _goToLoginScreen();
          });
        }
        break;
      case EventConstants.USER_ALREADY_REGISTERED:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(SnackBarText.USER_ALREADY_REGISTERED),
            ));
            progressDialog.hideProgress();
          });
        }
        break;
      case EventConstants.USER_REGISTRATION_UN_SUCCESSFUL:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(SnackBarText.REGISTER_UN_SUCCESSFUL),
            ));
            progressDialog.hideProgress();
          });
        }
        break;
      case EventConstants.NO_INTERNET_CONNECTION:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(SnackBarText.NO_INTERNET_CONNECTION),
            ));
            progressDialog.hideProgress();
          });
        }
        break;
    }
  }

  void _goToLoginScreen() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => new LoginPage()),
    );
  }

}
