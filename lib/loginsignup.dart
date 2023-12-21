import 'package:flutter/material.dart';
import 'package:hospital/secondscreen.dart';
import 'package:http/http.dart';
import 'dart:convert';

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key});

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

Future<String?>  login(String email, password) async{ //let's create api
   try{
     Response response = await post(Uri.parse('https://apitest.smartsoft-bd.com/api/login'),
     body:{
       'email': email,
       'password': password,

     }

  );
     if(response.statusCode ==200){
       // print(response.body);
       var data = jsonDecode(response.body);
       return data['data']['token'];

     }else{
       print('faild');
       return null;
     }

   }catch(e){
     print(e.toString());
     return null;
   }
}

class _LoginSignupState extends State<LoginSignup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            //letterSpacing: 10,
            //wordSpacing: 20,
            // this is test

          ),

        ),),


      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Text(
              'Login Page',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                //letterSpacing: 10,
                //wordSpacing: 20,
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
            child: TextField(

              controller: emailController,

              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text(
                    'Email',
                    style: TextStyle(color: Colors.red),
                  ),
                  hintText: 'example@mail.com',
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.key,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text(
                    'Password',
                    style: TextStyle(color: Colors.red),
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),

          GestureDetector(
            onTap: () async {
              String? token = await login(emailController.text.toString(), passwordController.text.toString());

              if (token != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondScreen(token: token),
                  ),
                );
              }
            },
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(300),
              ),

              child: Center(child: Text('Sign In',style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
              ),)),
            ),

            // child: InkWell(
            //    onTap:(){
            //      Navigator.push(context,MaterialPageRoute(builder: (context) => SecondScreen()));
            //    },
            //
            //  ),

          ),



          //ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.login), label: Text('login'))
        ],
      ),
    );
  }
}
